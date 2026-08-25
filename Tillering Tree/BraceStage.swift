import SwiftUI

func idealBrace(_ shape: LimbShape) -> Double {
    switch shape {
    case .longbow: return 6.0
    case .flatbow, .pyramid, .deflex, .holmegaard: return 6.6
    case .recurve: return 7.4
    case .composite: return 7.8
    case .yumi: return 6.0
    }
}

struct BraceStageView: View {
    @ObservedObject var session: MakeSession
    @State private var shot = 0
    @State private var running = false

    private var offBy: Double { abs(session.braceHeight - idealBrace(session.entry.shape)) }
    private var quiet: Double { max(0, 1 - offBy / 1.6) }
    private var speed: Double { max(0, 1 - max(0, session.braceHeight - idealBrace(session.entry.shape)) / 2.4) }
    private var score: Double { max(0, min(1, quiet * 0.55 + speed * 0.45)) }

    var body: some View {
        VStack(spacing: 12) {
            BraceCanvas(session: session, shot: shot)
                .frame(height: 250)
                .background(Bark.paperWarm)
                .overlay(Rectangle().stroke(Bark.ink.opacity(0.18), lineWidth: 1))

            VStack(spacing: 6) {
                HStack {
                    SmallCap(text: "Brace height")
                    Spacer()
                    Text(String(format: "%.1f in", session.braceHeight))
                        .font(Bark.serifBold(16)).foregroundColor(Bark.ink)
                }
                Slider(value: $session.braceHeight, in: 4.5...9.0, step: 0.1)
                    .accentColor(Bark.walnut)
                HStack {
                    Text("Slapping the arm").font(Bark.serif(11)).foregroundColor(Bark.inkPale)
                    Spacer()
                    Text("Quiet and slow").font(Bark.serif(11)).foregroundColor(Bark.inkPale)
                }
                if session.kit.hasSquare {
                    HStack(spacing: 6) {
                        StrokeGlyph(shape: GlyphMark(), tone: Bark.moss, width: 1.8)
                            .frame(width: 12, height: 12)
                        Text(String(format: "The square reads %.1f in for this pattern",
                                    idealBrace(session.entry.shape)))
                            .font(Bark.serifBold(13)).foregroundColor(Bark.moss)
                        Spacer()
                    }
                }
            }
            .padding(10)
            .background(Paperboard())

            HStack(spacing: 12) {
                MeterBar(label: "Quiet", value: quiet, tone: Bark.moss)
                MeterBar(label: "Cast", value: speed, tone: Bark.oak)
            }

            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 2) {
                    SmallCap(text: "String follow")
                    Text(String(format: "%.1f in", session.followInches))
                        .font(Bark.serifBold(18))
                        .foregroundColor(session.followInches > 2.2 ? Bark.oxblood : Bark.ink)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    SmallCap(text: "Shot in")
                    Text("\(shot) of 30").font(Bark.serifBold(18)).foregroundColor(Bark.ink)
                }
            }

            if shot < 30 {
                WoodButton(title: running ? "Shooting in" : "Shoot it in") {
                    guard !running else { return }
                    running = true
                    fireBatch()
                }
            } else {
                WoodButton(title: "Cut the nocks and finish", tone: Bark.moss.opacity(0.9)) {
                    session.finishBrace(score)
                }
            }
        }
    }

    private func fireBatch() {
        guard shot < 30 else { running = false; return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
            shot += 3
            let strainBump = dropForDraw(Double(session.entry.draw), target: session.entry.draw)
            _ = session.build.apply(draw: strainBump * (0.94 + offBy * 0.02))
            session.objectWillChange.send()
            if shot >= 30 { shot = 30; running = false } else { fireBatch() }
        }
    }
}

struct BraceCanvas: View {
    @ObservedObject var session: MakeSession
    let shot: Int

    var body: some View {
        Canvas { ctx, size in
            draw(&ctx, size)
        }
    }

    private func draw(_ ctx: inout GraphicsContext, _ size: CGSize) {
        let cx = size.width * 0.72
        let topY = size.height * 0.10
        let botY = size.height * 0.90
        let L = (botY - topY) * 0.5

        let r = session.build.reading(draw: dropForDraw(session.braceHeight * 1.9,
                                                        target: session.entry.draw))
        var upper: [CGPoint] = []
        var lower: [CGPoint] = []
        for p in r.upper.points {
            upper.append(CGPoint(x: cx - CGFloat(p.y) * L * 2.1, y: topY + L - CGFloat(p.x) * L))
        }
        for p in r.lower.points {
            lower.append(CGPoint(x: cx - CGFloat(p.y) * L * 2.1, y: topY + L + CGFloat(p.x) * L))
        }
        var limb = Path()
        limb.move(to: lower[lower.count - 1])
        for p in lower.reversed() { limb.addLine(to: p) }
        for p in upper { limb.addLine(to: p) }
        ctx.stroke(limb, with: .color(Bark.ink.opacity(0.30)), style: StrokeStyle(lineWidth: 11, lineCap: .round))
        ctx.stroke(limb, with: .color(Bark.yewHeart), style: StrokeStyle(lineWidth: 8.5, lineCap: .round))
        ctx.stroke(limb, with: .color(Bark.yewSap.opacity(0.8)), style: StrokeStyle(lineWidth: 3, lineCap: .round))

        let tu = upper[upper.count - 1]
        let tl = lower[lower.count - 1]
        var str = Path()
        str.move(to: tu)
        str.addLine(to: tl)
        ctx.stroke(str, with: .color(Bark.hemp), lineWidth: 2.4)
        ctx.stroke(str, with: .color(Bark.ink.opacity(0.45)), lineWidth: 1)

        let midY = topY + L
        let stringX = (tu.x + tl.x) * 0.5
        var measure = Path()
        measure.move(to: CGPoint(x: cx, y: midY))
        measure.addLine(to: CGPoint(x: stringX, y: midY))
        ctx.stroke(measure, with: .color(Bark.oxblood.opacity(0.85)),
                   style: StrokeStyle(lineWidth: 1.6, dash: [4, 3]))
        var caps = Path()
        for x in [cx, stringX] {
            caps.move(to: CGPoint(x: x, y: midY - 7))
            caps.addLine(to: CGPoint(x: x, y: midY + 7))
        }
        ctx.stroke(caps, with: .color(Bark.oxblood.opacity(0.85)), lineWidth: 1.4)
        ctx.draw(Text(String(format: "%.1f in", session.braceHeight))
                    .font(Bark.serifBold(13)).foregroundColor(Bark.oxblood),
                 at: CGPoint(x: stringX - 10, y: midY - 4), anchor: .trailing)

        var grip = Path()
        grip.addRect(CGRect(x: cx - 7, y: midY - 22, width: 14, height: 44))
        ctx.fill(grip, with: .color(Bark.leather))
        ctx.stroke(grip, with: .color(Bark.ink.opacity(0.6)), lineWidth: 1)

        for k in 0..<min(6, shot / 5) {
            var a = Path()
            let y = topY + 22 + CGFloat(k) * 26
            a.move(to: CGPoint(x: size.width * 0.05, y: y))
            a.addLine(to: CGPoint(x: size.width * 0.24, y: y))
            ctx.stroke(a, with: .color(Bark.pineTone), lineWidth: 2.4)
            var f = Path()
            f.move(to: CGPoint(x: size.width * 0.05, y: y))
            f.addLine(to: CGPoint(x: size.width * 0.09, y: y - 5))
            f.addLine(to: CGPoint(x: size.width * 0.09, y: y + 5))
            f.closeSubpath()
            ctx.fill(f, with: .color(Bark.oxblood.opacity(0.75)))
        }
    }
}
