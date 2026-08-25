import SwiftUI

let segCount = 12

struct LimbState {
    var thick: [Double]
    var width: [Double]
    var setC: [Double]
    var strain: [Double]

    init(width w: [Double], thick t: [Double]) {
        width = w
        thick = t
        setC = Array(repeating: 0, count: w.count)
        strain = Array(repeating: 0, count: w.count)
    }
}

func widthProfile(_ shape: LimbShape, limbWidth: Double, tipWidth: Double) -> [Double] {
    var out: [Double] = []
    for i in 0..<segCount {
        let a = (Double(i) + 0.5) / Double(segCount)
        var f: Double
        switch shape {
        case .longbow: f = pow(1 - a, 0.50)
        case .flatbow: f = a <= 0.45 ? 1.0 : pow((1 - a) / 0.55, 0.80)
        case .pyramid: f = 1 - a
        case .deflex: f = a <= 0.38 ? 1.0 : pow((1 - a) / 0.62, 0.85)
        case .holmegaard: f = a <= 0.55 ? 1.0 : 0.10 + 0.90 * pow((1 - a) / 0.45, 2.4)
        case .recurve: f = 1 - 0.86 * pow(a, 1.35)
        case .composite: f = a <= 0.60 ? 1.0 - 0.10 * a : 0.94 - 0.70 * pow((a - 0.60) / 0.40, 0.85)
        case .yumi: f = 1 - 0.40 * pow(a, 1.6)
        }
        out.append(max(0.10, tipWidth + (limbWidth - tipWidth) * max(0, f)))
    }
    return out
}

func idealThickness(_ widths: [Double]) -> [Double] {
    var out: [Double] = []
    for i in 0..<widths.count {
        let a = (Double(i) + 0.5) / Double(widths.count)
        let moment = max(0.04, 1 - a)
        out.append((moment / widths[i]).squareRoot())
    }
    let peak = out.max() ?? 1
    return out.map { $0 / peak }
}

func roughThickness(_ widths: [Double], seed: UInt64, excess: Double) -> [Double] {
    var rng = Seeded(seed)
    let ideal = idealThickness(widths)
    var out: [Double] = []
    for i in 0..<ideal.count {
        let bump = 1.0 + rng.signed() * 0.065 + sin(Double(i) * 0.9 + rng.d()) * 0.028
        out.append(ideal[i] * excess * bump)
    }
    return out
}

struct LimbCurve {
    var points: [CGPoint]
    var strain: [Double]
    var tipDrop: Double
}

func compliance(_ limb: LimbState, stiffness: Double) -> Double {
    let n = limb.thick.count
    let ds = 1.0 / Double(n)
    var sum = 0.0
    for i in 0..<n {
        let a = (Double(i) + 0.5) / Double(n)
        let arm = max(0.02, 1 - a)
        let inertia = max(1e-6, limb.width[i] * pow(max(0.05, limb.thick[i]), 3))
        sum += arm * arm * ds / (inertia * stiffness)
    }
    return max(1e-6, sum)
}

func bendLimb(_ limb: LimbState, force: Double, stiffness: Double) -> LimbCurve {
    let n = limb.thick.count
    let ds = 1.0 / Double(n)
    var angle = 0.0
    var x = 0.0
    var y = 0.0
    var pts: [CGPoint] = [CGPoint(x: 0, y: 0)]
    var strains: [Double] = []
    for i in 0..<n {
        let a = (Double(i) + 0.5) / Double(n)
        let arm = max(0.02, 1 - a)
        let moment = force * arm
        let thick = max(0.05, limb.thick[i])
        let inertia = max(1e-6, limb.width[i] * pow(thick, 3))
        let area = max(1e-6, limb.width[i] * thick * thick)
        let kappa = moment / (inertia * stiffness) + limb.setC[i]
        strains.append(moment / (area * stiffness) * 0.5)
        angle += kappa * ds
        x += cos(angle) * ds
        y += sin(angle) * ds
        pts.append(CGPoint(x: x, y: y))
    }
    return LimbCurve(points: pts, strain: strains, tipDrop: y)
}

struct DrawReading {
    var force: Double
    var pounds: Double
    var upper: LimbCurve
    var lower: LimbCurve
    var evenness: Double
    var balance: Double
    var peakStrain: Double
    var hotSegment: Int
    var hotUpper: Bool
}

struct BowBuild {
    var upper: LimbState
    var lower: LimbState
    var stiffness: Double
    var calib: Double
    var breakStrain: Double
    var setStrain: Double
    var damage: Double = 0
    var broken: Bool = false

    func reading(draw: Double) -> DrawReading {
        let cu = compliance(upper, stiffness: stiffness)
        let cl = compliance(lower, stiffness: stiffness)
        let force = draw / max(1e-6, cu + cl)
        let curveU = bendLimb(upper, force: force, stiffness: stiffness)
        let curveL = bendLimb(lower, force: force, stiffness: stiffness)
        let all = curveU.strain + curveL.strain
        let mean = all.reduce(0, +) / Double(max(1, all.count))
        var varsum = 0.0
        for s in all { varsum += (s - mean) * (s - mean) }
        let sd = (varsum / Double(max(1, all.count))).squareRoot()
        let evenness = max(0, 1 - (mean > 0 ? sd / mean : 1) / 0.42)
        let bal = max(0, 1 - abs(curveU.tipDrop - curveL.tipDrop) / max(0.02, (curveU.tipDrop + curveL.tipDrop) * 0.5) / 0.30)
        var peak = 0.0
        var hot = 0
        var hotUp = true
        for (i, s) in curveU.strain.enumerated() where s > peak { peak = s; hot = i; hotUp = true }
        for (i, s) in curveL.strain.enumerated() where s > peak { peak = s; hot = i; hotUp = false }
        return DrawReading(force: force, pounds: force * calib, upper: curveU, lower: curveL,
                           evenness: evenness, balance: bal, peakStrain: peak,
                           hotSegment: hot, hotUpper: hotUp)
    }

    mutating func apply(draw: Double) -> String? {
        let r = reading(draw: draw)
        var message: String? = nil
        if r.peakStrain > breakStrain {
            broken = true
            return "The limb let go with a crack you will hear for a week."
        }
        for i in 0..<segCount {
            let su = r.upper.strain[i]
            if su > setStrain {
                upper.setC[i] += (su - setStrain) / max(1e-6, setStrain) * 0.16
                damage += (su - setStrain) / max(1e-6, setStrain)
                message = "The belly is fretting a little on the upper limb."
            }
            let sl = r.lower.strain[i]
            if sl > setStrain {
                lower.setC[i] += (sl - setStrain) / max(1e-6, setStrain) * 0.16
                damage += (sl - setStrain) / max(1e-6, setStrain)
                message = "The belly is fretting a little on the lower limb."
            }
        }
        upper.strain = r.upper.strain
        lower.strain = r.lower.strain
        return message
    }

    mutating func scrape(upperLimb: Bool, segment: Int, amount: Double) {
        var arr = upperLimb ? upper.thick : lower.thick
        for k in max(0, segment - 1)...min(segCount - 1, segment + 1) {
            let w = k == segment ? 1.0 : 0.22
            arr[k] = max(0.06, arr[k] - amount * w)
        }
        if upperLimb { upper.thick = arr } else { lower.thick = arr }
    }

    var stringFollow: Double {
        let su = upper.setC.reduce(0, +)
        let sl = lower.setC.reduce(0, +)
        return (su + sl) * 0.5
    }
}

func makeBuild(_ entry: BowEntry, seed: UInt64, excess: Double = 1.30) -> BowBuild {
    let w = widthProfile(entry.shape, limbWidth: entry.limbWidth, tipWidth: entry.tipWidth)
    let tu = roughThickness(w, seed: seed &+ 11, excess: excess)
    let tl = roughThickness(w, seed: seed &+ 29, excess: excess)
    let upper = LimbState(width: w, thick: tu)
    let lower = LimbState(width: w, thick: tl)
    let stiffness = 0.34 + entry.stiff * 0.40
    let ideal = LimbState(width: w, thick: idealThickness(w))
    let comp = compliance(ideal, stiffness: stiffness)
    let targetDrop = 0.62
    let idealForce = targetDrop / max(1e-6, comp * 2)
    let calib = Double(entry.weight) / max(1e-6, idealForce)
    let refCurve = bendLimb(ideal, force: idealForce, stiffness: stiffness)
    let refStrain = max(1e-6, refCurve.strain.reduce(0, +) / Double(refCurve.strain.count))
    let breakStrain = refStrain * (1.72 + entry.tough * 0.72)
    let setStrain = refStrain * (1.10 + entry.stiff * 0.26)
    return BowBuild(upper: upper, lower: lower, stiffness: stiffness, calib: calib,
                    breakStrain: breakStrain, setStrain: setStrain)
}

func drawFraction(_ inches: Double, of target: Int) -> Double {
    max(0, min(1.2, inches / Double(max(1, target))))
}

func dropForDraw(_ inches: Double, target: Int) -> Double {
    0.62 * (inches / Double(max(1, target)))
}
