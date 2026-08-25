import SwiftUI

struct BookView: View {
    @EnvironmentObject var store: TillerStore
    @State private var tab = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack(spacing: 6) {
                    ForEach(0..<3, id: \.self) { i in
                        Button(action: { tab = i }) {
                            Text(["Bows", "Craft", "Tools"][i].uppercased())
                                .font(Bark.serif(11)).tracking(1.8)
                                .foregroundColor(tab == i ? Bark.paperWarm : Bark.inkSoft)
                                .padding(.vertical, 7).frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 3)
                                    .fill(tab == i ? Bark.walnut : Bark.paperWarm))
                                .overlay(RoundedRectangle(cornerRadius: 3)
                                    .stroke(Bark.ink.opacity(0.24), lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 14).padding(.vertical, 10)
                .background(Bark.paper)
                ScrollView {
                    VStack(spacing: 12) {
                        if tab == 0 {
                            ForEach(bowLibrary) { e in
                                NavigationLink(destination: BowPage(entry: e)) { BookRow(entry: e) }
                                    .buttonStyle(.plain)
                            }
                        } else if tab == 1 {
                            ForEach(guideLibrary) { g in
                                NavigationLink(destination: GuidePage(guide: g)) { GuideRow(guide: g) }
                                    .buttonStyle(.plain)
                            }
                        } else {
                            ForEach(toolLibrary) { t in
                                NavigationLink(destination: ToolPage(tool: t)) { ToolRow(tool: t) }
                                    .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(14)
                }
                .background(Bark.paper)
            }
            .background(Bark.paper.ignoresSafeArea())
            .navigationBarTitle("The Book", displayMode: .inline)

        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct BookRow: View {
    @EnvironmentObject var store: TillerStore
    let entry: BowEntry
    var body: some View {
        HStack(spacing: 12) {
            PlateBand(name: entry.plate, focusY: 0.40, zoom: 1.4, maxDim: 520)
                .frame(width: 66, height: 90)
                .overlay(Rectangle().stroke(Bark.ink.opacity(0.20), lineWidth: 1))
            VStack(alignment: .leading, spacing: 3) {
                Text(entry.name).font(Bark.serifBold(16)).foregroundColor(Bark.ink)
                Text("\(entry.place)  ·  \(entry.era)").font(Bark.serif(12)).foregroundColor(Bark.inkPale)
                Text(entry.timber).font(Bark.serifItalic(12)).foregroundColor(Bark.inkSoft)
                if store.save.seenBows.contains(entry.slug) {
                    SmallCap(text: "read", tone: Bark.moss)
                }
            }
            Spacer()
            StrokeGlyph(shape: GlyphArrowRight(), tone: Bark.inkPale, width: 1.4)
                .frame(width: 16, height: 16)
        }
        .padding(10)
        .background(Paperboard())
    }
}

struct GuideRow: View {
    @EnvironmentObject var store: TillerStore
    let guide: GuideEntry
    var body: some View {
        HStack(spacing: 12) {
            PlateBand(name: guide.plate, focusY: 0.42, zoom: 1.3, maxDim: 520)
                .frame(width: 66, height: 78)
                .overlay(Rectangle().stroke(Bark.ink.opacity(0.20), lineWidth: 1))
            VStack(alignment: .leading, spacing: 3) {
                Text(guide.title).font(Bark.serifBold(16)).foregroundColor(Bark.ink)
                Text(guide.lead).font(Bark.serifItalic(13)).foregroundColor(Bark.inkPale)
                    .fixedSize(horizontal: false, vertical: true)
                if store.save.readGuides.contains(guide.slug) {
                    SmallCap(text: "read", tone: Bark.moss)
                }
            }
            Spacer()
        }
        .padding(10)
        .background(Paperboard())
    }
}

struct ToolRow: View {
    let tool: ToolEntry
    var body: some View {
        HStack(spacing: 12) {
            PlateBand(name: tool.plate, focusY: 0.48, zoom: 1.2, maxDim: 520)
                .frame(width: 66, height: 66)
                .overlay(Rectangle().stroke(Bark.ink.opacity(0.20), lineWidth: 1))
            VStack(alignment: .leading, spacing: 3) {
                Text(tool.name).font(Bark.serifBold(16)).foregroundColor(Bark.ink)
                Text(tool.line).font(Bark.serif(12)).foregroundColor(Bark.inkPale)
                    .lineLimit(2).fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(10)
        .background(Paperboard())
    }
}

struct BowPage: View {
    @EnvironmentObject var store: TillerStore
    let entry: BowEntry
    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                PlateView(name: entry.plate, maxDim: 1300)
                    .frame(height: 420)
                    .overlay(Rectangle().stroke(Bark.ink.opacity(0.18), lineWidth: 1))
                Text(entry.line).font(Bark.serifItalic(16)).foregroundColor(Bark.inkSoft)
                    .multilineTextAlignment(.center)
                VStack(spacing: 7) {
                    StatRow(label: "Where", value: entry.place)
                    StatRow(label: "When", value: entry.era)
                    StatRow(label: "Timber", value: entry.timber)
                    StatRow(label: "Length", value: "\(entry.inches) in")
                    StatRow(label: "Weight", value: "\(entry.weight) lb at \(entry.draw)\"")
                    StatRow(label: "Back", value: ringWord(entry.ring))
                }
                .padding(12)
                .background(Paperboard())
                ForEach(entry.notes) { n in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(n.head.uppercased()).font(Bark.serifBold(12)).tracking(2.0)
                            .foregroundColor(Bark.ink)
                        Text(n.text).font(Bark.serif(15)).foregroundColor(Bark.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(Paperboard())
                }
            }
            .padding(14)
        }
        .background(Bark.paper.ignoresSafeArea())
        .navigationBarTitle(entry.name, displayMode: .inline)
        .onAppear { store.markSeen(entry.slug) }
    }
}

struct GuidePage: View {
    @EnvironmentObject var store: TillerStore
    let guide: GuideEntry
    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                PlateView(name: guide.plate, maxDim: 1300)
                    .frame(height: 420)
                    .overlay(Rectangle().stroke(Bark.ink.opacity(0.18), lineWidth: 1))
                Text(guide.lead).font(Bark.serifItalic(16)).foregroundColor(Bark.inkPale)
                    .multilineTextAlignment(.center)
                ForEach(Array(guide.body.enumerated()), id: \.offset) { _, para in
                    Text(para).font(Bark.serif(15)).foregroundColor(Bark.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(Paperboard())
                }
            }
            .padding(14)
        }
        .background(Bark.paper.ignoresSafeArea())
        .navigationBarTitle(guide.title, displayMode: .inline)
        .onAppear { store.markRead(guide.slug) }
    }
}

struct ToolPage: View {
    @EnvironmentObject var store: TillerStore
    let tool: ToolEntry
    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                PlateView(name: tool.plate, maxDim: 1200)
                    .frame(height: 360)
                    .overlay(Rectangle().stroke(Bark.ink.opacity(0.18), lineWidth: 1))
                Text(tool.line).font(Bark.serif(16)).foregroundColor(Bark.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(12)
                    .background(Paperboard())
            }
            .padding(14)
        }
        .background(Bark.paper.ignoresSafeArea())
        .navigationBarTitle(tool.name, displayMode: .inline)
        .onAppear { store.markTool(tool.slug) }
    }
}
