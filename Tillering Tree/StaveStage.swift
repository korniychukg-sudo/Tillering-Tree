import SwiftUI

struct StaveStageView: View {
    @ObservedObject var session: MakeSession
    @State private var hover: Int? = nil

    private var picked: Int? { hover ?? session.chosenRing }

    var body: some View {
        VStack(spacing: 14) {
            Text(session.entry.timber)
                .font(Bark.serifItalic(15)).foregroundColor(Bark.inkPale)
            GeometryReader { geo in
                RingCanvas(rings: session.rings, chosen: picked, ring: session.entry.ring)
                    .contentShape(Rectangle())
                    .gesture(DragGesture(minimumDistance: 0).onChanged { v in
                        let cx = geo.size.width * 0.5
                        let cy = geo.size.height * 0.56
                        let maxR = min(geo.size.width, geo.size.height) * 0.46
                        let d = Double(hypot(v.location.x - cx, v.location.y - cy) / max(1, maxR))
                        if let idx = ringAt(session.rings, frac: d) {
                            session.chosenRing = idx
                            hover = idx
                        }
                    })
            }
            .aspectRatio(1.15, contentMode: .fit)
            .background(Bark.paperWarm)
            .overlay(Rectangle().stroke(Bark.ink.opacity(0.18), lineWidth: 1))
            HStack(spacing: 6) {
                ForEach(session.rings) { r in
                    Button(action: {
                        session.chosenRing = r.index
                        hover = r.index
                    }) {
                        Rectangle()
                            .fill(picked == r.index ? Bark.moss : Bark.oak.opacity(0.30 + r.thickness * 0.55))
                            .frame(height: 26 + CGFloat(r.thickness) * 22)
                            .overlay(Rectangle().stroke(Bark.ink.opacity(0.30), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(height: 52, alignment: .bottom)
            HStack {
                SmallCap(text: "pith", size: 9)
                Spacer()
                SmallCap(text: "ring thickness", size: 9)
                Spacer()
                SmallCap(text: "bark", size: 9)
            }
            if let p = picked {
                RingVerdict(slice: session.rings[p], ring: session.entry.ring)
            } else {
                Text("Tap a ring on the section, or a bar below, to choose the back.")
                    .font(Bark.serif(14)).foregroundColor(Bark.inkSoft)
                    .multilineTextAlignment(.center).padding(.horizontal, 10)
            }
            WoodButton(title: "Chase this ring", enabled: session.chosenRing != nil) {
                session.confirmRing()
            }
        }
    }
}

func ringAt(_ rings: [RingSlice], frac: Double) -> Int? {
    guard !rings.isEmpty, frac <= 1.02 else { return nil }
    var total = 0.0
    for r in rings { total += 0.4 + r.thickness }
    var run = 0.0
    for r in rings {
        run += 0.4 + r.thickness
        if frac <= run / total { return r.index }
    }
    return rings.count - 1
}

struct RingVerdict: View {
    let slice: RingSlice
    let ring: RingKind
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                SmallCap(text: "Ring \(slice.index + 1)")
                Spacer()
                SmallCap(text: slice.sound ? "Sound" : "Checked",
                         tone: slice.sound ? Bark.moss : Bark.oxblood)
            }
            RuleLine()
            HStack {
                Text(slice.thickness > 0.62 ? "Wide, fast grown" :
                        (slice.thickness > 0.40 ? "Even growth" : "Narrow, slow grown"))
                    .font(Bark.serif(14)).foregroundColor(Bark.inkSoft)
                Spacer()
                Text(String(format: "%.0f%%", slice.quality * 100))
                    .font(Bark.serifBold(14)).foregroundColor(Bark.ink)
            }
            Text(ringWord(ring) + "  ·  " + hintFor(ring))
                .font(Bark.serifItalic(13)).foregroundColor(Bark.inkPale)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .background(Paperboard())
    }

    private func hintFor(_ r: RingKind) -> String {
        switch r {
        case .porous: return "wide rings carry more late wood"
        case .yew: return "keep the sapwood, take the bark"
        case .bamboo: return "the outer skin is the back"
        case .board: return "watch where the grain leaves the face"
        case .composite: return "the sinew is the back, not the wood"
        }
    }
}

struct RingCanvas: View {
    let rings: [RingSlice]
    let chosen: Int?
    let ring: RingKind

    var body: some View {
        Canvas { ctx, size in
            draw(&ctx, size)
        }
    }

    private func draw(_ ctx: inout GraphicsContext, _ size: CGSize) {
        let cx = size.width * 0.5
        let cy = size.height * 0.56
        let maxR = min(size.width, size.height) * 0.46
        var acc: [Double] = []
        var total = 0.0
        for r in rings { total += 0.4 + r.thickness }
        var run = 0.0
        for r in rings {
            run += 0.4 + r.thickness
            acc.append(run / total)
        }
        ctx.fill(Path(CGRect(origin: .zero, size: size)), with: .color(Bark.paperWarm))
        for i in stride(from: rings.count - 1, through: 0, by: -1) {
            let rad = maxR * CGFloat(acc[i])
            let dark = i % 2 == 0
            let base: Color
            switch ring {
            case .yew: base = i >= rings.count - 3 ? Bark.yewSap : Bark.yewHeart
            case .bamboo: base = Bark.bamboo
            case .composite: base = Bark.horn
            default: base = i % 2 == 0 ? Bark.osageDark : Bark.osage
            }
            let tone = dark ? base : base.opacity(0.42)
            ctx.fill(Path(ellipseIn: CGRect(x: cx - rad, y: cy - rad, width: rad * 2, height: rad * 2)),
                     with: .color(tone))
        }
        for i in 0..<rings.count {
            let rad = maxR * CGFloat(acc[i])
            ctx.stroke(Path(ellipseIn: CGRect(x: cx - rad, y: cy - rad, width: rad * 2, height: rad * 2)),
                       with: .color(Bark.oakDark.opacity(0.42)), lineWidth: 1)
            if !rings[i].sound {
                var p = Path()
                let a = Double(i) * 1.7
                let ca = CGFloat(cos(a)), sa = CGFloat(sin(a))
                let cb = CGFloat(cos(a + 0.10)), sb = CGFloat(sin(a + 0.10))
                p.move(to: CGPoint(x: cx + ca * rad * 0.62, y: cy + sa * rad * 0.62))
                p.addLine(to: CGPoint(x: cx + cb * rad, y: cy + sb * rad))
                ctx.stroke(p, with: .color(Bark.oxblood.opacity(0.7)), lineWidth: 2)
            }
        }
        if let c = chosen, c < acc.count {
            let rad = maxR * CGFloat(acc[c])
            ctx.stroke(Path(ellipseIn: CGRect(x: cx - rad, y: cy - rad, width: rad * 2, height: rad * 2)),
                       with: .color(Bark.moss), lineWidth: 3)
        }
        ctx.stroke(Path(ellipseIn: CGRect(x: cx - maxR, y: cy - maxR, width: maxR * 2, height: maxR * 2)),
                   with: .color(Bark.ink), lineWidth: 2)
        var pith = Path()
        pith.addEllipse(in: CGRect(x: cx - 5, y: cy - 5, width: 10, height: 10))
        ctx.fill(pith, with: .color(Bark.oakDark))
    }
}
