import Foundation
import CoreGraphics

func gripAt(_ shape: BowShape) -> Double { shape == .yumi ? 0.36 : 0.50 }

func armOf(_ u: Double, _ grip: Double) -> Double {
    u >= grip ? (u - grip) / max(0.02, 1 - grip) : -(grip - u) / max(0.02, grip)
}

func rawBend(_ shape: BowShape, _ s: Double) -> Double {
    let a = abs(s)
    let c = cos(min(1.0, a) * .pi / 2)
    switch shape {
    case .longbow:  return pow(c, 0.80)
    case .flatbow:  return pow(c, 0.62)
    case .pyramid:  return pow(c, 0.55)
    case .yumi:     return pow(c, 0.92)
    case .deflex:   return pow(c, 0.64) * 0.92 + 0.16 * s
    case .holmegaard:
        let k = 0.58
        if a <= k { return pow(cos(a * .pi / 2), 0.60) }
        let f0 = pow(cos(k * .pi / 2), 0.60)
        let f1 = pow(cos((k - 0.01) * .pi / 2), 0.60)
        let slope = (f0 - f1) / 0.01
        return f0 + slope * (a - k)
    case .recurve:
        return pow(c, 0.60) - 0.82 * pow(max(0, (a - 0.70) / 0.30), 1.6)
    case .composite:
        return pow(c, 0.55) - 1.30 * pow(max(0, (a - 0.60) / 0.40), 1.30)
    }
}

func bendOf(_ shape: BowShape, _ s: Double) -> Double {
    let raw = rawBend(shape, s)
    switch shape {
    case .recurve, .composite: return raw
    default:
        let endU = rawBend(shape, 1), endL = rawBend(shape, -1)
        let lift = s >= 0 ? endU * s : endL * (-s)
        return raw - lift
    }
}

func widthShape(_ shape: BowShape, _ s: Double) -> Double {
    let a = min(1.0, abs(s))
    switch shape {
    case .longbow:  return pow(1 - a, 0.50)
    case .flatbow:  return a <= 0.45 ? 1.0 : pow((1 - a) / 0.55, 0.80)
    case .pyramid:  return 1 - a
    case .deflex:   return a <= 0.38 ? 1.0 : pow((1 - a) / 0.62, 0.85)
    case .holmegaard:
        if a <= 0.55 { return 1.0 }
        return 0.10 + 0.90 * pow((1 - a) / 0.45, 2.4)
    case .recurve:  return 1 - 0.86 * pow(a, 1.35)
    case .composite:
        if a <= 0.60 { return 1.0 - 0.10 * a }
        return 0.94 - 0.70 * pow((a - 0.60) / 0.40, 0.85)
    case .yumi:     return 1 - 0.40 * pow(a, 1.6)
    }
}

func depthFactor(_ shape: BowShape) -> Double {
    switch shape {
    case .longbow:    return 0.0300
    case .flatbow:    return 0.0175
    case .pyramid:    return 0.0195
    case .holmegaard: return 0.0215
    case .recurve:    return 0.0195
    case .composite:  return 0.0160
    case .yumi:       return 0.0165
    case .deflex:     return 0.0185
    }
}

func depthShape(_ shape: BowShape, _ s: Double) -> Double {
    let a = min(1.0, abs(s))
    switch shape {
    case .pyramid:    return 1.0 - 0.08 * a
    case .longbow:    return 1.0 - 0.52 * a
    case .holmegaard: return a <= 0.55 ? 1.0 - 0.30 * a : 0.835 - 0.28 * (a - 0.55)
    case .composite:  return a <= 0.60 ? 1.0 - 0.22 * a : 0.868 + 0.30 * (a - 0.60)
    case .recurve:    return 1.0 - 0.44 * a
    default:          return 1.0 - 0.46 * a
    }
}

struct BowRun {
    var spine: [CGPoint] = []
    var norm: [CGPoint] = []
    var arm: [Double] = []
    var half: [Double] = []
    var wide: [Double] = []
}

func buildRun(_ spec: BowSpec, cx: Double, yTop: Double, yBot: Double,
              brace: Double, span: Double, steps: Int = 220) -> BowRun {
    let grip = gripAt(spec.shape)
    let L = yBot - yTop
    let d0 = L * depthFactor(spec.shape)
    var run = BowRun()
    for i in 0...steps {
        let u = Double(i) / Double(steps)
        let s = armOf(u, grip)
        let y = yTop + L * (1 - u)
        let x = cx + bendOf(spec.shape, s) * brace
        run.spine.append(pt(x, y))
        run.arm.append(s)
        run.half.append(d0 * depthShape(spec.shape, s) * 0.5)
        let wf = widthShape(spec.shape, s)
        run.wide.append((spec.tipWidth + (spec.limbWidth - spec.tipWidth) * wf) * span * 0.5)
    }
    for i in 0...steps {
        let a = run.spine[max(0, i - 1)], b = run.spine[min(steps, i + 1)]
        var tx = Double(b.x - a.x), ty = Double(b.y - a.y)
        let l = (tx * tx + ty * ty).squareRoot()
        if l > 0 { tx /= l; ty /= l } else { tx = 0; ty = 1 }
        run.norm.append(pt(-ty, tx))
    }
    return run
}

func offsetPts(_ run: BowRun, _ k: Double) -> [CGPoint] {
    var out: [CGPoint] = []
    for i in 0..<run.spine.count {
        out.append(pt(Double(run.spine[i].x) + Double(run.norm[i].x) * run.half[i] * k,
                      Double(run.spine[i].y) + Double(run.norm[i].y) * run.half[i] * k))
    }
    return out
}

func stringContact(_ run: BowRun) -> (Int, Int) {
    let n = run.spine.count
    var up = n - 1, lo = 0
    var best = Double(run.spine[n - 1].x)
    var i = n - 1
    while i > n * 6 / 10 { if Double(run.spine[i].x) <= best { best = Double(run.spine[i].x); up = i }; i -= 1 }
    best = Double(run.spine[0].x)
    i = 0
    while i < n * 4 / 10 { if Double(run.spine[i].x) <= best { best = Double(run.spine[i].x); lo = i }; i += 1 }
    return (lo, up)
}

func grainLines(_ p: Plate, _ run: BowRun, count: Int, tone: Tone, weight: Double, seed: UInt64) {
    var rng = Dice(seed)
    for k in 0..<count {
        let f = -0.86 + 1.72 * (Double(k) + rng.r(0.2, 0.8)) / Double(count)
        var pts: [CGPoint] = []
        let n = run.spine.count
        var i = 4
        while i < n - 4 {
            let jitter = rng.signed() * 0.05
            pts.append(pt(Double(run.spine[i].x) + Double(run.norm[i].x) * run.half[i] * (f + jitter),
                          Double(run.spine[i].y) + Double(run.norm[i].y) * run.half[i] * (f + jitter)))
            i += 9
        }
        if pts.count > 2 {
            penBroken(p, pts, weight: weight * rng.r(0.7, 1.2), colour: tone.al(rng.r(0.30, 0.62)),
                      pieces: rng.i(2, 5), gap: 0.05, wobble: 0.5, seed: seed &+ UInt64(k * 31 + 7))
        }
    }
}

func drawNock(_ p: Plate, at q: CGPoint, along n: CGPoint, size: Double, seed: UInt64) {
    let nx = Double(n.x), ny = Double(n.y)
    let a = pt(Double(q.x) - nx * size, Double(q.y) - ny * size)
    let b = pt(Double(q.x) + nx * size, Double(q.y) + ny * size)
    pen(p, [a, b], weight: size * 0.36, colour: Field.ink, wobble: 0.4, taper: false, seed: seed)
    p.disc(Double(q.x) - nx * size * 0.35, Double(q.y) - ny * size * 0.35,
           size * 0.30, Field.ink.al(0.72))
}

func drawSideBow(_ p: Plate, _ spec: BowSpec, cx: Double, yTop: Double, yBot: Double,
                 brace: Double, span: Double, seed: UInt64) {
    let run = buildRun(spec, cx: cx, yTop: yTop, yBot: yBot, brace: brace, span: span)
    let back = offsetPts(run, 1.0)
    let belly = offsetPts(run, -1.0)
    let body = back + belly.reversed()

    let sh = body.map { pt(Double($0.x) - 9, Double($0.y) + 13) }
    p.poly(sh, Field.ink.al(0.10))

    p.poly(body, spec.wood)
    wash(p, body, spec.wood.dk(0.12), strength: 0.16, bleed: 2.5, seed: seed &+ 3)

    let skinK = spec.backed ? 0.42 : 0.30
    if spec.backed || spec.slug.contains("yew") || spec.shape == .longbow {
        let s1 = offsetPts(run, 1.0)
        let s2 = offsetPts(run, 1.0 - skinK)
        p.poly(s1 + s2.reversed(), spec.back.al(0.95))
        pen(p, s2, weight: 1.1, colour: spec.back.dk(0.30).al(0.60), wobble: 0.5, taper: false, seed: seed &+ 9)
    }
    if spec.shape == .composite {
        let h1 = offsetPts(run, -1.0)
        let h2 = offsetPts(run, -0.34)
        p.poly(h1 + h2.reversed(), Field.horn.al(0.92))
        pen(p, h2, weight: 1.0, colour: Field.ink.al(0.45), wobble: 0.4, taper: false, seed: seed &+ 11)
    }

    grainLines(p, run, count: 9, tone: spec.wood.dk(0.34), weight: 1.05, seed: seed &+ 21)

    let bodyPath = pathOf(body)
    var bellyBand: [CGPoint] = []
    let inner = offsetPts(run, -0.24)
    bellyBand = belly + inner.reversed()
    shade(p, pathOf(bellyBand), depth: 2, spacing: 3.4, colour: Field.inkSoft.al(0.42),
          bound: bodyPath, seed: seed &+ 33)
    stipple(p, bodyPath, density: 0.0016, sizeMin: 0.4, sizeMax: 1.1,
            colour: Field.inkSoft.al(0.30), seed: seed &+ 41)

    pen(p, back, weight: 2.0, colour: Field.ink, wobble: 0.7, taper: false, seed: seed &+ 51)
    pen(p, belly, weight: 2.4, colour: Field.ink, wobble: 0.7, taper: false, seed: seed &+ 57)

    let n = run.spine.count
    drawNock(p, at: run.spine[n - 1], along: run.norm[n - 1], size: run.half[n - 1] * 1.7, seed: seed &+ 61)
    drawNock(p, at: run.spine[0], along: run.norm[0], size: run.half[0] * 1.7, seed: seed &+ 63)

    let (lo, up) = stringContact(run)
    let a = run.spine[up], b = run.spine[lo]
    let ax = Double(a.x) - run.half[up] * 1.1, bx = Double(b.x) - run.half[lo] * 1.1
    pen(p, [pt(ax, Double(a.y)), pt(bx, Double(b.y))], weight: 2.2,
        colour: Field.hemp.dk(0.34), wobble: 0.35, taper: false, seed: seed &+ 71)
    pen(p, [pt(ax, Double(a.y)), pt(bx, Double(b.y))], weight: 0.9,
        colour: Field.ink.al(0.55), wobble: 0.3, taper: false, seed: seed &+ 73)

    let mid = n / 2
    let gy = Double(run.spine[mid].y)
    let gx = Double(run.spine[mid].x)
    var rng = Dice(seed &+ 81)
    let gh = run.half[mid]
    for k in 0..<9 {
        let t = Double(k) / 8
        let yy = gy - (yBot - yTop) * 0.048 + (yBot - yTop) * 0.096 * t
        pen(p, [pt(gx - gh * 1.15, yy), pt(gx + gh * 1.15, yy - gh * 0.5)],
            weight: 2.0, colour: Field.leather.dk(rng.r(0, 0.22)), wobble: 0.4,
            taper: false, seed: seed &+ UInt64(k * 13 + 91))
    }
    let sy = Double(run.spine[mid].y)
    caption(p, "\(spec.weight) lb at \(spec.draw)\"", at: cx + brace * 1.05 + span * 0.10,
            sy, size: 25, colour: Field.inkPale, align: .left, tracking: 0.4)
}

func drawBackBow(_ p: Plate, _ spec: BowSpec, cx: Double, yTop: Double, yBot: Double,
                 span: Double, seed: UInt64) {
    let run = buildRun(spec, cx: cx, yTop: yTop, yBot: yBot, brace: 0, span: span)
    var left: [CGPoint] = []
    var right: [CGPoint] = []
    for i in 0..<run.spine.count {
        let y = Double(run.spine[i].y)
        left.append(pt(cx - run.wide[i], y))
        right.append(pt(cx + run.wide[i], y))
    }
    let body = right + left.reversed()
    p.poly(body.map { pt(Double($0.x) - 7, Double($0.y) + 11) }, Field.ink.al(0.09))
    p.poly(body, spec.back.mix(spec.wood, 0.20))
    wash(p, body, spec.wood.dk(0.10), strength: 0.14, bleed: 2.2, seed: seed &+ 5)

    var rng = Dice(seed &+ 101)
    for k in 0..<11 {
        let f = -0.88 + 1.76 * (Double(k) + rng.r(0.25, 0.75)) / 11
        var pts: [CGPoint] = []
        var i = 5
        while i < run.spine.count - 5 {
            pts.append(pt(cx + run.wide[i] * (f + rng.signed() * 0.04), Double(run.spine[i].y)))
            i += 11
        }
        if pts.count > 2 {
            penBroken(p, pts, weight: rng.r(0.7, 1.25),
                      colour: spec.wood.dk(0.36).al(rng.r(0.26, 0.58)),
                      pieces: rng.i(2, 5), gap: 0.05, wobble: 0.6, seed: seed &+ UInt64(k * 17 + 5))
        }
    }
    let bodyPath = pathOf(body)
    var band: [CGPoint] = []
    for i in 0..<run.spine.count {
        band.append(pt(cx - run.wide[i], Double(run.spine[i].y)))
    }
    var band2: [CGPoint] = []
    for i in stride(from: run.spine.count - 1, through: 0, by: -1) {
        band2.append(pt(cx - run.wide[i] * 0.52, Double(run.spine[i].y)))
    }
    shade(p, pathOf(band + band2), depth: 2, spacing: 3.6, colour: Field.inkSoft.al(0.36),
          bound: bodyPath, seed: seed &+ 111)
    pen(p, left, weight: 2.1, colour: Field.ink, wobble: 0.7, taper: false, seed: seed &+ 121)
    pen(p, right, weight: 1.7, colour: Field.ink, wobble: 0.7, taper: false, seed: seed &+ 123)
    pen(p, [left[left.count - 1], right[right.count - 1]], weight: 1.6, colour: Field.ink,
        wobble: 0.4, taper: false, seed: seed &+ 131)
    pen(p, [left[0], right[0]], weight: 1.6, colour: Field.ink, wobble: 0.4, taper: false, seed: seed &+ 133)
    caption(p, "BACK", at: cx, yBot + 42, size: 21, colour: Field.inkPale, align: .centre, tracking: 3.0)
}

func unstrungAmp(_ shape: BowShape) -> Double {
    switch shape {
    case .longbow:    return 0.10
    case .flatbow:    return 0.13
    case .pyramid:    return 0.13
    case .holmegaard: return 0.10
    case .deflex:     return 0.28
    case .yumi:       return -0.28
    case .recurve:    return -0.52
    case .composite:  return -1.00
    }
}

func drawGhost(_ p: Plate, _ spec: BowSpec, cx: Double, yTop: Double, yBot: Double,
               brace: Double, seed: UInt64) {
    let grip = gripAt(spec.shape)
    let amp = unstrungAmp(spec.shape) * brace
    var pts: [CGPoint] = []
    for i in 0...80 {
        let u = Double(i) / 80
        let s = armOf(u, grip)
        let d = pow(cos(min(1.0, abs(s)) * .pi / 2), 0.68)
        pts.append(pt(cx + d * amp, yTop + (yBot - yTop) * (1 - u)))
    }
    penBroken(p, pts, weight: 1.6, colour: Field.inkPale.al(0.62), pieces: 7, gap: 0.12,
              wobble: 0.5, seed: seed)
    caption(p, "UNSTRUNG", at: cx + amp - 66, yTop + (yBot - yTop) * 0.5, size: 18,
            colour: Field.inkPale, align: .right, tracking: 2.0)
}

func drawSection(_ p: Plate, _ spec: BowSpec, cx: Double, cy: Double, scale: Double, seed: UInt64) {
    let w = spec.limbWidth * scale
    let d = max(scale * 0.13, spec.limbWidth * scale * depthFactor(spec.shape) * 15)
    let top = cy - d * 0.5
    let bot = cy + d * 0.5
    var outline: [CGPoint] = []
    switch spec.shape {
    case .longbow:
        outline.append(pt(cx - w * 0.5, top))
        outline.append(pt(cx + w * 0.5, top))
        for i in 0...40 {
            let t = Double(i) / 40
            let a = t * .pi
            outline.append(pt(cx + cos(a) * w * 0.5, top + sin(a) * d * 1.5))
        }
    case .composite, .yumi:
        outline = [pt(cx - w * 0.5, top), pt(cx + w * 0.5, top),
                   pt(cx + w * 0.42, bot), pt(cx - w * 0.42, bot)]
    default:
        outline = [pt(cx - w * 0.5, top), pt(cx + w * 0.5, top),
                   pt(cx + w * 0.46, bot), pt(cx - w * 0.46, bot)]
    }
    p.poly(outline, spec.wood)
    if spec.shape == .composite {
        p.poly([pt(cx - w * 0.5, top), pt(cx + w * 0.5, top),
                pt(cx + w * 0.5, top + d * 0.30), pt(cx - w * 0.5, top + d * 0.30)], Field.sinew)
        p.poly([pt(cx - w * 0.47, cy + d * 0.06), pt(cx + w * 0.47, cy + d * 0.06),
                pt(cx + w * 0.42, bot), pt(cx - w * 0.42, bot)], Field.horn)
    } else if spec.backed || spec.shape == .longbow {
        let skin = spec.shape == .longbow ? d * 0.55 : d * 0.30
        p.poly([pt(cx - w * 0.5, top), pt(cx + w * 0.5, top),
                pt(cx + w * 0.5, top + skin), pt(cx - w * 0.5, top + skin)], spec.back)
        pen(p, [pt(cx - w * 0.5, top + skin), pt(cx + w * 0.5, top + skin)], weight: 1.2,
            colour: Field.oakDark.al(0.5), wobble: 0.4, taper: false, seed: seed &+ 3)
    }
    formShade(p, outline, inset: d * 0.6, depth: 2, spacing: 3.0,
              colour: Field.inkSoft.al(0.40), seed: seed &+ 7)
    penContour(p, outline, weight: 2.2, colour: Field.ink, seed: seed &+ 9)
    tick(p, from: pt(cx - w * 0.5, bot + d * 0.9 + 18), to: pt(cx + w * 0.5, bot + d * 0.9 + 18),
         label: "", seed: seed &+ 11)
    caption(p, "SECTION AT THE GRIP", at: cx, bot + d * 0.9 + 62, size: 19, colour: Field.inkPale,
            align: .centre, tracking: 2.4)
}

func makeBowPlate(_ spec: BowSpec, dir: String) {
    let W = 1100, H = 1500
    let p = Plate(W, H, scale: plateScale)
    p.topDown()
    p.light = -0.88
    let seed = hashOf(spec.slug)
    layPaper(p, seed: seed, tone: Field.paperWarm)

    let yBot = 1160.0
    let L = 640.0 + 330.0 * spec.length
    let yTop = yBot - L
    let cx = 420.0
    let brace = 118.0
    let span = 250.0
    drawGhost(p, spec, cx: cx, yTop: yTop, yBot: yBot, brace: brace, seed: seed &+ 300)
    drawSideBow(p, spec, cx: cx, yTop: yTop, yBot: yBot, brace: brace, span: span, seed: seed)
    drawBackBow(p, spec, cx: 850, yTop: yTop, yBot: yBot, span: span * 0.80, seed: seed &+ 500)
    drawSection(p, spec, cx: 850, cy: 1270, scale: 430, seed: seed &+ 900)
    tick(p, from: pt(112, yTop), to: pt(112, yBot), label: "", seed: seed &+ 601)
    caption(p, "\(Int(spec.length * 78)) in", at: 88, (yTop + yBot) / 2, size: 21,
            colour: Field.inkPale, align: .centre, tracking: 1.0, rotate: -.pi / 2)

    caption(p, spec.name.uppercased(), at: Double(W) / 2, 96, size: 44,
            colour: Field.ink, align: .centre, tracking: 4.5)
    caption(p, "\(spec.place)  ·  \(spec.era)  ·  \(spec.timber)", at: Double(W) / 2, 140,
            size: 24, colour: Field.inkPale, align: .centre, tracking: 1.6)
    let lines = wrapText(spec.line, width: 560, size: 24)
    for (i, l) in lines.prefix(2).enumerated() {
        caption(p, l, at: 330, 1268 + Double(i) * 34, size: 24,
                colour: Field.inkSoft, align: .centre)
    }
    pen(p, [pt(150, 1226), pt(510, 1226)], weight: 1.4, colour: Field.inkPale.al(0.7),
        wobble: 0.5, taper: true, seed: seed &+ 777)
    plateFrame(p, inset: 40, seed: seed &+ 999)
    p.write(dir, "bow-\(spec.slug)", quality: 0.93)
}
