import SwiftUI

struct RangeView: View {
    @EnvironmentObject var store: TillerStore

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 14) {
                    RangeHeader()
                    if store.save.bows.isEmpty {
                        VStack(spacing: 10) {
                            StrokeGlyph(shape: GlyphTarget(), tone: Bark.inkPale, width: 1.4)
                                .frame(width: 60, height: 60)
                            Text("No bow to shoot yet.").font(Bark.serifBold(16)).foregroundColor(Bark.inkSoft)
                            Text("Finish something at the bench first. A bow you did not tiller yourself is somebody else's bow.")
                                .font(Bark.serif(14)).foregroundColor(Bark.inkPale)
                                .multilineTextAlignment(.center)
                        }
                        .padding(22)
                        .background(Paperboard())
                    } else {
                        SmallCap(text: "Choose a bow")
                        ForEach(store.save.bows) { b in
                            NavigationLink(destination: RangeShootView(bow: b)) {
                                RangeRow(bow: b)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(14)
            }
            .background(Bark.paper.ignoresSafeArea())
            .navigationBarTitle("The Butts", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct RangeHeader: View {
    @EnvironmentObject var store: TillerStore
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                SmallCap(text: "Best end of six")
                Text("\(store.save.rangeBest)").font(Bark.serifBold(26)).foregroundColor(Bark.ink)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                SmallCap(text: "Arrows loosed")
                Text("\(store.save.shotsFired)").font(Bark.serifBold(26)).foregroundColor(Bark.ink)
            }
        }
        .padding(12)
        .background(Paperboard())
    }
}

struct RangeRow: View {
    let bow: FinishedBow
    private var entry: BowEntry { bowBySlug(bow.slug) }
    var body: some View {
        HStack(spacing: 10) {
            StrokeGlyph(shape: GlyphBow(bend: CGFloat(0.16 + bow.cast * 0.24)),
                        tone: Bark.walnut, width: 2.0)
                .frame(width: 26, height: 44)
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.name).font(Bark.serifBold(15)).foregroundColor(Bark.ink)
                Text("\(Int(bow.pounds.rounded())) lb  ·  cast \(Int(bow.cast * 100))%  ·  tiller \(Int(bow.evenness * 100))%")
                    .font(Bark.serif(12)).foregroundColor(Bark.inkPale)
            }
            Spacer()
            StrokeGlyph(shape: GlyphArrowRight(), tone: Bark.inkPale, width: 1.4)
                .frame(width: 16, height: 16)
        }
        .padding(10)
        .background(Paperboard())
    }
}

struct RangeShootView: View {
    @EnvironmentObject var store: TillerStore
    let bow: FinishedBow
    @StateObject private var run: ShootRun
    @State private var logged = false

    init(bow: FinishedBow) {
        self.bow = bow
        _run = StateObject(wrappedValue: ShootRun(arrows: 6,
                                                  quality: bow.evenness * 0.6 + bow.grade * 0.4,
                                                  cast: bow.cast,
                                                  poundage: bow.pounds,
                                                  seed: hashString(bow.id) &+ UInt64(Int(Date().timeIntervalSince1970) / 60)))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                HStack {
                    Text(bowBySlug(bow.slug).name).font(Bark.serifBold(16)).foregroundColor(Bark.ink)
                    Spacer()
                    SmallCap(text: "\(Int(bow.pounds.rounded())) lb")
                }
                .padding(10)
                .background(Paperboard())
                ShootPanel(run: run, drawTo: bow.drawTo)
                if run.done {
                    VStack(spacing: 10) {
                        Text("End of six: \(run.total)").font(Bark.serifBold(20)).foregroundColor(Bark.ink)
                        Text(verdict(run.total)).font(Bark.serifItalic(14)).foregroundColor(Bark.inkSoft)
                            .multilineTextAlignment(.center)
                    }
                    .padding(12)
                    .background(Paperboard())
                    .onAppear {
                        guard !logged else { return }
                        logged = true
                        store.logShots(6, score: run.total)
                        store.updateBow(bow.id, shots: 6, best: run.total)
                        store.award(10 + run.total)
                    }
                }
            }
            .padding(14)
        }
        .background(Bark.paper.ignoresSafeArea())
        .navigationBarTitle("Six Arrows", displayMode: .inline)
    }

    private func verdict(_ n: Int) -> String {
        switch n {
        case 50...: return "A round anybody would sign for."
        case 38..<50: return "Good grouping. The bow is doing its share."
        case 26..<38: return "Respectable. Watch the loose rather than the aim."
        case 14..<26: return "Scattered. Either the tiller or the hold, and the tiller does not move."
        default: return "The boss survived. Little else did."
        }
    }
}
