import SwiftUI

struct RackView: View {
    @EnvironmentObject var store: TillerStore

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 14) {
                    if store.save.bows.isEmpty {
                        EmptyRack()
                    } else {
                        RackSummary()
                        ForEach(store.save.bows) { b in
                            NavigationLink(destination: BowSheet(bow: b)) {
                                RackRow(bow: b)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(14)
            }
            .background(Bark.paper.ignoresSafeArea())
            .navigationBarTitle("The Rack", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct EmptyRack: View {
    var body: some View {
        VStack(spacing: 12) {
            StrokeGlyph(shape: GlyphPost(), tone: Bark.inkPale, width: 1.4)
                .frame(width: 64, height: 64)
            Text("Nothing on the rack yet.").font(Bark.serifBold(17)).foregroundColor(Bark.inkSoft)
            Text("Split a stave at the bench and work it through to the first arrow. Whatever comes off the tiller ends up here, faults and all.")
                .font(Bark.serif(14)).foregroundColor(Bark.inkPale)
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .background(Paperboard())
    }
}

struct RackSummary: View {
    @EnvironmentObject var store: TillerStore

    private var best: FinishedBow? { store.save.bows.max { $0.grade < $1.grade } }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    SmallCap(text: "Bows finished")
                    Text("\(store.save.bows.count)").font(Bark.serifBold(24)).foregroundColor(Bark.ink)
                }
                Spacer()
                VStack(alignment: .center, spacing: 2) {
                    SmallCap(text: "Staves broken")
                    Text("\(store.save.broken)").font(Bark.serifBold(24)).foregroundColor(Bark.oxblood)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    SmallCap(text: "Arrows loosed")
                    Text("\(store.save.shotsFired)").font(Bark.serifBold(24)).foregroundColor(Bark.ink)
                }
            }
            if let b = best {
                RuleLine()
                HStack {
                    Text("Best work: \(bowBySlug(b.slug).name)")
                        .font(Bark.serifItalic(14)).foregroundColor(Bark.inkSoft)
                    Spacer()
                    Text(gradeWord(b.grade)).font(Bark.serifBold(14)).foregroundColor(Bark.moss)
                }
            }
        }
        .padding(12)
        .background(Paperboard())
    }
}

struct RackRow: View {
    let bow: FinishedBow
    private var entry: BowEntry { bowBySlug(bow.slug) }

    var body: some View {
        HStack(spacing: 12) {
            PlateBand(name: entry.plate, focusY: 0.42, zoom: 1.5, maxDim: 520)
                .frame(width: 62, height: 84)
                .overlay(Rectangle().stroke(Bark.ink.opacity(0.20), lineWidth: 1))
            VStack(alignment: .leading, spacing: 3) {
                Text(entry.name).font(Bark.serifBold(16)).foregroundColor(Bark.ink)
                Text("\(Int(bow.pounds.rounded())) lb at \(bow.drawTo)\"  ·  \(String(format: "%.1f in follow", bow.follow))")
                    .font(Bark.serif(13)).foregroundColor(Bark.inkSoft)
                HStack(spacing: 8) {
                    SmallCap(text: gradeWord(bow.grade), tone: Bark.moss)
                    SmallCap(text: shortDate(bow.made))
                    if bow.shots > 0 { SmallCap(text: "\(bow.shots) arrows") }
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

struct BowSheet: View {
    @EnvironmentObject var store: TillerStore
    let bow: FinishedBow
    private var entry: BowEntry { bowBySlug(bow.slug) }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                PlateView(name: entry.plate, maxDim: 1200)
                    .frame(height: 380)
                    .overlay(Rectangle().stroke(Bark.ink.opacity(0.18), lineWidth: 1))
                VStack(spacing: 7) {
                    StatRow(label: "Pattern", value: entry.name)
                    StatRow(label: "Timber", value: entry.timber)
                    StatRow(label: "Draw weight", value: "\(Int(bow.pounds.rounded())) lb at \(bow.drawTo)\"")
                    StatRow(label: "String follow", value: String(format: "%.1f in", bow.follow))
                    StatRow(label: "Tiller", value: String(format: "%.0f%%", bow.evenness * 100))
                    StatRow(label: "Balance", value: String(format: "%.0f%%", bow.balance * 100))
                    StatRow(label: "Cast", value: String(format: "%.0f%%", bow.cast * 100))
                    StatRow(label: "Arrows", value: "\(bow.shots)")
                    StatRow(label: "Best end", value: bow.best > 0 ? "\(bow.best)" : "not shot yet")
                }
                .padding(12)
                .background(Paperboard())
                Text(entry.line).font(Bark.serifItalic(15)).foregroundColor(Bark.inkSoft)
                    .multilineTextAlignment(.center)
                NavigationLink(destination: RangeShootView(bow: bow)) {
                    Text("TAKE IT TO THE BUTTS")
                        .font(Bark.serifBold(13)).tracking(2.0).foregroundColor(Bark.paperWarm)
                        .frame(maxWidth: .infinity).padding(.vertical, 13)
                        .background(RoundedRectangle(cornerRadius: 3).fill(Bark.walnut))
                }
                .buttonStyle(.plain)
            }
            .padding(14)
        }
        .background(Bark.paper.ignoresSafeArea())
        .navigationBarTitle(entry.name, displayMode: .inline)
    }
}
