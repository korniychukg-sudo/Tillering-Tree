import Foundation
import CoreGraphics

struct ToolSpec {
    let slug: String
    let name: String
    let kind: String
    let line: String
}

let toolBook: [ToolSpec] = [
    ToolSpec(slug: "drawknife", name: "Drawknife", kind: "drawknife",
             line: "Pulled toward you with both hands. It removes wood faster than anything else in the shop and it is entirely capable of removing too much."),
    ToolSpec(slug: "spokeshave", name: "Spokeshave", kind: "spokeshave",
             line: "A tiny plane with handles. Set the iron fine and it takes shavings you can read a newspaper through."),
    ToolSpec(slug: "rasp", name: "Cabinet Rasp", kind: "rasp",
             line: "Hand stitched teeth in staggered rows so it cuts without leaving tracks. The coarse side hogs, the fine side finishes."),
    ToolSpec(slug: "scraper", name: "Cabinet Scraper", kind: "scraper",
             line: "A rectangle of steel with a burnished hook on the edge. It is the last tool a bow sees, and it is what tillering is actually done with."),
    ToolSpec(slug: "gizmo", name: "Tiller Gizmo", kind: "gizmo",
             line: "A block with a pencil sticking through it, run along the limb. Where the limb bends more than the block, the pencil marks it. Nothing else finds a hinge as fast."),
    ToolSpec(slug: "square", name: "Bow Square", kind: "square",
             line: "Clips to the string and reads brace height and nocking point together. Small, cheap, and the difference between guessing and knowing."),
    ToolSpec(slug: "tree", name: "Tillering Tree", kind: "tree",
             line: "A post, a cradle and a row of notches two inches apart. Its whole purpose is to let you stand eight feet back and look."),
    ToolSpec(slug: "scale", name: "Spring Scale", kind: "scale",
             line: "Hung on the string below the tree. Draw weight is a number, and until you hang a scale on it, it is only an opinion."),
    ToolSpec(slug: "stave", name: "Split Stave", kind: "stave",
             line: "Half a log, riven rather than sawn, so the split follows the grain and the grain follows the whole length of the bow."),
    ToolSpec(slug: "arrow", name: "Arrow", kind: "arrow",
             line: "Shaft, point, nock and three feathers set at a slight helical. Its spine has to suit the bow or the best tiller in the world will not group."),
]

func hatchShape(_ p: Plate, _ pts: [CGPoint], tone: Tone, depth: Int, spacing: Double, seed: UInt64) {
    guard pts.count > 2 else { return }
    let path = pathOf(pts)
    let box = path.boundingBox
    let sh = pts.map { pt(Double($0.x) - Double(box.width) * 0.05 - 10,
                          Double($0.y) + Double(box.height) * 0.10 + 14) }
    p.poly(sh, Field.ink.al(0.11))
    p.poly(pts, tone)
    let cut: [CGPoint] = [
        pt(Double(box.minX) - 10, Double(box.midY) - Double(box.height) * 0.10),
        pt(Double(box.maxX) + 10, Double(box.midY) + Double(box.height) * 0.20),
        pt(Double(box.maxX) + 10, Double(box.maxY) + 10),
        pt(Double(box.minX) - 10, Double(box.maxY) + 10)]
    shade(p, pathOf(cut), depth: depth, spacing: spacing,
          colour: Field.inkSoft.al(0.46), bound: path, seed: seed)
    let lit: [CGPoint] = [
        pt(Double(box.minX) - 10, Double(box.minY) - 10),
        pt(Double(box.maxX) + 10, Double(box.minY) - 10),
        pt(Double(box.maxX) + 10, Double(box.minY) + Double(box.height) * 0.22),
        pt(Double(box.minX) - 10, Double(box.minY) + Double(box.height) * 0.14)]
    p.clipBoth(path, pathOf(lit)) {
        p.poly(pts, tone.lt(0.24).al(0.55))
    }
    stipple(p, path, density: 0.0011, sizeMin: 0.4, sizeMax: 1.2,
            colour: Field.inkSoft.al(0.26), seed: seed &+ 3)
    penContour(p, pts, weight: 2.6, colour: Field.ink, seed: seed &+ 5)
}

func drawTool(_ p: Plate, _ t: ToolSpec, cx: Double, cy: Double, seed: UInt64) {
    switch t.kind {
    case "drawknife":
        let bladeTop = cy - 26.0
        var blade: [CGPoint] = []
        for i in 0...30 {
            let u = Double(i) / 30
            blade.append(pt(cx - 260 + 520 * u, bladeTop - sin(u * .pi) * 12))
        }
        for i in stride(from: 30, through: 0, by: -1) {
            let u = Double(i) / 30
            blade.append(pt(cx - 260 + 520 * u, bladeTop + 44 - sin(u * .pi) * 12))
        }
        hatchShape(p, blade, tone: Field.steel, depth: 2, spacing: 5.0, seed: seed)
        var edge: [CGPoint] = []
        for i in 0...30 {
            let u = Double(i) / 30
            edge.append(pt(cx - 260 + 520 * u, bladeTop + 44 - sin(u * .pi) * 12))
        }
        pen(p, edge, weight: 3.0, colour: Field.ink, wobble: 0.5, taper: false, seed: seed &+ 7)
        for side in [-1.0, 1.0] {
            let hx = cx + side * 254
            pen(p, [pt(hx, bladeTop + 22), pt(hx + side * 34, bladeTop + 22)],
                weight: 9, colour: Field.iron, wobble: 0.4, taper: false,
                seed: seed &+ UInt64(side + 40))
            var handle: [CGPoint] = []
            for i in 0...26 {
                let u = Double(i) / 26
                let r = 26 * (0.50 + 0.50 * sin(u * .pi * 0.94 + 0.16))
                handle.append(pt(hx + side * (26 + u * 96), bladeTop + 22 - r))
            }
            for i in stride(from: 26, through: 0, by: -1) {
                let u = Double(i) / 26
                let r = 26 * (0.50 + 0.50 * sin(u * .pi * 0.94 + 0.16))
                handle.append(pt(hx + side * (26 + u * 96), bladeTop + 22 + r))
            }
            hatchShape(p, handle, tone: Field.beech, depth: 2, spacing: 4.4, seed: seed &+ UInt64(side + 20))
        }
    case "spokeshave":
        var bodyPts: [CGPoint] = []
        for i in 0...36 {
            let u = Double(i) / 36
            bodyPts.append(pt(cx - 210 + 420 * u, cy - 40 - sin(u * .pi) * 26))
        }
        bodyPts.append(pt(cx + 210, cy + 34))
        for i in stride(from: 36, through: 0, by: -1) {
            let u = Double(i) / 36
            bodyPts.append(pt(cx - 210 + 420 * u, cy + 34 - (u > 0.28 && u < 0.72 ? 0 : 0)))
        }
        bodyPts.append(pt(cx - 210, cy - 40))
        hatchShape(p, bodyPts, tone: Field.brass, depth: 2, spacing: 5.0, seed: seed)
        p.poly([pt(cx - 66, cy - 52), pt(cx + 66, cy - 52), pt(cx + 58, cy + 18), pt(cx - 58, cy + 18)], Field.iron)
        penContour(p, [pt(cx - 66, cy - 52), pt(cx + 66, cy - 52), pt(cx + 58, cy + 18), pt(cx - 58, cy + 18)],
                   weight: 2.0, colour: Field.ink, seed: seed &+ 7)
        for side in [-1.0, 1.0] {
            p.disc(cx + side * 30, cy - 74, 16, Field.brassDark)
            penContour(p, ringPoints(cx: cx + side * 30, cy: cy - 74, rx: 16, ry: 16, steps: 24),
                       weight: 1.8, colour: Field.ink, seed: seed &+ UInt64(side + 30))
        }
    case "rasp":
        let pts: [CGPoint] = [pt(cx - 240, cy - 26), pt(cx + 160, cy - 34), pt(cx + 250, cy - 12),
                              pt(cx + 250, cy + 12), pt(cx + 160, cy + 34), pt(cx - 240, cy + 26)]
        hatchShape(p, pts, tone: Field.steel.dk(0.10), depth: 2, spacing: 5.4, seed: seed)
        var rng = Dice(seed &+ 11)
        p.clip(pathOf(pts)) {
            for r in 0..<26 {
                for c in 0..<46 {
                    let x = cx - 236 + Double(c) * 9 + (r % 2 == 0 ? 0 : 4.5) + rng.signed() * 1.4
                    let y = cy - 24 + Double(r) * 1.9 + rng.signed() * 0.8
                    p.disc(x, y, rng.r(0.9, 1.8), Field.ink.al(rng.r(0.30, 0.72)))
                }
            }
        }
        var handle: [CGPoint] = []
        for i in 0...26 {
            let u = Double(i) / 26
            let r = 30 * (0.42 + 0.58 * sin(u * .pi * 0.9 + 0.25))
            handle.append(pt(cx - 240 - u * 150, cy - r))
        }
        for i in stride(from: 26, through: 0, by: -1) {
            let u = Double(i) / 26
            let r = 30 * (0.42 + 0.58 * sin(u * .pi * 0.9 + 0.25))
            handle.append(pt(cx - 240 - u * 150, cy + r))
        }
        hatchShape(p, handle, tone: Field.walnut, depth: 2, spacing: 4.4, seed: seed &+ 21)
    case "scraper":
        let pts: [CGPoint] = [pt(cx - 190, cy - 110), pt(cx + 190, cy - 110),
                              pt(cx + 190, cy + 110), pt(cx - 190, cy + 110)]
        hatchShape(p, pts, tone: Field.steel, depth: 2, spacing: 5.6, seed: seed)
        p.poly([pt(cx - 190, cy + 92), pt(cx + 190, cy + 92),
                pt(cx + 190, cy + 110), pt(cx - 190, cy + 110)], Field.steel.lt(0.26))
        pen(p, [pt(cx - 190, cy + 92), pt(cx + 190, cy + 92)], weight: 1.6,
            colour: Field.ink.al(0.5), wobble: 0.4, taper: false, seed: seed &+ 6)
        pen(p, [pt(cx - 190, cy + 110), pt(cx + 190, cy + 110)], weight: 4.2,
            colour: Field.ink, wobble: 0.4, taper: false, seed: seed &+ 7)
        caption(p, "BURNISHED HOOK", at: cx + 184, cy + 146, size: 16,
                colour: Field.inkPale, align: .right, tracking: 1.2)
        var rng = Dice(seed &+ 13)
        for i in 0..<9 {
            var pts2: [CGPoint] = []
            let base = cy - 90 + Double(i) * 22
            var x = cx - 170.0
            while x < cx + 170 { pts2.append(pt(x, base + rng.signed() * 3)); x += 44 }
            penBroken(p, pts2, weight: 0.9, colour: Field.inkPale.al(0.4), pieces: 3, gap: 0.06,
                      wobble: 0.6, seed: seed &+ UInt64(i * 5 + 17))
        }
        for i in 0..<6 {
            let x = cx - 160 + Double(i) * 64
            var sh: [CGPoint] = []
            for k in 0...24 {
                let u = Double(k) / 24
                sh.append(pt(x + sin(u * 7.4) * 20, cy + 170 + u * 130))
            }
            pen(p, sh, weight: 3.0, colour: Field.pine.dk(0.06), wobble: 0.8, taper: true,
                seed: seed &+ UInt64(i * 3 + 41))
            pen(p, sh, weight: 1.2, colour: Field.oakDark.al(0.35), wobble: 0.6, taper: true,
                seed: seed &+ UInt64(i * 5 + 47))
        }
    case "gizmo":
        let pts: [CGPoint] = [pt(cx - 150, cy - 90), pt(cx + 150, cy - 90),
                              pt(cx + 150, cy + 40), pt(cx - 150, cy + 40)]
        hatchShape(p, pts, tone: Field.beech, depth: 2, spacing: 4.8, seed: seed)
        p.poly([pt(cx - 8, cy - 130), pt(cx + 8, cy - 130), pt(cx + 8, cy + 84), pt(cx - 8, cy + 84)], Field.gilt)
        p.poly([pt(cx - 8, cy + 84), pt(cx + 8, cy + 84), pt(cx, cy + 106)], Field.ink)
        penContour(p, [pt(cx - 8, cy - 130), pt(cx + 8, cy - 130), pt(cx + 8, cy + 84), pt(cx - 8, cy + 84)],
                   weight: 1.8, colour: Field.ink, seed: seed &+ 9)
        var arc: [CGPoint] = []
        for i in 0...40 {
            let u = Double(i) / 40
            arc.append(pt(cx - 300 + 600 * u, cy + 150 - sin(u * .pi) * 34))
        }
        limbBand(p, arc, half: 18, wood: Field.osage, seed: seed &+ 27, taperTip: false)
    case "square":
        hatchShape(p, [pt(cx - 30, cy - 200), pt(cx + 30, cy - 200), pt(cx + 30, cy + 200), pt(cx - 30, cy + 200)],
                   tone: Field.bone, depth: 1, spacing: 6.0, seed: seed)
        hatchShape(p, [pt(cx + 30, cy - 200), pt(cx + 210, cy - 200), pt(cx + 210, cy - 150), pt(cx + 30, cy - 150)],
                   tone: Field.bone, depth: 1, spacing: 6.0, seed: seed &+ 3)
        for i in 0...16 {
            let y = cy - 190 + Double(i) * 24
            let long = i % 4 == 0
            pen(p, [pt(cx - 26, y), pt(cx - 26 + (long ? 34 : 20), y)], weight: 1.3,
                colour: Field.ink, wobble: 0.3, taper: false, seed: seed &+ UInt64(i))
            if long { caption(p, "\(i / 4 + 4)", at: cx + 20, y + 7, size: 17, colour: Field.inkSoft, align: .right) }
        }
        pen(p, [pt(cx - 90, cy - 240), pt(cx - 90, cy + 240)], weight: 2.0,
            colour: Field.hemp.dk(0.30), wobble: 0.4, taper: false, seed: seed &+ 31)
    case "tree":
        hatchShape(p, [pt(cx - 34, cy - 260), pt(cx + 34, cy - 260), pt(cx + 34, cy + 250), pt(cx - 34, cy + 250)],
                   tone: Field.oak, depth: 2, spacing: 5.2, seed: seed)
        for i in 0..<9 {
            let y = cy - 130 + Double(i) * 44
            pen(p, [pt(cx + 34, y), pt(cx + 72, y - 12)], weight: 2.2, colour: Field.ink,
                wobble: 0.4, taper: false, seed: seed &+ UInt64(i * 3))
        }
        hatchShape(p, [pt(cx - 60, cy - 300), pt(cx + 60, cy - 300), pt(cx + 60, cy - 250), pt(cx - 60, cy - 250)],
                   tone: Field.leather, depth: 2, spacing: 4.6, seed: seed &+ 41)
        let arc = arcPts(cx: cx + 96, yTop: cy - 340, yBot: cy + 60, amp: 54, exp: 0.62)
        limbBand(p, arc, half: 12, wood: Field.osage, seed: seed &+ 51)
        pen(p, [arc[arc.count - 1], pt(cx + 60, cy + 160), arc[0]], weight: 1.8,
            colour: Field.hemp.dk(0.28), wobble: 0.3, taper: false, seed: seed &+ 53)
    case "scale":
        hatchShape(p, [pt(cx - 60, cy - 160), pt(cx + 60, cy - 160), pt(cx + 60, cy + 160), pt(cx - 60, cy + 160)],
                   tone: Field.steel.lt(0.18), depth: 2, spacing: 5.0, seed: seed)
        p.rect(cx - 34, cy - 120, 68, 220, Field.bone)
        penContour(p, [pt(cx - 34, cy - 120), pt(cx + 34, cy - 120), pt(cx + 34, cy + 100), pt(cx - 34, cy + 100)],
                   weight: 1.8, colour: Field.ink, seed: seed &+ 5)
        for i in 0...11 {
            let y = cy - 110 + Double(i) * 19
            pen(p, [pt(cx - 30, y), pt(cx - 30 + (i % 2 == 0 ? 24 : 14), y)], weight: 1.2,
                colour: Field.ink, wobble: 0.3, taper: false, seed: seed &+ UInt64(i + 9))
        }
        pen(p, [pt(cx - 6, cy - 40), pt(cx + 30, cy - 40)], weight: 3.0, colour: Field.oxblood,
            wobble: 0.3, taper: false, seed: seed &+ 21)
        pen(p, [pt(cx, cy - 200), pt(cx, cy - 160)], weight: 2.4, colour: Field.iron,
            wobble: 0.3, taper: false, seed: seed &+ 23)
        penContour(p, ringPoints(cx: cx, cy: cy - 216, rx: 22, ry: 22, steps: 30),
                   weight: 2.4, colour: Field.iron, seed: seed &+ 25)
        pen(p, [pt(cx, cy + 160), pt(cx, cy + 200)], weight: 2.4, colour: Field.iron,
            wobble: 0.3, taper: false, seed: seed &+ 27)
    case "stave":
        var top: [CGPoint] = []
        var bot: [CGPoint] = []
        var rng = Dice(seed &+ 3)
        for i in 0...40 {
            let u = Double(i) / 40
            top.append(pt(cx - 300 + 600 * u, cy - 62 + sin(u * 5.2) * 9 + rng.signed() * 2))
            bot.append(pt(cx - 300 + 600 * u, cy + 62 + sin(u * 4.1 + 1) * 7 + rng.signed() * 2))
        }
        hatchShape(p, top + bot.reversed(), tone: Field.yew, depth: 2, spacing: 5.2, seed: seed)
        var sap: [CGPoint] = []
        for i in 0...40 {
            let u = Double(i) / 40
            sap.append(pt(cx - 300 + 600 * u, cy - 34 + sin(u * 5.2) * 8))
        }
        p.poly(top + sap.reversed(), Field.yewSap)
        pen(p, sap, weight: 1.6, colour: Field.oakDark.al(0.55), wobble: 0.6, taper: false, seed: seed &+ 7)
        for k in 0..<7 {
            var pts: [CGPoint] = []
            for i in 0...40 {
                let u = Double(i) / 40
                pts.append(pt(cx - 300 + 600 * u, cy - 16 + Double(k) * 12 + sin(u * 4.6 + Double(k)) * 6))
            }
            penBroken(p, pts, weight: 1.0, colour: Field.yewHeart.al(0.45), pieces: 3, gap: 0.05,
                      wobble: 0.6, seed: seed &+ UInt64(k * 11 + 13))
        }
    default:
        var shaft: [CGPoint] = [pt(cx - 330, cy - 7), pt(cx + 300, cy - 7),
                                pt(cx + 300, cy + 7), pt(cx - 330, cy + 7)]
        hatchShape(p, shaft, tone: Field.pine, depth: 1, spacing: 6.0, seed: seed)
        shaft = []
        p.poly([pt(cx + 300, cy - 7), pt(cx + 372, cy), pt(cx + 300, cy + 7)], Field.iron)
        penContour(p, [pt(cx + 300, cy - 7), pt(cx + 372, cy), pt(cx + 300, cy + 7)],
                   weight: 1.8, colour: Field.ink, seed: seed &+ 5)
        p.poly([pt(cx - 330, cy - 11), pt(cx - 300, cy - 11), pt(cx - 300, cy + 11), pt(cx - 330, cy + 11)], Field.horn)
        pen(p, [pt(cx - 322, cy - 10), pt(cx - 322, cy + 10)], weight: 2.4, colour: Field.paperWarm,
            wobble: 0.2, taper: false, seed: seed &+ 7)
        let sides: [Double] = [-1.0, 1.0, -1.0]
        for k in 0..<3 {
            let side: Double = sides[k]
            let x0: Double = cx - 280 + Double(k) * 6
            var vane: [CGPoint] = []
            for i in 0...24 {
                let u: Double = Double(i) / 24.0
                let vy: Double = cy + side * (7.0 + sin(u * Double.pi) * 30.0)
                vane.append(pt(x0 + u * 150.0, vy))
            }
            vane.append(pt(x0 + 150.0, cy + side * 7.0))
            let tone = k == 1 ? Field.oxblood.lt(0.20) : Field.bone
            p.poly(vane, tone)
            penContour(p, vane, weight: 1.5, colour: Field.ink, seed: seed &+ UInt64(k * 7 + 11))
            var rng = Dice(seed &+ UInt64(k * 31))
            for i in 0..<16 {
                let u: Double = Double(i) / 16.0
                let ay: Double = cy + side * 8.0
                let by: Double = cy + side * (7.0 + sin(u * Double.pi) * 28.0)
                let ax: Double = x0 + u * 150.0
                pen(p, [pt(ax, ay), pt(ax + 8.0, by)],
                    weight: 0.8, colour: Field.ink.al(rng.r(0.20, 0.45)), wobble: 0.3,
                    taper: false, seed: seed &+ UInt64(i + k * 41))
            }
        }
    }
}

func toolScale(_ kind: String) -> CGFloat {
    switch kind {
    case "tree": return 1.02
    case "scale": return 1.16
    case "square": return 1.22
    case "scraper": return 1.30
    default: return 1.48
    }
}

func makeToolPlate(_ t: ToolSpec, dir: String) {
    let W = 1100, H = 1100
    let p = Plate(W, H, scale: plateScale)
    p.topDown()
    p.light = -0.88
    let seed = hashOf("tool-" + t.slug)
    layPaper(p, seed: seed, tone: Field.paperWarm)
    caption(p, t.name.uppercased(), at: Double(W) / 2, 100, size: 40, colour: Field.ink,
            align: .centre, tracking: 4.0)
    pen(p, [pt(340, 128), pt(760, 128)], weight: 1.4, colour: Field.inkPale.al(0.7),
        wobble: 0.5, taper: true, seed: seed &+ 3)
    p.ctx.saveGState()
    p.ctx.translateBy(x: CGFloat(Double(W) / 2), y: 540)
    let k = toolScale(t.kind)
    p.ctx.scaleBy(x: k, y: k)
    p.ctx.translateBy(x: CGFloat(-Double(W) / 2), y: -540)
    drawTool(p, t, cx: Double(W) / 2, cy: 540, seed: seed &+ 77)
    p.ctx.restoreGState()
    var y = 880.0
    for line in wrapText(t.line, width: 900, size: 23) {
        caption(p, line, at: Double(W) / 2, y, size: 23, colour: Field.inkSoft, align: .centre)
        y += 31
    }
    plateFrame(p, inset: 40, seed: seed &+ 999)
    p.write(dir, "tool-\(t.slug)", quality: 0.93)
}

func makeGround(_ slug: String, _ index: Int, dir: String) {
    let W = 1400, H = 900
    let p = Plate(W, H, scale: plateScale)
    p.topDown()
    p.light = -0.88
    let seed = hashOf("ground-" + slug)
    var rng = Dice(seed)
    let base: Tone
    switch index % 6 {
    case 0: base = Field.paperWarm
    case 1: base = Field.canvas
    case 2: base = Field.linen
    case 3: base = Field.paperCool
    case 4: base = Field.bareWood.lt(0.30)
    default: base = Field.paper
    }
    layPaper(p, seed: seed, tone: base)
    for k in 0..<7 {
        washBand(p, from: Double(k) * Double(H) / 7, to: Double(k + 1) * Double(H) / 7,
                 rng.chance(0.5) ? Field.oakPale : Field.dust,
                 strength: rng.r(0.04, 0.11), seed: seed &+ UInt64(k * 13))
    }
    if index % 6 == 4 {
        for k in 0..<26 {
            var pts: [CGPoint] = []
            let y0 = rng.r(0, Double(H))
            var x = -40.0
            while x < Double(W) + 40 { pts.append(pt(x, y0 + sin(x / 160 + Double(k)) * 6)); x += 90 }
            penBroken(p, pts, weight: rng.r(0.8, 1.8), colour: Field.oakDark.al(rng.r(0.10, 0.24)),
                      pieces: 4, gap: 0.05, wobble: 0.8, seed: seed &+ UInt64(k * 7))
        }
    }
    for k in 0..<Int(rng.r(9, 16)) {
        let cx = rng.r(0, Double(W)), cy = rng.r(0, Double(H))
        let rx = rng.r(30, 150)
        wash(p, ringPoints(cx: cx, cy: cy, rx: rx, ry: rx * rng.r(0.4, 0.9), steps: 22),
             rng.chance(0.5) ? Field.sepia : Field.dust, strength: rng.r(0.03, 0.08),
             bleed: rng.r(4, 12), seed: seed &+ UInt64(k * 29))
    }
    stipple(p, pathOf([pt(0, 0), pt(Double(W), 0), pt(Double(W), Double(H)), pt(0, Double(H))]),
            density: 0.00035, sizeMin: 0.4, sizeMax: 1.5, colour: Field.inkPale.al(0.16), seed: seed &+ 77)
    p.write(dir, "ground-\(slug)", quality: 0.90)
}

func makeIcon(dir: String) {
    let S = 1024
    let p = Plate(S, S)
    p.topDown()
    p.light = -0.80
    let seed: UInt64 = 0x7EE_11_11
    p.fillAll(Field.walnutDark.dk(0.22))
    var bg = Dice(seed &+ 3)
    for k in 0..<9 {
        let x0 = Double(S) * Double(k) / 9
        p.rect(x0, 0, Double(S) / 9 + 1, Double(S),
               Field.walnut.dk(bg.r(0.24, 0.46)))
        pen(p, [pt(x0, -10), pt(x0 + bg.signed() * 5, Double(S) + 10)], weight: 3.0,
            colour: Field.ink.al(0.45), wobble: 1.2, taper: false, seed: seed &+ UInt64(k * 7))
        for _ in 0..<7 {
            let yy = bg.r(0, Double(S))
            pen(p, [pt(x0 + 6, yy), pt(x0 + Double(S) / 9 - 6, yy + bg.signed() * 10)],
                weight: bg.r(1.0, 2.6), colour: Field.oakDark.al(bg.r(0.10, 0.26)),
                wobble: 1.0, taper: true, seed: seed &+ UInt64(bg.i(1, 9999)))
        }
    }
    for k in 0..<22 {
        let r = Double(S) * (0.70 - Double(k) * 0.028)
        p.disc(Double(S) * 0.28, Double(S) * 0.32, r, Field.lampWarm.al(0.016))
    }
    washBand(p, from: Double(S) * 0.62, to: Double(S), Field.ink, strength: 0.24, seed: seed &+ 2)

    let spine = arcPts(cx: 300, yTop: -130, yBot: Double(S) + 130, amp: 300, exp: 0.62)
    var back: [CGPoint] = []
    var belly: [CGPoint] = []
    for i in 0..<spine.count {
        let a = spine[max(0, i - 1)], b = spine[min(spine.count - 1, i + 1)]
        var tx = Double(b.x - a.x), ty = Double(b.y - a.y)
        let l = (tx * tx + ty * ty).squareRoot()
        if l > 0 { tx /= l; ty /= l } else { tx = 0; ty = 1 }
        let t = Double(i) / Double(spine.count - 1)
        let hw = 46 * (1 - 0.34 * abs(t * 2 - 1))
        back.append(pt(Double(spine[i].x) - ty * hw, Double(spine[i].y) + tx * hw))
        belly.append(pt(Double(spine[i].x) + ty * hw, Double(spine[i].y) - tx * hw))
    }
    let body = back + belly.reversed()
    p.poly(body.map { pt(Double($0.x) - 40, Double($0.y) + 46) }, Field.ink.al(0.30))
    p.poly(body, Field.yewHeart)
    var sapIn: [CGPoint] = []
    for i in 0..<spine.count {
        let a = spine[max(0, i - 1)], b = spine[min(spine.count - 1, i + 1)]
        var tx = Double(b.x - a.x), ty = Double(b.y - a.y)
        let l = (tx * tx + ty * ty).squareRoot()
        if l > 0 { tx /= l; ty /= l } else { tx = 0; ty = 1 }
        let t = Double(i) / Double(spine.count - 1)
        let hw = 46 * (1 - 0.34 * abs(t * 2 - 1)) * 0.44
        sapIn.append(pt(Double(spine[i].x) - ty * hw, Double(spine[i].y) + tx * hw))
    }
    p.poly(back + sapIn.reversed(), Field.yewSap)
    pen(p, sapIn, weight: 2.2, colour: Field.oakDark.al(0.6), wobble: 0.6, taper: false, seed: seed &+ 5)

    var rng = Dice(seed &+ 9)
    for k in 0..<9 {
        var pts: [CGPoint] = []
        var i = 6
        let f = -0.80 + 1.60 * Double(k) / 8
        while i < spine.count - 6 {
            let a = spine[max(0, i - 1)], b = spine[min(spine.count - 1, i + 1)]
            var tx = Double(b.x - a.x), ty = Double(b.y - a.y)
            let l = (tx * tx + ty * ty).squareRoot()
            if l > 0 { tx /= l; ty /= l } else { tx = 0; ty = 1 }
            let t = Double(i) / Double(spine.count - 1)
            let hw = 46 * (1 - 0.34 * abs(t * 2 - 1)) * f
            pts.append(pt(Double(spine[i].x) - ty * hw, Double(spine[i].y) + tx * hw))
            i += 4
        }
        penBroken(p, pts, weight: 1.7, colour: Field.walnutDark.al(rng.r(0.25, 0.5)),
                  pieces: 3, gap: 0.05, wobble: 0.8, seed: seed &+ UInt64(k * 17))
    }
    var bellyBand: [CGPoint] = []
    var inner: [CGPoint] = []
    for i in 0..<spine.count {
        let a = spine[max(0, i - 1)], b = spine[min(spine.count - 1, i + 1)]
        var tx = Double(b.x - a.x), ty = Double(b.y - a.y)
        let l = (tx * tx + ty * ty).squareRoot()
        if l > 0 { tx /= l; ty /= l } else { tx = 0; ty = 1 }
        let t = Double(i) / Double(spine.count - 1)
        let hw = 46 * (1 - 0.34 * abs(t * 2 - 1))
        bellyBand.append(pt(Double(spine[i].x) + ty * hw, Double(spine[i].y) - tx * hw))
        inner.append(pt(Double(spine[i].x) + ty * hw * 0.3, Double(spine[i].y) - tx * hw * 0.3))
    }
    shade(p, pathOf(bellyBand + inner.reversed()), depth: 3, spacing: 5.2,
          colour: Field.ink.al(0.45), bound: pathOf(body), seed: seed &+ 31)
    var rim: [CGPoint] = []
    for i in 0..<spine.count {
        let a = spine[max(0, i - 1)], b = spine[min(spine.count - 1, i + 1)]
        var tx = Double(b.x - a.x), ty = Double(b.y - a.y)
        let l = (tx * tx + ty * ty).squareRoot()
        if l > 0 { tx /= l; ty /= l } else { tx = 0; ty = 1 }
        let t = Double(i) / Double(spine.count - 1)
        let hw = 46 * (1 - 0.34 * abs(t * 2 - 1)) * 0.86
        rim.append(pt(Double(spine[i].x) - ty * hw, Double(spine[i].y) + tx * hw))
    }
    pen(p, rim, weight: 5.0, colour: Field.lampWarm.al(0.55), wobble: 0.7, taper: true, seed: seed &+ 39)
    pen(p, back, weight: 5.0, colour: Field.ink, wobble: 1.0, taper: false, seed: seed &+ 41)
    pen(p, belly, weight: 6.0, colour: Field.ink, wobble: 1.0, taper: false, seed: seed &+ 43)

    let a = spine[spine.count - 1], b = spine[0]
    pen(p, [pt(Double(a.x) - 20, Double(a.y)), pt(Double(b.x) - 20, Double(b.y))],
        weight: 11.0, colour: Field.hemp.lt(0.10), wobble: 0.6, taper: false, seed: seed &+ 51)
    pen(p, [pt(Double(a.x) - 20, Double(a.y)), pt(Double(b.x) - 20, Double(b.y))],
        weight: 4.0, colour: Field.ink.al(0.50), wobble: 0.5, taper: false, seed: seed &+ 53)

    let gx = Double(spine[spine.count / 2].x)
    let gy = Double(spine[spine.count / 2].y)
    for k in 0..<19 {
        let t = Double(k) / 18
        let yy = gy - 140 + 280 * t
        pen(p, [pt(gx - 34, yy), pt(gx + 36, yy - 15)], weight: 10.0,
            colour: Field.leather.dk(rng.r(0.04, 0.34)), wobble: 0.8, taper: false,
            seed: seed &+ UInt64(k * 19 + 61))
        pen(p, [pt(gx - 34, yy + 7), pt(gx + 36, yy - 8)], weight: 2.4,
            colour: Field.ink.al(0.42), wobble: 0.6, taper: false,
            seed: seed &+ UInt64(k * 23 + 67))
    }
    stipple(p, pathOf([pt(0, 0), pt(Double(S), 0), pt(Double(S), Double(S)), pt(0, Double(S))]),
            density: 0.00022, sizeMin: 0.6, sizeMax: 2.0, colour: Field.inkPale.al(0.16), seed: seed &+ 91)
    p.writePNG(dir, "AppIcon-1024")
}
