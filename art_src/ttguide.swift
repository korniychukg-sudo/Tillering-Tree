import Foundation
import CoreGraphics

struct GuideSpec {
    let slug: String
    let title: String
    let kind: String
    let lead: String
    let body: [String]
}

let guideBook: [GuideSpec] = [
    GuideSpec(slug: "grain", title: "Grain and Run Off", kind: "grain",
              lead: "The single thing that breaks more bows than any other",
              body: ["Wood is a bundle of fibres. A bow works because those fibres run unbroken from one tip to the other. Where a fibre ends part way along the back, the load has nowhere to go and the wood lifts a splinter there.",
                     "On a split stave the fibres follow the tree and you keep them by following the surface the split gave you. On a sawn board they run wherever the saw put them, and half the boards in a stack have grain running off the face within a foot.",
                     "Look along the edge, not the face. Straight parallel lines the whole length is what you want. Lines that drift across the edge and disappear are run off, and the bow will break where they leave."]),
    GuideSpec(slug: "backring", title: "Chasing a Ring", kind: "backring",
              lead: "Removing wood until one growth ring is the whole back",
              body: ["In ring porous woods like osage and locust, each year makes a soft porous layer followed by a dense one. The dense late wood carries the load and the porous early wood is nearly worthless in tension.",
                     "So the back of the bow is made one single ring of late wood, uninterrupted from tip to tip. You take the bark and sapwood off, find a ring you like, and remove everything above it with a drawknife and a scraper.",
                     "Cut through that ring anywhere and you have exposed the porous layer beneath. The bow will lift a splinter at that spot, usually at full draw, usually loudly."]),
    GuideSpec(slug: "rings", title: "Reading Ring Density", kind: "rings",
              lead: "Fast grown or slow grown, depending entirely on the wood",
              body: ["For ring porous hardwoods, ash, elm, hickory and osage, fast growth is better. A wide ring is mostly dense late wood with one thin porous layer. Narrow rings are mostly porous layer, and the stave is weak.",
                     "For diffuse porous woods and for yew it is the other way round. Tight slow grown yew from a mountainside makes a far better bow than fast grown valley yew.",
                     "Count the rings across an inch on the end of the stave before you commit. It costs nothing and it tells you what you are holding."]),
    GuideSpec(slug: "floor", title: "Floor Tillering", kind: "floor",
              lead: "The first bend, before the bow will take a string at all",
              body: ["Stand the bow on the floor with one tip against your foot and push down on the handle. A stave that has only been roughed out will barely move, and that is the point.",
                     "You are looking for the two limbs to start bending at the same time and by the same amount. Remove wood from the stiff one until they agree.",
                     "Only when both limbs bend a good few inches under hand pressure is the bow safe to put on a long string. Rushing this step is how staves get broken before they are bows."]),
    GuideSpec(slug: "longstring", title: "The Long String", kind: "longstring",
              lead: "A slack string that lets you see the bend without bracing",
              body: ["A long string is simply a string several inches too long. It puts no brace on the bow, so the limbs are at rest, and the first few inches of draw show you the tiller without straining anything.",
                     "Draw it only far enough to see the curve. Twenty inches on a long string is not a small draw; it is most of the strain of a braced bow at full draw.",
                     "When both limbs bend evenly on the long string to a reasonable distance, the bow is ready to be braced properly for the first time."]),
    GuideSpec(slug: "tree", title: "The Tillering Tree", kind: "tree",
              lead: "A post, a cradle and a row of notches",
              body: ["The bow sits in a cradle at the top of a post and the string is pulled down and hooked into a notch. Now you can stand back and look at the whole bend at once, which is impossible while you are holding it.",
                     "The notches are usually two inches apart and a scale beside them gives the draw. A hanging scale or a spring balance on the string gives the weight.",
                     "Step back at least eight feet. Tiller faults are shapes, and shapes are invisible at arm's length."]),
    GuideSpec(slug: "curve", title: "Reading the Curve", kind: "curve",
              lead: "Three arcs: right, hinged and stiff",
              body: ["An even arc bends a little everywhere and no part of it works harder than any other. That bow will take the least set and last the longest.",
                     "A hinge is a short section bending much more than its neighbours. It is a soft spot, and every draw makes it softer until it takes a permanent bend or breaks.",
                     "A stiff section does no work, which means the rest of the limb is doing its share as well as its own. Stiff spots near the tip are deliberate on some designs and accidental on most."]),
    GuideSpec(slug: "hinge", title: "Hinges", kind: "hinge",
              lead: "Once you have made one, it does not come out",
              body: ["A hinge appears where too much wood came off in one place. The section is thinner than its neighbours, so it bends more, so it takes more strain, so it takes set, so it bends more still.",
                     "You cannot fix a hinge by adding wood. The only remedy is to reduce everything around it until the whole limb matches the hinge, which costs draw weight, sometimes a great deal of it.",
                     "This is why you scrape a few strokes and look, rather than a lot of strokes and hope. Twenty light passes and five looks beat one heavy pass every time."]),
    GuideSpec(slug: "set", title: "Set and String Follow", kind: "set",
              lead: "The bend the bow keeps when the string comes off",
              body: ["Unstring a new bow and it will not be as straight as the stave was. That permanent bend is set, and measured against a straight edge at the handle it is called string follow.",
                     "An inch or so is normal and harmless. Three inches means the belly has been overstrained, and the bow will be slow because a great deal of the energy is going into bending wood that never comes back.",
                     "Set comes from working the wood too hard, which usually means the bow is too short, too narrow or too thick for its weight. It also comes from tillering a stave that is not properly dry."]),
    GuideSpec(slug: "nocks", title: "Nocks", kind: "nocks",
              lead: "Where the string meets the wood, and where tips break",
              body: ["A side nock is a groove cut into the sides of the tip, angled back toward the handle so the string cannot climb out. It leaves the back of the bow untouched, which matters a great deal.",
                     "Never cut a nock groove across the back. It severs the very fibres the whole bow depends on and the tip will fail there.",
                     "Horn or antler nock overlays spread the load and stop the string cutting into the wood. On a heavy bow they are not decoration."]),
    GuideSpec(slug: "brace", title: "Brace Height", kind: "brace",
              lead: "How far the string sits from the handle when strung",
              body: ["Too low and the string slaps the arm and the bow is noisy. Too high and the bow is quiet, smooth and slower, because the working part of the draw is shorter.",
                     "Six to seven inches suits most flat wooden bows. A longbow often likes a little less; a recurve usually wants more.",
                     "Change it by twisting the string, a few turns at a time, and listen. The bow will tell you where it wants to sit."]),
    GuideSpec(slug: "weight", title: "Weight and Draw Length", kind: "weight",
              lead: "A wooden bow gains about two to three pounds an inch",
              body: ["Draw weight is not a property of the bow alone; it is a property of the bow at a stated draw length. Fifty pounds at twenty eight inches is about forty seven at twenty seven.",
                     "The force draw curve of a straight limbed wooden bow is almost a straight line. Recurves and composites bend the curve upward early and flatten it at the end, which stores more energy for the same peak weight.",
                     "Never draw past the length you tillered for, not even once. The wood has no memory of your intentions, only of the strain."]),
    GuideSpec(slug: "spine", title: "Arrow Spine", kind: "spine",
              lead: "The arrow has to bend around the bow, and by the right amount",
              body: ["On release the string pushes the back of the arrow while the front is still still. The shaft buckles sideways, flexes around the handle and straightens in flight. This is the archer's paradox.",
                     "A shaft too stiff for the bow will not flex enough and will kick away from the bow. Too weak and it flexes too far and kicks the other way.",
                     "Spine is measured as deflection under a standard weight over a standard span. Match it to the bow weight and the point weight, and a mediocre bow shoots well."]),
    GuideSpec(slug: "loose", title: "The Loose", kind: "loose",
              lead: "Everything the bow does happens in twenty milliseconds",
              body: ["A clean loose is the fingers relaxing rather than opening. The string should push them out of the way; you should not move them out of its way.",
                     "Any sideways push at the moment of release goes straight into the arrow, and at twenty yards a small error at the string is a large one at the target.",
                     "The follow through is not ceremony. Holding position until the arrow lands means you were still while it left."]),
]

func arcPts(cx: Double, yTop: Double, yBot: Double, amp: Double, exp: Double,
            hinge: Double = 0, stiff: Bool = false, steps: Int = 90) -> [CGPoint] {
    var out: [CGPoint] = []
    for i in 0...steps {
        let u = Double(i) / Double(steps)
        let s = u * 2 - 1
        let a = min(1.0, abs(s))
        var d: Double
        if stiff {
            let k = 0.52
            if a <= k {
                d = pow(cos(a / k * .pi / 2 * 0.96), exp)
            } else {
                let f0 = pow(cos(.pi / 2 * 0.96), exp)
                let f1 = pow(cos((k - 0.01) / k * .pi / 2 * 0.96), exp)
                d = f0 + (f0 - f1) / 0.01 * (a - k)
            }
            let tipV = { () -> Double in
                let f0 = pow(cos(.pi / 2 * 0.96), exp)
                let f1 = pow(cos((k - 0.01) / k * .pi / 2 * 0.96), exp)
                return f0 + (f0 - f1) / 0.01 * (1 - k)
            }()
            d -= tipV * a
        } else {
            d = pow(cos(a * .pi / 2), exp)
        }
        if hinge != 0 && s > 0 {
            let z = (a - 0.54) / 0.17
            d += hinge * Foundation.exp(-z * z) * (1 - a * 0.45)
        }
        out.append(pt(cx + d * amp, yTop + (yBot - yTop) * (1 - u)))
    }
    return out
}

func limbBand(_ p: Plate, _ spine: [CGPoint], half: Double, wood: Tone, seed: UInt64,
              taperTip: Bool = true) {
    var back: [CGPoint] = []
    var belly: [CGPoint] = []
    for i in 0..<spine.count {
        let a = spine[max(0, i - 1)], b = spine[min(spine.count - 1, i + 1)]
        var tx = Double(b.x - a.x), ty = Double(b.y - a.y)
        let l = (tx * tx + ty * ty).squareRoot()
        if l > 0 { tx /= l; ty /= l } else { tx = 0; ty = 1 }
        let t = Double(i) / Double(spine.count - 1)
        let f = taperTip ? (1 - 0.45 * abs(t * 2 - 1)) : 1
        let hw = half * f
        back.append(pt(Double(spine[i].x) - ty * hw, Double(spine[i].y) + tx * hw))
        belly.append(pt(Double(spine[i].x) + ty * hw, Double(spine[i].y) - tx * hw))
    }
    let body = back + belly.reversed()
    p.poly(body.map { pt(Double($0.x) - 5, Double($0.y) + 8) }, Field.ink.al(0.09))
    p.poly(body, wood)
    shade(p, pathOf(body), depth: 1, spacing: 4.6, colour: Field.inkSoft.al(0.30),
          bound: pathOf(body), seed: seed)
    pen(p, back, weight: 1.7, colour: Field.ink, wobble: 0.6, taper: false, seed: seed &+ 3)
    pen(p, belly, weight: 1.7, colour: Field.ink, wobble: 0.6, taper: false, seed: seed &+ 5)
}

func tick(_ p: Plate, from a: CGPoint, to b: CGPoint, label: String, seed: UInt64,
          size: Double = 21) {
    pen(p, [a, b], weight: 1.2, colour: Field.inkPale, wobble: 0.4, taper: false, seed: seed)
    let ax = Double(a.x), ay = Double(a.y), bx = Double(b.x), by = Double(b.y)
    var dx = bx - ax, dy = by - ay
    let l = max(0.001, (dx * dx + dy * dy).squareRoot())
    dx /= l; dy /= l
    for q in [a, b] {
        pen(p, [pt(Double(q.x) - dy * 9, Double(q.y) + dx * 9),
                pt(Double(q.x) + dy * 9, Double(q.y) - dx * 9)],
            weight: 1.2, colour: Field.inkPale, wobble: 0.3, taper: false, seed: seed &+ 7)
    }
    if !label.isEmpty {
        caption(p, label, at: (ax + bx) / 2 - dy * 22, (ay + by) / 2 + dx * 22 + 6,
                size: size, colour: Field.inkPale, align: .centre)
    }
}

func drawGuideArt(_ p: Plate, _ g: GuideSpec, top: Double, bottom: Double, seed: UInt64) {
    let cx = p.w / 2
    let midY = (top + bottom) / 2
    switch g.kind {
    case "grain":
        for (k, ok) in [(0, true), (1, false)] {
            let y0 = top + 40 + Double(k) * 230
            let boardTop = y0, boardBot = y0 + 150
            p.poly([pt(150, boardTop), pt(950, boardTop), pt(950, boardBot), pt(150, boardBot)],
                   Field.ash)
            var rng = Dice(seed &+ UInt64(k * 91))
            for i in 0..<14 {
                let base = boardTop + 8 + Double(i) * 10
                var pts: [CGPoint] = []
                var x = 150.0
                while x <= 950 {
                    let drift = ok ? rng.signed() * 2.0 : (x - 150) * 0.115
                    pts.append(pt(x, base + drift + rng.signed() * 1.4))
                    x += 40
                }
                penBroken(p, pts, weight: 1.15, colour: Field.oakDark.al(0.62),
                          pieces: 3, gap: 0.04, wobble: 0.5, seed: seed &+ UInt64(i * 7 + k * 33))
            }
            penContour(p, [pt(150, boardTop), pt(950, boardTop), pt(950, boardBot), pt(150, boardBot)],
                       weight: 2.0, colour: Field.ink, seed: seed &+ UInt64(k))
            caption(p, ok ? "GRAIN RUNS THE LENGTH  ·  SOUND" : "GRAIN RUNS OFF THE FACE  ·  IT WILL BREAK",
                    at: cx, boardBot + 34, size: 22,
                    colour: ok ? Field.moss.dk(0.20) : Field.oxblood, align: .centre, tracking: 1.6)
            if !ok {
                for i in 0..<4 {
                    let x = 560 + Double(i) * 88
                    pen(p, [pt(x, boardTop - 26), pt(x + 8, boardTop - 6)], weight: 2.0,
                        colour: Field.oxblood, wobble: 0.4, taper: true, seed: seed &+ UInt64(i + 300))
                }
            }
        }
    case "backring":
        let r = 250.0
        let cy = midY - 20
        for i in stride(from: 13, through: 1, by: -1) {
            let rr = r * Double(i) / 13
            let dense = i % 2 == 0
            p.disc(cx, cy, rr, dense ? Field.osage : Field.osage.lt(0.34))
        }
        p.disc(cx, cy, r * 0.06, Field.oakDark)
        for i in 1...13 {
            let rr = r * Double(i) / 13
            pen(p, ringPoints(cx: cx, cy: cy, rx: rr, ry: rr, steps: 90) + [pt(cx + rr, cy)],
                weight: 0.9, colour: Field.oakDark.al(0.55), wobble: 0.5, taper: false,
                seed: seed &+ UInt64(i * 5))
        }
        let keep = r * 10 / 13
        p.clip(pathOf(ringPoints(cx: cx, cy: cy, rx: keep, ry: keep, steps: 80))) {
            hatch(p, pathOf([pt(cx - r, cy - r), pt(cx + r, cy - r), pt(cx + r, cy), pt(cx - r, cy)]),
                  angle: 0.9, spacing: 5.0, weight: 1.0, colour: Field.moss.al(0.5),
                  coverage: 0.8, seed: seed &+ 21)
        }
        pen(p, ringPoints(cx: cx, cy: cy, rx: keep, ry: keep, steps: 96) + [pt(cx + keep, cy)],
            weight: 2.6, colour: Field.moss.dk(0.24), wobble: 0.5, taper: false, seed: seed &+ 31)
        pen(p, [pt(cx + keep + 130, cy - 150), pt(cx + keep + 20, cy - 60), pt(cx + keep * 0.72, cy - keep * 0.66)],
            weight: 1.6, colour: Field.ink, wobble: 0.5, taper: true, seed: seed &+ 41)
        caption(p, "THE CHASED RING BECOMES THE BACK", at: cx + keep + 140, cy - 168,
                size: 21, colour: Field.ink, align: .left, tracking: 1.2)
        caption(p, "EVERYTHING ABOVE IT COMES OFF", at: cx, cy + r + 54, size: 22,
                colour: Field.inkPale, align: .centre, tracking: 2.0)
    case "rings":
        let labels = ["FAST GROWN", "MEDIUM", "SLOW GROWN"]
        let counts = [5, 11, 26]
        for k in 0..<3 {
            let x0 = 150.0 + Double(k) * 270
            let y0 = midY - 190.0
            p.poly([pt(x0, y0), pt(x0 + 220, y0), pt(x0 + 220, y0 + 380), pt(x0, y0 + 380)], Field.hickory)
            for i in 0...counts[k] {
                let yy = y0 + 380 * Double(i) / Double(counts[k])
                let th = 380 / Double(counts[k]) * 0.34
                p.rect(x0, yy, 220, th, Field.oakDark.al(0.55))
            }
            penContour(p, [pt(x0, y0), pt(x0 + 220, y0), pt(x0 + 220, y0 + 380), pt(x0, y0 + 380)],
                       weight: 2.0, colour: Field.ink, seed: seed &+ UInt64(k))
            caption(p, labels[k], at: x0 + 110, y0 + 418, size: 21, colour: Field.ink,
                    align: .centre, tracking: 1.8)
            caption(p, "\(counts[k]) rings", at: x0 + 110, y0 + 448, size: 19,
                    colour: Field.inkPale, align: .centre)
        }
        caption(p, "RING POROUS WOODS WANT THE LEFT  ·  YEW WANTS THE RIGHT",
                at: cx, midY + 268, size: 22, colour: Field.inkSoft, align: .centre, tracking: 1.4)
    case "floor":
        let spine = arcPts(cx: 420, yTop: top + 60, yBot: bottom - 150, amp: 92, exp: 0.62)
        limbBand(p, spine, half: 15, wood: Field.elm, seed: seed)
        p.rect(120, bottom - 148, 860, 10, Field.oakDark.al(0.8))
        pen(p, [pt(120, bottom - 148), pt(980, bottom - 148)], weight: 2.4, colour: Field.ink,
            wobble: 0.6, taper: false, seed: seed &+ 3)
        hatch(p, pathOf([pt(120, bottom - 138), pt(980, bottom - 138), pt(980, bottom - 108), pt(120, bottom - 108)]),
              angle: 1.1, spacing: 7, weight: 1.0, colour: Field.inkPale.al(0.6), coverage: 0.7, seed: seed &+ 5)
        let hy = Double(spine[spine.count / 2].y)
        let hx = Double(spine[spine.count / 2].x)
        p.ellipse(hx + 66, hy, 58, 34, Field.leather.lt(0.30))
        penContour(p, ringPoints(cx: hx + 66, cy: hy, rx: 58, ry: 34, steps: 40),
                   weight: 2.0, colour: Field.ink, seed: seed &+ 7)
        for i in 0..<4 {
            pen(p, [pt(hx + 108 + Double(i) * 22, hy - 24 + Double(i) * 4),
                    pt(hx + 150 + Double(i) * 20, hy - 16 + Double(i) * 6)],
                weight: 3.0, colour: Field.leather.dk(0.10), wobble: 0.5, taper: true,
                seed: seed &+ UInt64(i + 11))
        }
        pen(p, [pt(hx + 210, hy - 70), pt(hx + 210, hy + 46)], weight: 2.2, colour: Field.ink,
            wobble: 0.5, taper: true, seed: seed &+ 21)
        pen(p, [pt(hx + 196, hy + 30), pt(hx + 210, hy + 52), pt(hx + 224, hy + 30)],
            weight: 2.2, colour: Field.ink, wobble: 0.4, taper: false, seed: seed &+ 23)
        caption(p, "PUSH", at: hx + 250, hy - 6, size: 22, colour: Field.ink, align: .left, tracking: 2.2)
    case "longstring":
        let spine = arcPts(cx: cx - 70, yTop: top + 40, yBot: bottom - 90, amp: 70, exp: 0.62)
        limbBand(p, spine, half: 16, wood: Field.hickory, seed: seed)
        let a = spine[spine.count - 1], b = spine[0]
        pen(p, [pt(Double(a.x) - 6, Double(a.y)), pt(Double(a.x) - 150, (Double(a.y) + Double(b.y)) / 2),
                pt(Double(b.x) - 6, Double(b.y))],
            weight: 2.0, colour: Field.hemp.dk(0.30), wobble: 0.4, taper: false, seed: seed &+ 3)
        pen(p, [pt(Double(a.x) - 6, Double(a.y)), pt(Double(a.x) - 320, (Double(a.y) + Double(b.y)) / 2),
                pt(Double(b.x) - 6, Double(b.y))],
            weight: 2.0, colour: Field.inkPale.al(0.55), wobble: 0.4, taper: false, seed: seed &+ 5)
        caption(p, "SHORT STRING  ·  BRACED", at: cx - 210, top + 8, size: 20,
                colour: Field.inkSoft, align: .centre, tracking: 1.4)
        caption(p, "LONG STRING  ·  NO BRACE", at: cx - 330, bottom - 40, size: 20,
                colour: Field.inkPale, align: .centre, tracking: 1.4)
    case "tree":
        let px = cx - 60
        p.rect(px - 26, top + 20, 52, bottom - top - 40, Field.oak)
        penContour(p, [pt(px - 26, top + 20), pt(px + 26, top + 20),
                       pt(px + 26, bottom - 20), pt(px - 26, bottom - 20)],
                   weight: 2.2, colour: Field.ink, seed: seed)
        hatch(p, pathOf([pt(px - 26, top + 20), pt(px - 6, top + 20),
                         pt(px - 6, bottom - 20), pt(px - 26, bottom - 20)]),
              angle: 1.4, spacing: 6, weight: 1.0, colour: Field.inkSoft.al(0.45),
              coverage: 0.8, seed: seed &+ 3)
        let handleY = top + 140.0
        var spineT: [CGPoint] = []
        for i in 0...90 {
            let u = Double(i) / 90 * 2 - 1
            let a = abs(u)
            spineT.append(pt(px + u * 340, handleY + 215 * (1 - cos(a * .pi / 2))))
        }
        let cradleY = handleY - 6
        p.rect(px - 58, cradleY - 34, 116, 44, Field.leather)
        penContour(p, [pt(px - 58, cradleY - 34), pt(px + 58, cradleY - 34),
                       pt(px + 58, cradleY + 10), pt(px - 58, cradleY + 10)],
                   weight: 2.0, colour: Field.ink, seed: seed &+ 5)
        limbBand(p, spineT, half: 15, wood: Field.osage, seed: seed &+ 21)
        let hookY = top + 610.0
        pen(p, [spineT[0], pt(px, hookY)], weight: 2.6,
            colour: Field.hemp.dk(0.42), wobble: 0.3, taper: false, seed: seed &+ 25)
        pen(p, [pt(px, hookY), spineT[spineT.count - 1]], weight: 2.6,
            colour: Field.hemp.dk(0.42), wobble: 0.3, taper: false, seed: seed &+ 27)
        for i in 0..<10 {
            let yy = top + 430 + Double(i) * 46
            pen(p, [pt(px + 26, yy), pt(px + 62, yy - 12)], weight: 2.2, colour: Field.ink,
                wobble: 0.4, taper: false, seed: seed &+ UInt64(i * 3 + 9))
            caption(p, "\(18 + i * 2)\"", at: px + 74, yy - 4, size: 19,
                    colour: Field.inkPale, align: .left)
        }
        pen(p, [pt(px - 30, hookY), pt(px + 30, hookY - 16)], weight: 4.0, colour: Field.iron,
            wobble: 0.4, taper: false, seed: seed &+ 41)
        let sx = px - 150.0
        pen(p, [pt(px, hookY + 4), pt(sx, hookY + 76)], weight: 2.4, colour: Field.iron,
            wobble: 0.3, taper: false, seed: seed &+ 43)
        p.rect(sx - 32, hookY + 76, 64, 126, Field.steel.lt(0.22))
        penContour(p, [pt(sx - 32, hookY + 76), pt(sx + 32, hookY + 76),
                       pt(sx + 32, hookY + 202), pt(sx - 32, hookY + 202)],
                   weight: 2.0, colour: Field.ink, seed: seed &+ 45)
        for i in 0...9 {
            let yy = hookY + 88 + Double(i) * 13
            pen(p, [pt(sx - 26, yy), pt(sx - 26 + (i % 2 == 0 ? 20 : 12), yy)], weight: 1.1,
                colour: Field.ink, wobble: 0.3, taper: false, seed: seed &+ UInt64(i + 51))
        }
        pen(p, [pt(sx - 6, hookY + 140), pt(sx + 26, hookY + 140)], weight: 2.6,
            colour: Field.oxblood, wobble: 0.3, taper: false, seed: seed &+ 61)
        caption(p, "SPRING SCALE", at: sx, hookY + 232, size: 19,
                colour: Field.inkPale, align: .centre, tracking: 1.2)
        caption(p, "CRADLE", at: px - 74, cradleY - 12, size: 19, colour: Field.inkPale,
                align: .right, tracking: 1.2)
        caption(p, "NOTCHES  ·  TWO INCHES APART", at: px + 62, bottom - 26, size: 21,
                colour: Field.inkSoft, align: .left, tracking: 1.6)
    case "curve":
        let names = ["EVEN", "HINGED", "STIFF TIPS"]
        for k in 0..<3 {
            let bx = 230.0 + Double(k) * 320
            let spine: [CGPoint]
            if k == 0 { spine = arcPts(cx: bx, yTop: top + 60, yBot: bottom - 150, amp: 74, exp: 0.62) }
            else if k == 1 { spine = arcPts(cx: bx, yTop: top + 60, yBot: bottom - 150, amp: 74, exp: 0.62, hinge: 0.34) }
            else { spine = arcPts(cx: bx, yTop: top + 60, yBot: bottom - 150, amp: 74, exp: 0.62, stiff: true) }
            limbBand(p, spine, half: 12, wood: k == 0 ? Field.osage : Field.elm, seed: seed &+ UInt64(k * 17))
            pen(p, [spine[spine.count - 1], spine[0]], weight: 1.6, colour: Field.hemp.dk(0.28),
                wobble: 0.3, taper: false, seed: seed &+ UInt64(k * 5 + 3))
            caption(p, names[k], at: bx, bottom - 106, size: 22,
                    colour: k == 0 ? Field.moss.dk(0.20) : Field.oxblood, align: .centre, tracking: 1.8)
            if k == 1 {
                p.disc(Double(spine[Int(Double(spine.count) * 0.78)].x) + 34,
                       Double(spine[Int(Double(spine.count) * 0.78)].y), 8, Field.oxblood.al(0.8))
            }
        }
    case "hinge":
        let yy = midY - 100
        p.poly([pt(140, yy - 26), pt(960, yy - 26), pt(960, yy + 26), pt(140, yy + 26)], Field.hickory)
        p.poly([pt(560, yy - 4), pt(700, yy - 4), pt(700, yy + 26), pt(560, yy + 26)], Field.paperWarm)
        penContour(p, [pt(140, yy - 26), pt(960, yy - 26), pt(960, yy + 26), pt(140, yy + 26)],
                   weight: 2.0, colour: Field.ink, seed: seed)
        pen(p, [pt(560, yy - 4), pt(700, yy - 4)], weight: 2.4, colour: Field.oxblood,
            wobble: 0.4, taper: false, seed: seed &+ 3)
        caption(p, "TOO MUCH WOOD OFF HERE", at: 630, yy - 34, size: 21, colour: Field.oxblood,
                align: .centre, tracking: 1.2)
        let spine = arcPts(cx: cx - 40, yTop: yy + 90, yBot: bottom - 70, amp: 130, exp: 0.66, hinge: 0.30)
        limbBand(p, spine, half: 14, wood: Field.hickory, seed: seed &+ 11)
        pen(p, [spine[spine.count - 1], spine[0]], weight: 1.8, colour: Field.hemp.dk(0.34),
            wobble: 0.3, taper: false, seed: seed &+ 13)
        let hp = spine[Int(Double(spine.count) * 0.77)]
        p.disc(Double(hp.x) + 26, Double(hp.y), 7, Field.oxblood.al(0.85))
        caption(p, "THE BEND ALL HAPPENS THERE", at: Double(hp.x) + 42, Double(hp.y) + 6,
                size: 20, colour: Field.oxblood, align: .left, tracking: 1.2)
    case "set":
        let straight = 320.0
        pen(p, [pt(straight, top + 40), pt(straight, bottom - 90)], weight: 1.3,
            colour: Field.inkPale, wobble: 0.3, taper: false, seed: seed)
        caption(p, "STRAIGHT", at: straight - 16, top + 24, size: 19, colour: Field.inkPale, align: .right)
        for (k, follow) in [(0, 22.0), (1, 96.0)].enumerated() {
            let bx = straight + Double(k) * 300
            var spine: [CGPoint] = []
            for i in 0...80 {
                let u = Double(i) / 80
                let s = u * 2 - 1
                spine.append(pt(bx + pow(cos(abs(s) * .pi / 2), 0.8) * follow.1,
                                top + 40 + (bottom - 130 - top) * (1 - u)))
            }
            limbBand(p, spine, half: 13, wood: k == 0 ? Field.osage : Field.ash, seed: seed &+ UInt64(k * 9))
            let mid = spine[40]
            tick(p, from: pt(bx, Double(mid.y)), to: pt(bx + follow.1, Double(mid.y)),
                 label: k == 0 ? "1 in" : "3 in", seed: seed &+ UInt64(k * 3 + 5))
            caption(p, k == 0 ? "NORMAL" : "OVERSTRAINED", at: bx + 40, bottom - 90, size: 21,
                    colour: k == 0 ? Field.moss.dk(0.2) : Field.oxblood, align: .centre, tracking: 1.6)
        }
    case "nocks":
        let names = ["SIDE NOCK  ·  RIGHT", "OVERLAY  ·  RIGHT", "ACROSS THE BACK  ·  WRONG"]
        for k in 0..<3 {
            let bx = 230.0 + Double(k) * 320
            let by = midY - 80
            p.poly([pt(bx - 40, by - 190), pt(bx + 40, by - 190), pt(bx + 30, by + 150), pt(bx - 30, by + 150)],
                   Field.yew)
            if k == 1 {
                p.poly([pt(bx - 40, by - 190), pt(bx + 40, by - 190), pt(bx + 36, by - 96), pt(bx - 36, by - 96)],
                       Field.horn.lt(0.16))
            }
            if k == 2 {
                p.poly([pt(bx - 40, by - 150), pt(bx + 40, by - 150), pt(bx + 40, by - 128), pt(bx - 40, by - 128)],
                       Field.paperWarm)
                pen(p, [pt(bx - 40, by - 139), pt(bx + 40, by - 139)], weight: 2.6,
                    colour: Field.oxblood, wobble: 0.4, taper: false, seed: seed &+ UInt64(k))
            } else {
                for side in [-1.0, 1.0] {
                    p.poly([pt(bx + side * 40, by - 158), pt(bx + side * 12, by - 132),
                            pt(bx + side * 14, by - 118), pt(bx + side * 40, by - 136)], Field.paperWarm)
                    pen(p, [pt(bx + side * 40, by - 158), pt(bx + side * 12, by - 130)],
                        weight: 2.0, colour: Field.ink, wobble: 0.4, taper: false,
                        seed: seed &+ UInt64(k * 7 + Int(side + 2)))
                }
            }
            penContour(p, [pt(bx - 40, by - 190), pt(bx + 40, by - 190), pt(bx + 30, by + 150), pt(bx - 30, by + 150)],
                       weight: 2.0, colour: Field.ink, seed: seed &+ UInt64(k * 11))
            for l in wrapText(names[k], width: 250, size: 20).enumerated() {
                caption(p, l.element, at: bx, by + 196 + Double(l.offset) * 28, size: 20,
                        colour: k == 2 ? Field.oxblood : Field.ink, align: .centre, tracking: 1.1)
            }
        }
    case "brace":
        let spine = arcPts(cx: 420, yTop: top + 50, yBot: bottom - 120, amp: 110, exp: 0.62)
        limbBand(p, spine, half: 15, wood: Field.bamboo, seed: seed)
        let a = spine[spine.count - 1], b = spine[0]
        pen(p, [a, b], weight: 2.0, colour: Field.hemp.dk(0.30), wobble: 0.3, taper: false, seed: seed &+ 3)
        let mid = spine[spine.count / 2]
        tick(p, from: pt(Double(a.x), Double(mid.y)), to: pt(Double(mid.x) - 16, Double(mid.y)),
             label: "6 - 7 in", seed: seed &+ 5)
        caption(p, "MEASURED FROM THE STRING TO THE DEEPEST PART OF THE GRIP",
                at: cx, bottom - 70, size: 21, colour: Field.inkSoft, align: .centre, tracking: 1.1)
    case "weight":
        let x0 = 190.0, x1 = 950.0, y0 = bottom - 150, y1 = top + 50
        pen(p, [pt(x0, y0), pt(x1, y0)], weight: 2.0, colour: Field.ink, wobble: 0.4, taper: false, seed: seed)
        pen(p, [pt(x0, y0), pt(x0, y1)], weight: 2.0, colour: Field.ink, wobble: 0.4, taper: false, seed: seed &+ 3)
        for i in 0...7 {
            let x = x0 + (x1 - x0) * Double(i) / 7
            pen(p, [pt(x, y0), pt(x, y0 + 10)], weight: 1.2, colour: Field.inkPale, wobble: 0.3, taper: false, seed: seed &+ UInt64(i))
            caption(p, "\(14 + i * 2)", at: x, y0 + 34, size: 18, colour: Field.inkPale, align: .centre)
        }
        for i in 0...5 {
            let y = y0 - (y0 - y1) * Double(i) / 5
            pen(p, [pt(x0 - 10, y), pt(x0, y)], weight: 1.2, colour: Field.inkPale, wobble: 0.3, taper: false, seed: seed &+ UInt64(i + 40))
            caption(p, "\(i * 12)", at: x0 - 20, y + 6, size: 18, colour: Field.inkPale, align: .right)
        }
        var lin: [CGPoint] = []
        var rec: [CGPoint] = []
        for i in 0...50 {
            let t = Double(i) / 50
            lin.append(pt(x0 + (x1 - x0) * t, y0 - (y0 - y1) * (0.10 + 0.82 * t)))
            rec.append(pt(x0 + (x1 - x0) * t, y0 - (y0 - y1) * (0.10 + 0.90 * pow(t, 0.62))))
        }
        pen(p, lin, weight: 2.6, colour: Field.ink, wobble: 0.5, taper: false, seed: seed &+ 51)
        pen(p, rec, weight: 2.6, colour: Field.oxblood, wobble: 0.5, taper: false, seed: seed &+ 53)
        caption(p, "STRAIGHT LIMB", at: x1 - 20, y1 + 130, size: 21, colour: Field.ink, align: .right, tracking: 1.2)
        caption(p, "RECURVE", at: x1 - 20, y1 + 74, size: 21, colour: Field.oxblood, align: .right, tracking: 1.2)
        caption(p, "DRAW  (INCHES)", at: (x0 + x1) / 2, y0 + 70, size: 20, colour: Field.inkSoft, align: .centre, tracking: 2.0)
        caption(p, "POUNDS", at: x0 - 66, (y0 + y1) / 2, size: 20, colour: Field.inkSoft,
                align: .centre, tracking: 2.0, rotate: -.pi / 2)
    case "spine":
        let by = midY
        p.rect(cx - 24, by - 300, 48, 600, Field.yew)
        penContour(p, [pt(cx - 24, by - 300), pt(cx + 24, by - 300), pt(cx + 24, by + 300), pt(cx - 24, by + 300)],
                   weight: 2.0, colour: Field.ink, seed: seed)
        let sets: [(Double, Tone, String)] = [(-1, Field.oxblood, "TOO WEAK"), (0, Field.moss.dk(0.2), "MATCHED"), (1, Field.inkSoft, "TOO STIFF")]
        for (k, s) in sets.enumerated() {
            let yy = by - 190 + Double(k) * 190
            var pts: [CGPoint] = []
            for i in 0...40 {
                let t = Double(i) / 40
                pts.append(pt(cx - 300 + 620 * t, yy + sin(t * .pi * 1.6) * 26 * s.0))
            }
            pen(p, pts, weight: 3.0, colour: s.1, wobble: 0.4, taper: false, seed: seed &+ UInt64(k * 9 + 3))
            pen(p, [pt(cx + 306, yy), pt(cx + 334, yy - 8), pt(cx + 334, yy + 8)],
                weight: 2.0, colour: s.1, wobble: 0.3, taper: false, seed: seed &+ UInt64(k * 9 + 5))
            caption(p, s.2, at: cx + 348, yy + 6, size: 20, colour: s.1, align: .left, tracking: 1.2)
        }
        caption(p, "THE SHAFT BENDS AROUND THE BOW  ·  THE ARCHER'S PARADOX",
                at: cx, by + 350, size: 21, colour: Field.inkSoft, align: .centre, tracking: 1.1)
    default:
        let spine = arcPts(cx: 430, yTop: top + 50, yBot: bottom - 120, amp: 150, exp: 0.62)
        limbBand(p, spine, half: 14, wood: Field.yew, seed: seed)
        let a = spine[spine.count - 1], b = spine[0]
        let mid = pt(360, (Double(a.y) + Double(b.y)) / 2)
        pen(p, [a, mid, b], weight: 2.0, colour: Field.hemp.dk(0.30), wobble: 0.3, taper: false, seed: seed &+ 3)
        pen(p, [pt(Double(mid.x), Double(mid.y)), pt(Double(mid.x) + 300, Double(mid.y))],
            weight: 2.4, colour: Field.ink, wobble: 0.4, taper: false, seed: seed &+ 5)
        p.poly([pt(Double(mid.x) + 300, Double(mid.y)), pt(Double(mid.x) + 262, Double(mid.y) - 14),
                pt(Double(mid.x) + 262, Double(mid.y) + 14)], Field.ink)
        for i in 0..<3 {
            pen(p, [pt(Double(mid.x) - 30 - Double(i) * 26, Double(mid.y) - 40 + Double(i) * 40),
                    pt(Double(mid.x) - 76 - Double(i) * 26, Double(mid.y) - 52 + Double(i) * 46)],
                weight: 4.0, colour: Field.leather, wobble: 0.5, taper: true, seed: seed &+ UInt64(i + 21))
        }
        caption(p, "THE FINGERS RELAX  ·  THEY DO NOT OPEN", at: cx, bottom - 70,
                size: 21, colour: Field.inkSoft, align: .centre, tracking: 1.2)
    }
}

func makeGuidePlate(_ g: GuideSpec, dir: String) {
    let W = 1100, H = 1500
    let p = Plate(W, H, scale: plateScale)
    p.topDown()
    p.light = -0.88
    let seed = hashOf("guide-" + g.slug)
    layPaper(p, seed: seed, tone: Field.paperCool)
    caption(p, g.title.uppercased(), at: Double(W) / 2, 96, size: 42, colour: Field.ink,
            align: .centre, tracking: 4.0)
    caption(p, g.lead, at: Double(W) / 2, 140, size: 24, colour: Field.inkPale,
            align: .centre, tracking: 1.0)
    pen(p, [pt(300, 168), pt(800, 168)], weight: 1.4, colour: Field.inkPale.al(0.7),
        wobble: 0.5, taper: true, seed: seed &+ 3)
    drawGuideArt(p, g, top: 210, bottom: 1120, seed: seed &+ 101)
    var y = 1190.0
    for para in g.body {
        for line in wrapText(para, width: 920, size: 23) {
            caption(p, line, at: 90, y, size: 23, colour: Field.inkSoft, align: .left)
            y += 31
        }
        y += 10
        if y > 1420 { break }
    }
    plateFrame(p, inset: 40, seed: seed &+ 999)
    p.write(dir, "guide-\(g.slug)", quality: 0.93)
}
