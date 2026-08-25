import SwiftUI

enum BenchStage: Int, CaseIterable {
    case stave, rough, tiller, brace, shoot

    var title: String {
        switch self {
        case .stave: return "Read the Stave"
        case .rough: return "Rough Out"
        case .tiller: return "Tiller"
        case .brace: return "Brace and Shoot In"
        case .shoot: return "First Arrow"
        }
    }
    var order: Int { rawValue + 1 }
    var lead: String {
        switch self {
        case .stave: return "Choose the ring that will become the back"
        case .rough: return "Take the limb down to floor tiller thickness"
        case .tiller: return "Draw a notch at a time and keep the curve even"
        case .brace: return "Set the brace height and shoot the bow in"
        case .shoot: return "Draw, hold and loose"
        }
    }
}

struct RingSlice: Identifiable {
    let index: Int
    let thickness: Double
    let sound: Bool
    let quality: Double
    var id: Int { index }
}

func makeRings(_ entry: BowEntry, seed: UInt64) -> [RingSlice] {
    var rng = Seeded(seed)
    var out: [RingSlice] = []
    let n = 14
    let favourFast = entry.ring == .porous || entry.ring == .board
    for i in 0..<n {
        let t = rng.r(0.30, 1.0)
        var sound = rng.chance(0.80)
        if i == n - 1 { sound = true }
        var q = favourFast ? t : (1.1 - t)
        q *= sound ? 1.0 : 0.32
        q *= 0.72 + 0.28 * (Double(i) / Double(n - 1))
        out.append(RingSlice(index: i, thickness: t, sound: sound, quality: max(0.06, min(1, q))))
    }
    return out
}

final class MakeSession: ObservableObject {
    @Published var entry: BowEntry
    @Published var stage: BenchStage = .stave
    @Published var build: BowBuild
    @Published var rings: [RingSlice]
    @Published var chosenRing: Int? = nil
    @Published var staveScore: Double = 0
    @Published var roughScore: Double = 0
    @Published var tillerScore: Double = 0
    @Published var braceScore: Double = 0
    @Published var shootScore: Double = 0
    @Published var notch: Int = 8
    @Published var braceHeight: Double = 6.5
    @Published var shotsIn: Int = 0
    @Published var message: String? = nil
    @Published var failed: Bool = false
    @Published var finishedID: String? = nil
    @Published var scrapesUsed: Int = 0
    @Published var pulled: Double = 0

    let seed: UInt64

    init(entry: BowEntry, seed: UInt64) {
        self.entry = entry
        self.seed = seed
        self.build = makeBuild(entry, seed: seed)
        self.rings = makeRings(entry, seed: seed &+ 77)
    }

    var notchInches: Double { Double(notch) * 2 }
    var maxNotch: Int { Int((Double(entry.draw) / 2).rounded(.down)) }

    var currentDrop: Double { dropForDraw(notchInches, target: entry.draw) }

    var reading: DrawReading { build.reading(draw: currentDrop) }

    func advance() {
        if let next = BenchStage(rawValue: stage.rawValue + 1) {
            stage = next
            message = nil
        }
    }

    func confirmRing() {
        guard let r = chosenRing else { return }
        let q = rings[r].quality
        staveScore = q
        let bonus = 0.86 + q * 0.28
        build = makeBuild(entry, seed: seed, excess: 1.44 - q * 0.10)
        build.breakStrain *= bonus
        advance()
    }

    func finishRough(_ score: Double) {
        roughScore = score
        advance()
    }

    var roughTarget: [Double] {
        idealThickness(build.upper.width).map { $0 * 1.30 }
    }

    func plane(upper: Bool, segment: Int, amount: Double) {
        guard segment >= 0 && segment < segCount else { return }
        var arr = upper ? build.upper.thick : build.lower.thick
        for k in max(0, segment - 1)...min(segCount - 1, segment + 1) {
            let w = k == segment ? 1.0 : 0.45
            arr[k] = max(0.08, arr[k] - amount * w)
        }
        if upper { build.upper.thick = arr } else { build.lower.thick = arr }
        objectWillChange.send()
    }

    var roughCloseness: Double {
        let t = roughTarget
        var err = 0.0
        for i in 0..<segCount {
            err += abs(build.upper.thick[i] - t[i]) / t[i]
            err += abs(build.lower.thick[i] - t[i]) / t[i]
        }
        err /= Double(segCount * 2)
        return max(0, 1 - err / 0.20)
    }

    func scrape(upper: Bool, segment: Int) {
        guard !build.broken else { return }
        build.scrape(upperLimb: upper, segment: segment, amount: 0.014)
        scrapesUsed += 1
        objectWillChange.send()
    }

    func pullToNotch() {
        guard !build.broken else { return }
        if let m = build.apply(draw: currentDrop) {
            message = m
        } else {
            message = nil
        }
        if build.broken { failed = true }
        objectWillChange.send()
    }

    func stepNotch(_ d: Int) {
        notch = max(7, min(maxNotch, notch + d))
        objectWillChange.send()
    }

    var weightNow: Double { reading.pounds }

    var weightError: Double {
        abs(weightNow - Double(entry.weight)) / Double(entry.weight)
    }

    var tillerReady: Bool {
        notch >= maxNotch && !build.broken
    }

    func finishTiller() {
        let r = reading
        let w = max(0, 1 - weightError / 0.22)
        tillerScore = max(0, min(1, r.evenness * 0.44 + r.balance * 0.26 + w * 0.30))
        advance()
    }

    func finishBrace(_ score: Double) {
        braceScore = score
        advance()
    }

    var followInches: Double { min(4.2, build.stringFollow * 3.4) }

    var castScore: Double {
        let even = reading.evenness
        let setPenalty = min(0.5, followInches / 8)
        return max(0.15, min(1, 0.42 + even * 0.42 + braceScore * 0.16 - setPenalty))
    }

    var overall: Double {
        max(0, min(1, staveScore * 0.14 + roughScore * 0.16 + tillerScore * 0.42
                   + braceScore * 0.16 + shootScore * 0.12))
    }
}
