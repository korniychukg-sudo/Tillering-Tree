import SwiftUI

struct TillerStageView: View {
    @ObservedObject var session: MakeSession
    @State private var showGizmo = false
    @State private var glow = false
    @State private var touched: (Bool, Int)? = nil

    var body: some View {
        let r = session.reading
        return VStack(spacing: 10) {
            GeometryReader { geo in
                TreeCanvas(session: session, reading: r, touched: touched,
                           marked: showGizmo ? session.lazySegment : nil)
                    .contentShape(Rectangle())
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged { v in scrapeAt(v.location, geo.size) }
                        .onEnded { _ in touched = nil })
            }
            .frame(height: 300)
            .background(Bark.paperWarm)
            .overlay(Rectangle().stroke(Bark.ink.opacity(0.18), lineWidth: 1))

            HStack(alignment: .firstTextBaseline, spacing: 14) {
                VStack(alignment: .leading, spacing: 2) {
                    SmallCap(text: "Draw")
                    Text("\(Int(session.notchInches))\"")
                        .font(Bark.serifBold(26)).foregroundColor(Bark.ink)
                }
                VStack(alignment: .leading, spacing: 2) {
                    SmallCap(text: "On the scale")
                    Text(session.kit.weightReading(r.pounds, seed: session.seed))
                        .font(Bark.serifBold(session.kit.hasScale ? 26 : 21))
                        .foregroundColor(session.weightError < 0.08 ? Bark.moss :
                                            (r.pounds > Double(session.entry.weight) ? Bark.ink : Bark.oxblood))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    SmallCap(text: "Aim for")
                    Text("\(session.entry.weight) lb at \(session.entry.draw)\"")
                        .font(Bark.serif(14)).foregroundColor(Bark.inkSoft)
                }
            }

            HStack(spacing: 12) {
                MeterBar(label: "Even", value: r.evenness, tone: Bark.moss)
                MeterBar(label: "Balance", value: r.balance, tone: Bark.oak)
            }

            if session.onLongString {
                Text("The long string is on. Pull as far as you like up to twenty inches; nothing is being strained yet.")
                    .font(Bark.serifItalic(13)).foregroundColor(Bark.moss)
                    .fixedSize(horizontal: false, vertical: true)
            } else if let m = session.message {
                Text(m).font(Bark.serifItalic(13)).foregroundColor(Bark.oxblood)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else if r.peakStrain > session.build.setStrain * 0.92 {
                Text("Something is working too hard. Take wood off the lazy parts before you pull further.")
                    .font(Bark.serifItalic(13)).foregroundColor(Bark.oxblood)
            } else {
                Text("Drag along a limb to scrape. Scrape where it is not bending.")
                    .font(Bark.serifItalic(13)).foregroundColor(Bark.inkPale)
            }

            if showGizmo && session.kit.hasGizmo { GizmoStrip(session: session, reading: r) }

            HStack(spacing: 10) {
                if session.kit.hasGizmo {
                    QuietButton(title: showGizmo ? "Hide gizmo" : "Gizmo") { showGizmo.toggle() }
                } else {
                    QuietButton(title: "No gizmo", tone: Bark.inkPale) { }
                }
                QuietButton(title: "Let down") { session.stepNotch(-1) }
                WoodButton(title: session.notch >= session.maxNotch ? "Pull again" : "Pull to \(Int(session.notchInches) + 2)\"") {
                    if session.notch < session.maxNotch { session.stepNotch(1) }
                    session.pullToNotch()
                }
            }

            if session.tillerReady {
                WoodButton(title: "Take it off the tree", tone: Bark.moss.opacity(0.9)) {
                    session.finishTiller()
                }
            }
        }
    }

    private func scrapeAt(_ p: CGPoint, _ size: CGSize) {
        let cx = size.width * 0.5
        let handleY = size.height * 0.20
        let L = size.width * 0.42
        let upper = p.x >= cx
        let dx = Double(abs(p.x - cx) / max(1, L))
        guard dx <= 1.02, p.y > handleY - 60 else { return }
        let seg = min(segCount - 1, max(0, Int(dx * Double(segCount))))
        session.scrape(upper: upper, segment: seg)
        touched = (upper, seg)
    }
}

struct GizmoStrip: View {
    @ObservedObject var session: MakeSession
    let reading: DrawReading

    var body: some View {
        VStack(spacing: 4) {
            SmallCap(text: "Work done by each part of the limb")
            HStack(spacing: 3) {
                ForEach(0..<segCount, id: \.self) { i in
                    bar(reading.lower.strain[segCount - 1 - i])
                }
                Rectangle().fill(Bark.ink.opacity(0.4)).frame(width: 1, height: 30)
                ForEach(0..<segCount, id: \.self) { i in
                    bar(reading.upper.strain[i])
                }
            }
            .frame(height: 40, alignment: .bottom)
        }
        .padding(8)
        .background(Paperboard())
    }

    private func bar(_ s: Double) -> some View {
        let f = max(0.05, min(1.4, s / max(1e-6, session.build.setStrain)))
        let tone: Color = f > 0.94 ? Bark.oxblood : (f > 0.74 ? Bark.oak : Bark.iron.opacity(0.55))
        return Rectangle().fill(tone).frame(height: CGFloat(f) * 28)
    }
}

struct TreeCanvas: View {
    @ObservedObject var session: MakeSession
    let reading: DrawReading
    let touched: (Bool, Int)?
    var marked: (Bool, Int)? = nil

    var body: some View {
        Canvas { ctx, size in
            draw(&ctx, size)
        }
    }

    private func draw(_ ctx: inout GraphicsContext, _ size: CGSize) {
        let cx = size.width * 0.5
        let handleY = size.height * 0.20
        let L = size.width * 0.42

        var post = Path()
        post.addRect(CGRect(x: cx - 11, y: 0, width: 22, height: size.height))
        ctx.fill(post, with: .color(Bark.oak))
        ctx.stroke(post, with: .color(Bark.ink.opacity(0.6)), lineWidth: 1.2)

        for k in 0..<9 {
            let y = handleY + 44 + CGFloat(k) * 24
            guard y < size.height - 8 else { break }
            var n = Path()
            n.move(to: CGPoint(x: cx + 11, y: y))
            n.addLine(to: CGPoint(x: cx + 24, y: y - 4))
            ctx.stroke(n, with: .color(Bark.ink.opacity(0.55)), lineWidth: 1.4)
        }

        var cradle = Path()
        cradle.addRect(CGRect(x: cx - 26, y: handleY - 20, width: 52, height: 22))
        ctx.fill(cradle, with: .color(Bark.leather))
        ctx.stroke(cradle, with: .color(Bark.ink), lineWidth: 1.2)

        let tipU = limbPath(&ctx, curve: reading.upper, thick: session.build.upper.thick,
                            strain: reading.upper.strain, cx: cx, handleY: handleY, L: L,
                            sign: 1, hot: touched?.0 == true ? touched?.1 : nil,
                            mark: marked?.0 == true ? marked?.1 : nil)
        let tipL = limbPath(&ctx, curve: reading.lower, thick: session.build.lower.thick,
                            strain: reading.lower.strain, cx: cx, handleY: handleY, L: L,
                            sign: -1, hot: touched?.0 == false ? touched?.1 : nil,
                            mark: marked?.0 == false ? marked?.1 : nil)

        let apexY = max(tipU.y, tipL.y) + L * 0.16
        var str = Path()
        str.move(to: tipU)
        str.addLine(to: CGPoint(x: cx, y: apexY))
        str.addLine(to: tipL)
        ctx.stroke(str, with: .color(Bark.hemp.opacity(0.95)), lineWidth: 2)
        ctx.stroke(str, with: .color(Bark.ink.opacity(0.4)), lineWidth: 0.8)

        var hook = Path()
        hook.move(to: CGPoint(x: cx - 12, y: apexY))
        hook.addLine(to: CGPoint(x: cx + 12, y: apexY - 6))
        ctx.stroke(hook, with: .color(Bark.iron), lineWidth: 3)

        ctx.draw(Text("\(Int(session.notchInches))\"").font(Bark.serif(11)).foregroundColor(Bark.inkPale),
                 at: CGPoint(x: cx + 30, y: apexY), anchor: .leading)
    }

    private func limbPath(_ ctx: inout GraphicsContext, curve: LimbCurve, thick: [Double],
                          strain: [Double], cx: CGFloat, handleY: CGFloat, L: CGFloat,
                          sign: CGFloat, hot: Int?, mark: Int? = nil) -> CGPoint {
        var pts: [CGPoint] = []
        for p in curve.points {
            pts.append(CGPoint(x: cx + sign * CGFloat(p.x) * L, y: handleY + CGFloat(p.y) * L))
        }
        let widths = session.build.upper.width
        var half: [CGFloat] = []
        for i in 0...segCount {
            let k = min(segCount - 1, i)
            half.append(max(2.2, CGFloat(widths[k] * thick[k]) * 19))
        }
        var norm: [CGPoint] = []
        for i in 0...segCount {
            let a = pts[max(0, i - 1)], b = pts[min(segCount, i + 1)]
            var tx = b.x - a.x, ty = b.y - a.y
            let l = max(0.0001, sqrt(tx * tx + ty * ty))
            tx /= l; ty /= l
            norm.append(CGPoint(x: -ty, y: tx))
        }
        func edge(_ k: CGFloat) -> [CGPoint] {
            var out: [CGPoint] = []
            for i in 0...segCount {
                out.append(CGPoint(x: pts[i].x + norm[i].x * half[i] * k,
                                   y: pts[i].y + norm[i].y * half[i] * k))
            }
            return out
        }
        let back = edge(1)
        let belly = edge(-1)
        var body = Path()
        body.move(to: back[0])
        for p in back.dropFirst() { body.addLine(to: p) }
        for p in belly.reversed() { body.addLine(to: p) }
        body.closeSubpath()
        let shadow = body.applying(CGAffineTransform(translationX: 3, y: 6))
        ctx.fill(shadow, with: .color(Bark.ink.opacity(0.10)))
        ctx.fill(body, with: .color(Bark.yew))

        for i in 0..<segCount {
            var quad = Path()
            quad.move(to: back[i])
            quad.addLine(to: back[i + 1])
            quad.addLine(to: belly[i + 1])
            quad.addLine(to: belly[i])
            quad.closeSubpath()
            let f = max(0, min(1.3, strain[i] / max(1e-6, session.build.setStrain)))
            var tone = Bark.yew
            if f > 0.94 { tone = Bark.oxblood.opacity(0.85) }
            else if f > 0.76 { tone = Bark.osage.opacity(0.85) }
            else if f < 0.48 { tone = Bark.iron.opacity(0.30) }
            else { tone = Bark.yew }
            if hot == i { tone = Bark.moss.opacity(0.85) }
            ctx.fill(quad, with: .color(tone))
        }
        var backLine = Path()
        backLine.move(to: back[0])
        for p in back.dropFirst() { backLine.addLine(to: p) }
        var bellyLine = Path()
        bellyLine.move(to: belly[0])
        for p in belly.dropFirst() { bellyLine.addLine(to: p) }
        ctx.stroke(backLine, with: .color(Bark.ink.opacity(0.75)), lineWidth: 1.3)
        ctx.stroke(bellyLine, with: .color(Bark.ink.opacity(0.85)), lineWidth: 1.6)
        if let m = mark, m < segCount {
            var flag = Path()
            let a = back[m], b = back[m + 1]
            let mx = (a.x + b.x) / 2, my = (a.y + b.y) / 2
            let nx = norm[m].x, ny = norm[m].y
            flag.move(to: CGPoint(x: mx + nx * 6, y: my + ny * 6))
            flag.addLine(to: CGPoint(x: mx + nx * 26, y: my + ny * 26))
            ctx.stroke(flag, with: .color(Bark.moss), lineWidth: 2.4)
            ctx.fill(Path(ellipseIn: CGRect(x: mx + nx * 26 - 4, y: my + ny * 26 - 4,
                                            width: 8, height: 8)), with: .color(Bark.moss))
        }
        var nock = Path()
        nock.move(to: back[segCount])
        nock.addLine(to: belly[segCount])
        ctx.stroke(nock, with: .color(Bark.ink), lineWidth: 2)
        return pts[segCount]
    }
}
