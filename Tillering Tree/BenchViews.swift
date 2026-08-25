import SwiftUI

struct BenchView: View {
    @EnvironmentObject var store: TillerStore
    @Binding var pending: String?
    @State private var session: MakeSession? = nil

    var body: some View {
        NavigationView {
            Group {
                if let s = session {
                    MakeFlow(session: s, onClose: { session = nil })
                } else {
                    StavePicker(onPick: { entry in
                        session = MakeSession(entry: entry,
                                              seed: hashString(entry.slug + dayKey(Date())),
                                              kit: store.kit)
                    })
                }
            }
            .navigationBarTitle("The Bench", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            if let p = pending {
                session = MakeSession(entry: bowBySlug(p),
                                      seed: hashString(p + dayKey(Date())),
                                      kit: store.kit)
                pending = nil
            }
        }
    }
}

struct StavePicker: View {
    @EnvironmentObject var store: TillerStore
    let onPick: (BowEntry) -> Void
    @State private var filter = 0

    private var shown: [BowEntry] {
        switch filter {
        case 1: return bowLibrary.filter { $0.difficulty <= 2 }
        case 2: return bowLibrary.filter { $0.difficulty == 3 }
        case 3: return bowLibrary.filter { $0.difficulty >= 4 }
        default: return bowLibrary
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                if !store.save.taken.isEmpty {
                    VStack(alignment: .leading, spacing: 7) {
                        SmallCap(text: "Work waiting on you")
                        RuleLine()
                        ForEach(store.save.taken) { c in
                            VStack(alignment: .leading, spacing: 3) {
                                Text(clientBySlug(c.client).name + " \u{2014} " + c.title)
                                    .font(Bark.serifBold(14)).foregroundColor(Bark.ink)
                                Text(c.demands.joined(separator: "  \u{00B7}  "))
                                    .font(Bark.serif(12)).foregroundColor(Bark.inkPale)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(12)
                    .background(Paperboard())
                }
                Text("Pick a stave and a pattern to work to.")
                    .font(Bark.serifItalic(15)).foregroundColor(Bark.inkSoft)
                    .padding(.top, 10)
                HStack(spacing: 6) {
                    ForEach(0..<4, id: \.self) { i in
                        Button(action: { filter = i }) {
                            Text(["All", "Easy", "Middling", "Hard"][i].uppercased())
                                .font(Bark.serif(11)).tracking(1.6)
                                .foregroundColor(filter == i ? Bark.paperWarm : Bark.inkSoft)
                                .padding(.vertical, 7).frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 3)
                                    .fill(filter == i ? Bark.walnut : Bark.paperWarm))
                                .overlay(RoundedRectangle(cornerRadius: 3)
                                    .stroke(Bark.ink.opacity(0.24), lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                    }
                }
                ForEach(shown) { e in
                    Button(action: { onPick(e) }) { StaveRow(entry: e) }
                        .buttonStyle(.plain)
                }
            }
            .padding(14)
        }
        .background(Bark.paper.ignoresSafeArea())
    }
}

struct StaveRow: View {
    @EnvironmentObject var store: TillerStore
    let entry: BowEntry

    private var built: Int { store.save.bows.filter { $0.slug == entry.slug }.count }

    var body: some View {
        HStack(spacing: 12) {
            PlateBand(name: entry.plate, focusY: 0.42, zoom: 1.5, maxDim: 520)
                .frame(width: 74, height: 96)
                .overlay(Rectangle().stroke(Bark.ink.opacity(0.20), lineWidth: 1))
            VStack(alignment: .leading, spacing: 3) {
                Text(entry.name).font(Bark.serifBold(17)).foregroundColor(Bark.ink)
                Text("\(entry.place)  ·  \(entry.era)").font(Bark.serif(13)).foregroundColor(Bark.inkPale)
                Text(entry.timber).font(Bark.serifItalic(13)).foregroundColor(Bark.inkSoft)
                HStack(spacing: 8) {
                    SmallCap(text: "\(entry.weight) lb")
                    SmallCap(text: "\(entry.draw)\"")
                    SmallCap(text: "\(entry.inches) in")
                    HStack(spacing: 2) {
                        ForEach(0..<5, id: \.self) { i in
                            Rectangle()
                                .fill(i < entry.difficulty ? Bark.oxblood.opacity(0.75) : Bark.ink.opacity(0.14))
                                .frame(width: 6, height: 6)
                        }
                    }
                }
                if built > 0 {
                    SmallCap(text: "made \(built)", tone: Bark.moss)
                }
            }
            Spacer()
            StrokeGlyph(shape: GlyphArrowRight(), tone: Bark.inkPale, width: 1.4)
                .frame(width: 18, height: 18)
        }
        .padding(10)
        .background(Paperboard())
    }
}

struct MakeFlow: View {
    @EnvironmentObject var store: TillerStore
    @ObservedObject var session: MakeSession
    let onClose: () -> Void
    @State private var recorded = false

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                header
                if session.failed {
                    BrokenPanel(session: session, onClose: onClose)
                } else if session.finishedID != nil {
                    FinishPanel(session: session, recorded: $recorded, onClose: onClose)
                } else {
                    switch session.stage {
                    case .stave: StaveStageView(session: session)
                    case .rough: RoughStageView(session: session)
                    case .tiller: TillerStageView(session: session)
                    case .brace: BraceStageView(session: session)
                    case .shoot: ShootStageView(session: session)
                    }
                }
                QuietButton(title: "Leave the bench") { onClose() }
                    .padding(.top, 6)
            }
            .padding(14)
        }
        .background(Bark.paper.ignoresSafeArea())
    }

    private var header: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(session.entry.name).font(Bark.serifBold(19)).foregroundColor(Bark.ink)
                    Text(session.entry.timber).font(Bark.serifItalic(13)).foregroundColor(Bark.inkPale)
                }
                Spacer()
                SmallCap(text: "Step \(session.stage.order) of 5")
            }
            HStack(spacing: 4) {
                ForEach(BenchStage.allCases, id: \.rawValue) { st in
                    Rectangle()
                        .fill(st.rawValue <= session.stage.rawValue ? Bark.walnut : Bark.ink.opacity(0.14))
                        .frame(height: 4)
                }
            }
            RuleLine()
            HStack {
                Text(session.stage.title.uppercased())
                    .font(Bark.serifBold(13)).tracking(2.4).foregroundColor(Bark.ink)
                Spacer()
            }
            Text(session.stage.lead).font(Bark.serifItalic(14)).foregroundColor(Bark.inkSoft)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(Paperboard())
    }
}

struct BrokenPanel: View {
    @EnvironmentObject var store: TillerStore
    @ObservedObject var session: MakeSession
    let onClose: () -> Void
    @State private var logged = false

    var body: some View {
        VStack(spacing: 12) {
            PlateView(name: "guide-hinge", maxDim: 900)
                .frame(height: 210)
                .overlay(Rectangle().stroke(Bark.ink.opacity(0.18), lineWidth: 1))
            Text("The stave is finished.").font(Bark.serifBold(20)).foregroundColor(Bark.oxblood)
            Text(session.message ?? "A limb let go.")
                .font(Bark.serif(15)).foregroundColor(Bark.inkSoft)
                .multilineTextAlignment(.center)
            Text("Every bowyer breaks staves. The wood only remembers strain, never intentions.")
                .font(Bark.serifItalic(14)).foregroundColor(Bark.inkPale)
                .multilineTextAlignment(.center)
            WoodButton(title: "Split another stave") { onClose() }
        }
        .padding(12)
        .background(Paperboard())
        .onAppear {
            if !logged { store.markBroken(); store.award(24); logged = true }
        }
    }
}

struct FinishPanel: View {
    @EnvironmentObject var store: TillerStore
    @ObservedObject var session: MakeSession
    @Binding var recorded: Bool
    let onClose: () -> Void
    @State private var filled: Commission? = nil
    @State private var madeBow: FinishedBow? = nil

    var body: some View {
        VStack(spacing: 12) {
            Text("Finished").font(Bark.serifBold(22)).foregroundColor(Bark.ink)
            Text(gradeWord(session.overall)).font(Bark.serifItalic(17)).foregroundColor(Bark.moss)
            PlateBand(name: session.entry.plate, focusY: 0.42, zoom: 1.05, maxDim: 900)
                .frame(height: 190)
                .overlay(Rectangle().stroke(Bark.ink.opacity(0.18), lineWidth: 1))
            VStack(spacing: 7) {
                StatRow(label: "Draw weight", value: "\(Int(session.reading.pounds.rounded())) lb at \(session.entry.draw)\"")
                StatRow(label: "Wanted", value: "\(session.entry.weight) lb")
                StatRow(label: "String follow", value: String(format: "%.1f in", session.followInches))
                StatRow(label: "Tiller", value: String(format: "%.0f%%", session.reading.evenness * 100))
                StatRow(label: "Balance", value: String(format: "%.0f%%", session.reading.balance * 100))
                StatRow(label: "Cast", value: String(format: "%.0f%%", session.castScore * 100))
                StatRow(label: "Scrapes", value: "\(session.scrapesUsed)")
            }
            .padding(10)
            .background(Paperboard())
            if let f = filled {
                VStack(spacing: 7) {
                    SmallCap(text: "Commission filled", tone: Bark.moss)
                    Text(clientBySlug(f.client).name).font(Bark.serifBold(17)).foregroundColor(Bark.ink)
                    Text("Paid \(f.pay). Standing with them is up \(f.rep).")
                        .font(Bark.serif(14)).foregroundColor(Bark.inkSoft)
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 4).fill(Bark.moss.opacity(0.14))
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Bark.moss.opacity(0.5), lineWidth: 1)))
            } else if let bow = madeBow, !store.save.taken.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    SmallCap(text: "Not what anyone ordered")
                    RuleLine()
                    ForEach(store.save.taken) { c in
                        if let why = missedBy(c, bow: bow) {
                            Text(clientBySlug(c.client).name + ": " + why)
                                .font(Bark.serif(13)).foregroundColor(Bark.inkSoft)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(Paperboard())
            }
            WoodButton(title: "Back to the bench") { onClose() }
        }
        .padding(12)
        .background(Paperboard())
        .onAppear {
            guard !recorded, let id = session.finishedID else { return }
            recorded = true
            let bow = FinishedBow(id: id, slug: session.entry.slug, made: Date(),
                                  pounds: session.reading.pounds, drawTo: session.entry.draw,
                                  follow: session.followInches, evenness: session.reading.evenness,
                                  balance: session.reading.balance, grade: session.overall,
                                  shots: 0, best: 0, cast: session.castScore)
            madeBow = bow
            filled = store.record(bow)
        }
    }
}

struct StatRow: View {
    let label: String
    let value: String
    var body: some View {
        HStack {
            Text(label).font(Bark.serif(14)).foregroundColor(Bark.inkSoft)
            Spacer()
            Text(value).font(Bark.serifBold(14)).foregroundColor(Bark.ink)
        }
    }
}
