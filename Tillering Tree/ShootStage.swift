import SwiftUI

struct ArrowMark: Identifiable {
    let id = UUID()
    let x: Double
    let y: Double
    let score: Int
}

func ringScore(_ d: Double) -> Int {
    let r = max(0.0, min(1.2, d))
    if r > 1.0 { return 0 }
    return max(1, 10 - Int(r * 10))
}

struct TargetFace: View {
    let marks: [ArrowMark]
    var aim: CGPoint? = nil

    var body: some View {
        Canvas { ctx, size in
            draw(&ctx, size)
        }
    }

    private func draw(_ ctx: inout GraphicsContext, _ size: CGSize) {
        let c = CGPoint(x: size.width / 2, y: size.height / 2)
        let R = min(size.width, size.height) * 0.46
        let tones: [Color] = [Bark.linen, Bark.linen, Bark.night.opacity(0.85), Bark.night.opacity(0.85),
                              Color(red: 0.271, green: 0.408, blue: 0.545),
                              Color(red: 0.271, green: 0.408, blue: 0.545),
                              Bark.oxblood, Bark.oxblood, Bark.gold, Bark.gold]
        for k in stride(from: 10, through: 1, by: -1) {
            let rad = R * CGFloat(k) / 10
            ctx.fill(Path(ellipseIn: CGRect(x: c.x - rad, y: c.y - rad, width: rad * 2, height: rad * 2)),
                     with: .color(tones[10 - k]))
        }
        for k in stride(from: 10, through: 1, by: -1) {
            let rad = R * CGFloat(k) / 10
            ctx.stroke(Path(ellipseIn: CGRect(x: c.x - rad, y: c.y - rad, width: rad * 2, height: rad * 2)),
                       with: .color(Bark.ink.opacity(0.35)), lineWidth: 1)
        }
        var stand = Path()
        stand.move(to: CGPoint(x: c.x - R * 0.5, y: c.y + R))
        stand.addLine(to: CGPoint(x: c.x - R * 0.8, y: size.height))
        stand.move(to: CGPoint(x: c.x + R * 0.5, y: c.y + R))
        stand.addLine(to: CGPoint(x: c.x + R * 0.8, y: size.height))
        ctx.stroke(stand, with: .color(Bark.oakDark.opacity(0.7)), lineWidth: 4)

        for m in marks {
            let p = CGPoint(x: c.x + CGFloat(m.x) * R, y: c.y + CGFloat(m.y) * R)
            let tail = CGPoint(x: p.x + 30, y: p.y - 40)
            var sh = Path()
            sh.move(to: CGPoint(x: p.x + 3, y: p.y + 4))
            sh.addLine(to: CGPoint(x: tail.x + 3, y: tail.y + 4))
            ctx.stroke(sh, with: .color(Bark.ink.opacity(0.25)), lineWidth: 2.6)
            var shaft = Path()
            shaft.move(to: p)
            shaft.addLine(to: tail)
            ctx.stroke(shaft, with: .color(Bark.pineTone), lineWidth: 2.2)
            ctx.stroke(shaft, with: .color(Bark.ink.opacity(0.45)), lineWidth: 0.8)
            var fl = Path()
            fl.move(to: CGPoint(x: tail.x - 11, y: tail.y + 14))
            fl.addLine(to: CGPoint(x: tail.x + 2, y: tail.y + 1))
            fl.addLine(to: CGPoint(x: tail.x - 3, y: tail.y + 15))
            fl.closeSubpath()
            ctx.fill(fl, with: .color(Bark.oxblood.opacity(0.85)))
            ctx.stroke(fl, with: .color(Bark.ink.opacity(0.5)), lineWidth: 0.7)
            ctx.fill(Path(ellipseIn: CGRect(x: p.x - 2, y: p.y - 2, width: 4, height: 4)),
                     with: .color(Bark.ink))
        }
        if let a = aim {
            var cross = Path()
            cross.move(to: CGPoint(x: a.x - 12, y: a.y))
            cross.addLine(to: CGPoint(x: a.x + 12, y: a.y))
            cross.move(to: CGPoint(x: a.x, y: a.y - 12))
            cross.addLine(to: CGPoint(x: a.x, y: a.y + 12))
            ctx.stroke(cross, with: .color(Bark.paperWarm.opacity(0.85)), lineWidth: 1.4)
        }
    }
}

extension Bark {
    static let pineTone = Color(red: 0.831, green: 0.729, blue: 0.549)
}

struct DrawGauge: View {
    let pull: Double
    let target: Int
    let hold: Double
    let wobble: Double

    var body: some View {
        VStack(spacing: 5) {
            HStack {
                SmallCap(text: "Draw")
                Spacer()
                Text(String(format: "%.0f\"", pull * Double(target)))
                    .font(Bark.serifBold(15)).foregroundColor(Bark.ink)
            }
            GeometryReader { g in
                ZStack(alignment: .topLeading) {
                    Rectangle().fill(Bark.ink.opacity(0.10))
                        .frame(width: g.size.width, height: g.size.height)
                    Rectangle().fill(Bark.moss.opacity(0.28))
                        .frame(width: g.size.width * 0.12, height: g.size.height)
                        .offset(x: g.size.width * 0.88)
                    Rectangle().fill(Bark.walnut)
                        .frame(width: g.size.width * CGFloat(max(0, min(1, pull))), height: g.size.height)
                    Rectangle().fill(Bark.oxblood)
                        .frame(width: 2, height: g.size.height)
                        .offset(x: g.size.width * CGFloat(max(0, min(0.99, pull + wobble))))
                }
            }
            .frame(height: 14)
            .overlay(Rectangle().stroke(Bark.ink.opacity(0.25), lineWidth: 1))
            HStack {
                Text(wobble > 0.06 ? "Shaking" : "Steady").font(Bark.serif(11))
                    .foregroundColor(wobble > 0.06 ? Bark.oxblood : Bark.inkPale)
                Spacer()
                Text(String(format: "held %.1f s", hold)).font(Bark.serif(11)).foregroundColor(Bark.inkPale)
            }
        }
    }
}

final class ShootRun: ObservableObject {
    @Published var marks: [ArrowMark] = []
    @Published var pull: Double = 0
    @Published var hold: Double = 0
    @Published var wobble: Double = 0
    @Published var done = false
    @Published var last: String = ""
    let arrows: Int
    let quality: Double
    let cast: Double
    let poundage: Double
    private var rng: Seeded
    private var timer: Timer? = nil

    init(arrows: Int, quality: Double, cast: Double, poundage: Double, seed: UInt64) {
        self.arrows = arrows
        self.quality = quality
        self.cast = cast
        self.poundage = poundage
        self.rng = Seeded(seed)
    }

    var total: Int { marks.reduce(0) { $0 + $1.score } }

    func start() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 20.0, repeats: true) { [weak self] _ in
            guard let s = self else { return }
            if s.pull > 0.55 {
                s.hold += 1.0 / 20.0
                let strain = (s.poundage / 60.0) * (0.4 + s.pull)
                s.wobble = min(0.22, s.wobble + 0.0022 * strain * (1 + s.hold * 0.30))
            } else {
                s.hold = max(0, s.hold - 0.06)
                s.wobble = max(0, s.wobble - 0.010)
            }
        }
    }

    func stop() { timer?.invalidate(); timer = nil }

    func loose() {
        guard marks.count < arrows else { return }
        let short = max(0, 0.92 - pull)
        let spread = 0.10 + (1 - quality) * 0.55 + wobble * 1.6 + short * 1.1
        let a = rng.r(0, .pi * 2)
        let d = spread * (0.30 + rng.d() * 0.9)
        let drop = short * 0.9 + (1 - cast) * 0.22
        let x = cos(a) * d
        let y = sin(a) * d + drop
        let dist = (x * x + y * y).squareRoot()
        let sc = ringScore(dist)
        marks.append(ArrowMark(x: x, y: y, score: sc))
        last = sc == 0 ? "Off the boss." : (sc >= 9 ? "Gold." : (sc >= 7 ? "Red." : (sc >= 5 ? "Blue." : "In the black.")))
        pull = 0
        hold = 0
        wobble = 0
        if marks.count >= arrows { done = true; stop() }
    }
}

struct ShootPanel: View {
    @ObservedObject var run: ShootRun
    let drawTo: Int

    var body: some View {
        VStack(spacing: 12) {
            TargetFace(marks: run.marks)
                .aspectRatio(1.0, contentMode: .fit)
                .background(Bark.paperWarm)
                .overlay(Rectangle().stroke(Bark.ink.opacity(0.18), lineWidth: 1))
            DrawGauge(pull: run.pull, target: drawTo, hold: run.hold, wobble: run.wobble)
            ZStack {
                RoundedRectangle(cornerRadius: 3).fill(Bark.linen)
                    .overlay(RoundedRectangle(cornerRadius: 3).stroke(Bark.ink.opacity(0.25), lineWidth: 1))
                VStack(spacing: 3) {
                    Text(run.pull > 0.02 ? "Lift to loose" : "Drag up to draw")
                        .font(Bark.serifBold(13)).tracking(1.6).foregroundColor(Bark.inkSoft)
                    Text(run.last).font(Bark.serifItalic(13)).foregroundColor(Bark.oxblood)
                }
            }
            .frame(height: 62)
            .contentShape(Rectangle())
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { v in
                    run.pull = max(0, min(1.0, Double(-v.translation.height) / 190.0))
                }
                .onEnded { _ in
                    if run.pull > 0.12 { run.loose() } else { run.pull = 0 }
                })
            HStack {
                SmallCap(text: "Arrows \(run.marks.count) of \(run.arrows)")
                Spacer()
                Text("Score \(run.total)").font(Bark.serifBold(16)).foregroundColor(Bark.ink)
            }
        }
        .onAppear { run.start() }
        .onDisappear { run.stop() }
    }
}

struct ShootStageView: View {
    @ObservedObject var session: MakeSession
    @StateObject private var run: ShootRun

    init(session: MakeSession) {
        self.session = session
        _run = StateObject(wrappedValue: ShootRun(arrows: 3,
                                                  quality: session.tillerScore,
                                                  cast: session.castScore,
                                                  poundage: session.reading.pounds,
                                                  seed: session.seed &+ 991))
    }

    var body: some View {
        VStack(spacing: 12) {
            ShootPanel(run: run, drawTo: session.entry.draw)
            if run.done {
                WoodButton(title: "Hang it on the rack", tone: Bark.moss.opacity(0.9)) {
                    session.shootScore = min(1, Double(run.total) / 27.0)
                    session.stage = .shoot
                    session.finishedID = UUID().uuidString
                }
            }
        }
    }
}
