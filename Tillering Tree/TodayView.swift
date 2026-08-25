import SwiftUI

struct DailyJob {
    let key: String
    let title: String
    let detail: String
    let reward: Int
    let done: (TillerSave) -> Bool
    let progress: (TillerSave) -> Double
}

func jobsFor(_ seed: DaySeed) -> DailyJob {
    let all: [DailyJob] = [
        DailyJob(key: "finish", title: "Take one off the tree",
                 detail: "Finish a bow today, whatever it weighs.",
                 reward: 70, done: { $0.dBows >= 1 }, progress: { min(1, Double($0.dBows)) }),
        DailyJob(key: "clean", title: "A clean tiller",
                 detail: "Finish a bow graded sound or better.",
                 reward: 110, done: { $0.dBestGrade >= 0.70 },
                 progress: { min(1, $0.dBestGrade / 0.70) }),
        DailyJob(key: "arrows", title: "Twelve arrows",
                 detail: "Loose two ends at the butts.",
                 reward: 60, done: { $0.dArrows >= 12 }, progress: { min(1, Double($0.dArrows) / 12) }),
        DailyJob(key: "end", title: "Thirty on an end",
                 detail: "Score thirty or better with six arrows.",
                 reward: 90, done: { $0.dBestEnd >= 30 }, progress: { min(1, Double($0.dBestEnd) / 30) }),
        DailyJob(key: "read", title: "Two pages of the book",
                 detail: "Read two entries from the craft section.",
                 reward: 45, done: { $0.dReads >= 2 }, progress: { min(1, Double($0.dReads) / 2) }),
        DailyJob(key: "whole", title: "Break nothing",
                 detail: "Finish a bow today without splitting a stave.",
                 reward: 85, done: { $0.dBows >= 1 && $0.dBroken == 0 },
                 progress: { $0.dBroken > 0 ? 0 : min(1, Double($0.dBows)) }),
    ]
    return seed.pick(all, 3)
}

struct TodayView: View {
    @EnvironmentObject var store: TillerStore
    @Binding var pending: String?
    @Binding var tab: Int
    @State private var now = Date()

    private var seed: DaySeed { DaySeed(now) }
    private var stave: BowEntry { seed.pick(bowLibrary, 11) }
    private var guide: GuideEntry { seed.pick(guideLibrary, 23) }
    private var job: DailyJob { jobsFor(seed) }
    private var hour: Int { Calendar.current.component(.hour, from: now) }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 14) {
                    ShopScene(hour: hour, seed: seed.value)
                        .frame(height: 240)
                        .overlay(Rectangle().stroke(Bark.ink.opacity(0.18), lineWidth: 1))
                    header
                    jobCard
                    staveCard
                    guideCard
                    rankCard
                }
                .padding(14)
            }
            .background(Bark.paper.ignoresSafeArea())
            .navigationBarTitle("The Shop", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear { now = Date(); store.touchDay() }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(shopWord(hour)).font(Bark.serifBold(19)).foregroundColor(Bark.ink)
                Text(shortDate(now)).font(Bark.serif(13)).foregroundColor(Bark.inkPale)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                SmallCap(text: "Days running")
                Text("\(store.save.streak)").font(Bark.serifBold(24)).foregroundColor(Bark.ink)
            }
        }
        .padding(12)
        .background(Paperboard())
    }

    private var jobCard: some View {
        let done = job.done(store.save)
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                SmallCap(text: "Today's work")
                Spacer()
                if done {
                    HStack(spacing: 5) {
                        StrokeGlyph(shape: GlyphMark(), tone: Bark.moss, width: 2.0)
                            .frame(width: 14, height: 14)
                        SmallCap(text: "done", tone: Bark.moss)
                    }
                } else {
                    SmallCap(text: "\(job.reward) xp")
                }
            }
            RuleLine()
            Text(job.title).font(Bark.serifBold(17)).foregroundColor(Bark.ink)
            Text(job.detail).font(Bark.serif(14)).foregroundColor(Bark.inkSoft)
            MeterBar(label: "Progress", value: job.progress(store.save),
                     tone: done ? Bark.moss : Bark.oak)
        }
        .padding(12)
        .background(Paperboard())
        .onAppear {
            if job.done(store.save) {
                store.finishJob(dayKey(now), reward: job.reward)
            }
        }
    }

    private var staveCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            SmallCap(text: "On the bench today")
            RuleLine()
            HStack(spacing: 12) {
                PlateBand(name: stave.plate, focusY: 0.42, zoom: 1.5, maxDim: 520)
                    .frame(width: 70, height: 92)
                    .overlay(Rectangle().stroke(Bark.ink.opacity(0.20), lineWidth: 1))
                VStack(alignment: .leading, spacing: 3) {
                    Text(stave.name).font(Bark.serifBold(16)).foregroundColor(Bark.ink)
                    Text(stave.timber).font(Bark.serifItalic(13)).foregroundColor(Bark.inkPale)
                    Text("\(stave.weight) lb at \(stave.draw)\"").font(Bark.serif(13))
                        .foregroundColor(Bark.inkSoft)
                }
                Spacer()
            }
            WoodButton(title: "Split this stave") {
                pending = stave.slug
                tab = 1
            }
        }
        .padding(12)
        .background(Paperboard())
    }

    private var guideCard: some View {
        NavigationLink(destination: GuidePage(guide: guide)) {
            VStack(alignment: .leading, spacing: 8) {
                SmallCap(text: "Page of the day")
                RuleLine()
                Text(guide.title).font(Bark.serifBold(16)).foregroundColor(Bark.ink)
                Text(guide.lead).font(Bark.serifItalic(14)).foregroundColor(Bark.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(12)
            .background(Paperboard())
        }
        .buttonStyle(.plain)
    }

    private var rankCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                SmallCap(text: "Standing")
                Spacer()
                Text(BowyerRank.name(store.save.xp)).font(Bark.serifBold(15))
                    .foregroundColor(Bark.walnut)
            }
            RuleLine()
            MeterBar(label: "\(store.save.xp) xp", value: BowyerRank.progress(store.save.xp),
                     tone: Bark.walnut)
            if let next = BowyerRank.nextAt(store.save.xp) {
                Text("\(next - store.save.xp) more to \(BowyerRank.names[min(BowyerRank.level(store.save.xp) + 1, BowyerRank.names.count - 1)])")
                    .font(Bark.serif(12)).foregroundColor(Bark.inkPale)
            } else {
                Text("Nothing left to prove but the next stave.")
                    .font(Bark.serifItalic(12)).foregroundColor(Bark.inkPale)
            }
            HStack(spacing: 16) {
                VStack(spacing: 2) {
                    Text("\(store.save.bows.count)").font(Bark.serifBold(18)).foregroundColor(Bark.ink)
                    SmallCap(text: "bows", size: 10)
                }
                VStack(spacing: 2) {
                    Text("\(store.save.seenBows.count)/\(bowLibrary.count)")
                        .font(Bark.serifBold(18)).foregroundColor(Bark.ink)
                    SmallCap(text: "patterns", size: 10)
                }
                VStack(spacing: 2) {
                    Text("\(store.save.readGuides.count)/\(guideLibrary.count)")
                        .font(Bark.serifBold(18)).foregroundColor(Bark.ink)
                    SmallCap(text: "pages", size: 10)
                }
                VStack(spacing: 2) {
                    Text("\(store.save.shotsFired)").font(Bark.serifBold(18)).foregroundColor(Bark.ink)
                    SmallCap(text: "arrows", size: 10)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(12)
        .background(Paperboard())
    }

    private func shopWord(_ h: Int) -> String {
        switch h {
        case 5..<8: return "First light in the shop"
        case 8..<12: return "Morning at the bench"
        case 12..<14: return "Middle of the day"
        case 14..<18: return "Afternoon light"
        case 18..<21: return "Evening, lamp lit"
        case 21..<24: return "Late, and quiet"
        default: return "Before anyone is up"
        }
    }
}

struct ShopScene: View {
    let hour: Int
    let seed: UInt64

    var body: some View {
        Canvas { ctx, size in
            draw(&ctx, size)
        }
    }

    private func skyTones(_ h: Int) -> (Color, Color, Double) {
        switch h {
        case 5..<8: return (Color(red: 0.855, green: 0.741, blue: 0.588), Color(red: 0.949, green: 0.878, blue: 0.741), 0.55)
        case 8..<12: return (Color(red: 0.898, green: 0.898, blue: 0.855), Color(red: 0.976, green: 0.965, blue: 0.918), 0.90)
        case 12..<15: return (Color(red: 0.925, green: 0.925, blue: 0.886), Color(red: 0.988, green: 0.980, blue: 0.941), 1.00)
        case 15..<18: return (Color(red: 0.902, green: 0.835, blue: 0.706), Color(red: 0.965, green: 0.918, blue: 0.804), 0.78)
        case 18..<21: return (Color(red: 0.596, green: 0.510, blue: 0.435), Color(red: 0.812, green: 0.706, blue: 0.545), 0.40)
        case 21..<24: return (Color(red: 0.239, green: 0.243, blue: 0.294), Color(red: 0.365, green: 0.353, blue: 0.376), 0.16)
        default: return (Color(red: 0.180, green: 0.184, blue: 0.227), Color(red: 0.278, green: 0.278, blue: 0.318), 0.12)
        }
    }

    private func draw(_ ctx: inout GraphicsContext, _ size: CGSize) {
        let w = size.width, h = size.height
        let (sky, glow, day) = skyTones(hour)
        var rng = Seeded(seed &+ 5)

        ctx.fill(Path(CGRect(origin: .zero, size: size)),
                 with: .color(Bark.walnutDark.opacity(0.92 - day * 0.28)))

        let planks = 9
        for k in 0..<planks {
            let x = w * CGFloat(k) / CGFloat(planks)
            let tone = Bark.walnut.opacity(0.30 + rng.d() * 0.24)
            ctx.fill(Path(CGRect(x: x, y: 0, width: w / CGFloat(planks) + 1, height: h)), with: .color(tone))
            var line = Path()
            line.move(to: CGPoint(x: x, y: 0))
            line.addLine(to: CGPoint(x: x, y: h))
            ctx.stroke(line, with: .color(Bark.night.opacity(0.35)), lineWidth: 1)
        }

        let wx = w * 0.06, wy = h * 0.10, ww = w * 0.34, wh = h * 0.46
        ctx.fill(Path(CGRect(x: wx, y: wy, width: ww, height: wh)), with: .color(sky))
        ctx.fill(Path(CGRect(x: wx, y: wy, width: ww, height: wh * 0.45)), with: .color(glow.opacity(0.75)))
        var bars = Path()
        bars.move(to: CGPoint(x: wx + ww / 2, y: wy))
        bars.addLine(to: CGPoint(x: wx + ww / 2, y: wy + wh))
        bars.move(to: CGPoint(x: wx, y: wy + wh / 2))
        bars.addLine(to: CGPoint(x: wx + ww, y: wy + wh / 2))
        ctx.stroke(bars, with: .color(Bark.night.opacity(0.55)), lineWidth: 3)
        ctx.stroke(Path(CGRect(x: wx, y: wy, width: ww, height: wh)),
                   with: .color(Bark.night.opacity(0.7)), lineWidth: 3)

        var shaft = Path()
        shaft.move(to: CGPoint(x: wx + ww, y: wy))
        shaft.addLine(to: CGPoint(x: w, y: wy + wh * 0.6))
        shaft.addLine(to: CGPoint(x: w, y: h))
        shaft.addLine(to: CGPoint(x: wx + ww * 0.5, y: h))
        shaft.closeSubpath()
        ctx.fill(shaft, with: .color(glow.opacity(0.10 + day * 0.16)))

        let px = w * 0.72
        ctx.fill(Path(CGRect(x: px - 9, y: 0, width: 18, height: h)), with: .color(Bark.oak))
        ctx.stroke(Path(CGRect(x: px - 9, y: 0, width: 18, height: h)),
                   with: .color(Bark.night.opacity(0.6)), lineWidth: 1.5)
        for k in 0..<7 {
            var n = Path()
            let y = h * 0.34 + CGFloat(k) * h * 0.08
            n.move(to: CGPoint(x: px + 9, y: y))
            n.addLine(to: CGPoint(x: px + 20, y: y - 4))
            ctx.stroke(n, with: .color(Bark.night.opacity(0.55)), lineWidth: 1.4)
        }
        let tipY = h * 0.30
        var bow = Path()
        bow.move(to: CGPoint(x: px - w * 0.23, y: tipY))
        bow.addCurve(to: CGPoint(x: px + w * 0.23, y: tipY),
                     control1: CGPoint(x: px - w * 0.11, y: h * 0.13),
                     control2: CGPoint(x: px + w * 0.11, y: h * 0.13))
        ctx.stroke(bow, with: .color(Bark.night.opacity(0.45)), style: StrokeStyle(lineWidth: 9, lineCap: .round))
        ctx.stroke(bow, with: .color(Bark.yewHeart), style: StrokeStyle(lineWidth: 6.5, lineCap: .round))
        ctx.stroke(bow, with: .color(Bark.yewSap.opacity(0.8)), style: StrokeStyle(lineWidth: 2.2, lineCap: .round))
        var str = Path()
        str.move(to: CGPoint(x: px - w * 0.23, y: tipY))
        str.addLine(to: CGPoint(x: px + w * 0.23, y: tipY))
        ctx.stroke(str, with: .color(Bark.hemp.opacity(0.95)), lineWidth: 1.8)
        ctx.stroke(str, with: .color(Bark.night.opacity(0.25)), lineWidth: 0.7)

        let by = h * 0.74
        ctx.fill(Path(CGRect(x: 0, y: by, width: w, height: h - by)), with: .color(Bark.oakDark))
        ctx.fill(Path(CGRect(x: 0, y: by, width: w, height: 10)), with: .color(Bark.oakPale.opacity(0.65)))
        for _ in 0..<34 {
            let x = rng.d() * Double(w)
            let y = Double(by) + 10 + rng.d() * Double(h - by - 12)
            let len = 7 + rng.d() * 12
            var curl = Path()
            curl.move(to: CGPoint(x: x, y: y))
            curl.addQuadCurve(to: CGPoint(x: x + len, y: y + 1.5),
                              control: CGPoint(x: x + len * 0.5, y: y - 4.5 - rng.d() * 3))
            curl.addQuadCurve(to: CGPoint(x: x + len * 0.3, y: y + 4),
                              control: CGPoint(x: x + len * 0.75, y: y + 5))
            ctx.stroke(curl, with: .color(Bark.pineTone.opacity(0.45 + rng.d() * 0.35)), lineWidth: 1.3)
        }

        if day < 0.5 {
            let lx = w * 0.20, ly = h * 0.16
            for k in stride(from: 8, through: 1, by: -1) {
                let rad = CGFloat(k) * 14
                ctx.fill(Path(ellipseIn: CGRect(x: lx - rad, y: ly - rad, width: rad * 2, height: rad * 2)),
                         with: .color(Bark.lamp.opacity(0.045)))
            }
            var lamp = Path()
            lamp.move(to: CGPoint(x: lx - 12, y: ly + 12))
            lamp.addLine(to: CGPoint(x: lx - 6, y: ly - 10))
            lamp.addLine(to: CGPoint(x: lx + 6, y: ly - 10))
            lamp.addLine(to: CGPoint(x: lx + 12, y: ly + 12))
            lamp.closeSubpath()
            ctx.fill(lamp, with: .color(Bark.lamp.opacity(0.9)))
            ctx.stroke(lamp, with: .color(Bark.night.opacity(0.7)), lineWidth: 1.4)
        }
    }
}
