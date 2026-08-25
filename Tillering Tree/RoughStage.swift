import SwiftUI

struct RoughStageView: View {
    @ObservedObject var session: MakeSession
    @State private var passes: Int = 0
    @State private var lastSeg: Int = -1

    var body: some View {
        VStack(spacing: 12) {
            Text("Drag the drawknife along each limb until the wood meets the dotted line.")
                .font(Bark.serif(14)).foregroundColor(Bark.inkSoft)
                .multilineTextAlignment(.center)
            GeometryReader { geo in
                ProfileCanvas(session: session)
                    .contentShape(Rectangle())
                    .gesture(DragGesture(minimumDistance: 0).onChanged { v in
                        handle(v.location, geo.size)
                    })
            }
            .frame(height: 300)
            .background(Bark.paperWarm)
            .overlay(Rectangle().stroke(Bark.ink.opacity(0.18), lineWidth: 1))
            HStack(spacing: 12) {
                MeterBar(label: "Floor tiller", value: session.roughCloseness, tone: Bark.moss)
                MeterBar(label: "Passes", value: min(1, Double(passes) / 200), tone: Bark.oak)
            }
            WoodButton(title: "Put it on the long string",
                       enabled: session.roughCloseness > 0.30) {
                session.finishRough(session.roughCloseness)
            }
            if session.roughCloseness <= 0.30 {
                Text("The limbs are still far from the line.")
                    .font(Bark.serifItalic(13)).foregroundColor(Bark.inkPale)
            }
        }
    }

    private func handle(_ p: CGPoint, _ size: CGSize) {
        let inset: CGFloat = 26
        let usable = size.width - inset * 2
        guard usable > 10 else { return }
        let f = Double((p.x - inset) / usable)
        guard f >= 0, f <= 1 else { return }
        let seg = min(segCount - 1, max(0, Int(f * Double(segCount))))
        let upper = p.y < size.height * 0.5
        let target = session.roughTarget[seg]
        let cur = upper ? session.build.upper.thick[seg] : session.build.lower.thick[seg]
        let over = max(0, cur - target)
        let bite = 0.006 + over * 0.10
        session.plane(upper: upper, segment: seg, rawAmount: bite)
        if seg != lastSeg { passes += 1; lastSeg = seg }
    }
}

struct MeterBar: View {
    let label: String
    let value: Double
    var tone: Color = Bark.moss
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                SmallCap(text: label)
                Spacer()
                Text(String(format: "%.0f%%", max(0, min(1, value)) * 100))
                    .font(Bark.serifBold(12)).foregroundColor(Bark.inkSoft)
            }
            GeometryReader { g in
                ZStack(alignment: .leading) {
                    Rectangle().fill(Bark.ink.opacity(0.10))
                    Rectangle().fill(tone).frame(width: g.size.width * CGFloat(max(0, min(1, value))))
                }
            }
            .frame(height: 7)
            .overlay(Rectangle().stroke(Bark.ink.opacity(0.22), lineWidth: 1))
        }
    }
}

struct ProfileCanvas: View {
    @ObservedObject var session: MakeSession

    var body: some View {
        Canvas { ctx, size in
            draw(&ctx, size)
        }
    }

    private func draw(_ ctx: inout GraphicsContext, _ size: CGSize) {
        let inset: CGFloat = 26
        let usable = size.width - inset * 2
        let half = size.height * 0.5
        let scale = size.height * 0.30
        let target = session.roughTarget
        drawBand(&ctx, thick: session.build.upper.thick, target: target,
                 baseY: half - 14, dir: -1, inset: inset, usable: usable, scale: scale,
                 label: "UPPER LIMB")
        drawBand(&ctx, thick: session.build.lower.thick, target: target,
                 baseY: half + 14, dir: 1, inset: inset, usable: usable, scale: scale,
                 label: "LOWER LIMB")
        var mid = Path()
        mid.move(to: CGPoint(x: inset, y: half))
        mid.addLine(to: CGPoint(x: inset + usable, y: half))
        ctx.stroke(mid, with: .color(Bark.ink.opacity(0.35)), lineWidth: 1)
    }

    private func drawBand(_ ctx: inout GraphicsContext, thick: [Double], target: [Double],
                          baseY: CGFloat, dir: CGFloat, inset: CGFloat, usable: CGFloat,
                          scale: CGFloat, label: String) {
        func stepPath(_ vals: [Double]) -> Path {
            var p = Path()
            p.move(to: CGPoint(x: inset, y: baseY))
            for i in 0..<segCount {
                let x0 = inset + usable * CGFloat(i) / CGFloat(segCount)
                let x1 = inset + usable * CGFloat(i + 1) / CGFloat(segCount)
                let h = CGFloat(vals[i]) * scale
                p.addLine(to: CGPoint(x: x0, y: baseY + dir * h))
                p.addLine(to: CGPoint(x: x1, y: baseY + dir * h))
            }
            p.addLine(to: CGPoint(x: inset + usable, y: baseY))
            p.closeSubpath()
            return p
        }
        let full = stepPath(thick)
        ctx.fill(full, with: .color(Bark.oxblood.opacity(0.15)))
        let keep = stepPath(zip(thick, target).map { min($0, $1) })
        ctx.fill(keep, with: .color(Bark.oakPale))
        for i in 0..<segCount {
            let x0 = inset + usable * (CGFloat(i) + 0.5) / CGFloat(segCount)
            var g = Path()
            g.move(to: CGPoint(x: x0, y: baseY))
            g.addLine(to: CGPoint(x: x0, y: baseY + dir * CGFloat(min(thick[i], target[i])) * scale))
            ctx.stroke(g, with: .color(Bark.oakDark.opacity(0.22)), lineWidth: 1)
        }
        ctx.stroke(full, with: .color(Bark.ink.opacity(0.55)), lineWidth: 1.2)
        ctx.stroke(keep, with: .color(Bark.ink), lineWidth: 1.4)

        var tp = Path()
        for i in 0..<segCount {
            let x0 = inset + usable * (CGFloat(i) + 0.5) / CGFloat(segCount)
            let y = baseY + dir * CGFloat(target[i]) * scale
            if i == 0 { tp.move(to: CGPoint(x: x0, y: y)) } else { tp.addLine(to: CGPoint(x: x0, y: y)) }
        }
        ctx.stroke(tp, with: .color(Bark.ink.opacity(0.85)),
                   style: StrokeStyle(lineWidth: 1.8, dash: [5, 4]))
        ctx.draw(Text(label).font(Bark.serif(10)).foregroundColor(Bark.inkPale),
                 at: CGPoint(x: inset + 4, y: baseY + dir * 6), anchor: dir < 0 ? .bottomLeading : .topLeading)
        ctx.draw(Text("handle").font(Bark.serif(9)).foregroundColor(Bark.inkPale),
                 at: CGPoint(x: inset + 2, y: baseY - dir * 8), anchor: dir < 0 ? .topLeading : .bottomLeading)
        ctx.draw(Text("tip").font(Bark.serif(9)).foregroundColor(Bark.inkPale),
                 at: CGPoint(x: inset + usable - 2, y: baseY - dir * 8), anchor: dir < 0 ? .topTrailing : .bottomTrailing)
    }
}
