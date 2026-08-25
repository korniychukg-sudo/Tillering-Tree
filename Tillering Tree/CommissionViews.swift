import SwiftUI

struct CommissionCard: View {
    let commission: Commission
    let now: Date
    let taken: Bool

    private var left: Int { commission.daysLeft(now) }
    private var urgent: Bool { left <= 2 }

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(commission.title).font(Bark.serifBold(16)).foregroundColor(Bark.ink)
                    Text(clientBySlug(commission.client).name)
                        .font(Bark.serifItalic(13)).foregroundColor(Bark.inkPale)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(commission.pay)").font(Bark.serifBold(19)).foregroundColor(Bark.walnut)
                    SmallCap(text: left == 0 ? "today" : (left == 1 ? "1 day" : "\(left) days"),
                             tone: urgent ? Bark.oxblood : Bark.inkPale, size: 10)
                }
            }
            RuleLine()
            ForEach(Array(commission.demands.enumerated()), id: \.offset) { _, d in
                HStack(spacing: 6) {
                    Rectangle().fill(Bark.oak.opacity(0.55)).frame(width: 4, height: 4)
                    Text(d).font(Bark.serif(13)).foregroundColor(Bark.inkSoft)
                }
            }
            if taken {
                HStack(spacing: 6) {
                    StrokeGlyph(shape: GlyphMark(), tone: Bark.moss, width: 1.8)
                        .frame(width: 12, height: 12)
                    SmallCap(text: "taken", tone: Bark.moss, size: 10)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(taken ? Bark.linen : Bark.card)
                .overlay(RoundedRectangle(cornerRadius: 4)
                    .stroke(urgent && taken ? Bark.oxblood.opacity(0.5) : Bark.ink.opacity(0.16),
                            lineWidth: urgent && taken ? 1.6 : 1))
        )
    }
}

struct CommissionPage: View {
    @EnvironmentObject var store: TillerStore
    @Environment(\.presentationMode) var presentation
    let commission: Commission
    let taken: Bool
    @Binding var pending: String?
    @Binding var tab: Int

    private var client: Client { clientBySlug(commission.client) }
    private var rep: Int { store.save.clientRep[commission.client] ?? 0 }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(client.name).font(Bark.serifBold(20)).foregroundColor(Bark.ink)
                    Text(client.trade.uppercased()).font(Bark.serif(11)).tracking(2.2)
                        .foregroundColor(Bark.inkPale)
                    RuleLine()
                    Text(client.temper).font(Bark.serifItalic(15)).foregroundColor(Bark.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                    MeterBar(label: "Standing with them", value: min(1, Double(rep) / 60), tone: Bark.walnut)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(Paperboard())

                VStack(alignment: .leading, spacing: 8) {
                    Text(commission.title).font(Bark.serifBold(18)).foregroundColor(Bark.ink)
                    Text("\u{201C}" + commission.line + "\u{201D}")
                        .font(Bark.serif(15)).foregroundColor(Bark.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                    RuleLine()
                    ForEach(Array(commission.demands.enumerated()), id: \.offset) { _, d in
                        HStack(spacing: 8) {
                            Rectangle().fill(Bark.oak).frame(width: 5, height: 5)
                            Text(d).font(Bark.serifBold(14)).foregroundColor(Bark.ink)
                        }
                    }
                    RuleLine()
                    HStack {
                        StatRow(label: "Pays", value: "\(commission.pay)")
                    }
                    StatRow(label: "Due in", value: commission.daysLeft(Date()) == 1 ? "1 day"
                                : "\(commission.daysLeft(Date())) days")
                    StatRow(label: "Standing", value: "+\(commission.rep) if you fill it")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(Paperboard())

                if let p = commission.pattern {
                    NavigationLink(destination: BowPage(entry: bowBySlug(p))) {
                        HStack(spacing: 12) {
                            PlateBand(name: bowBySlug(p).plate, focusY: 0.42, zoom: 1.5, maxDim: 520)
                                .frame(width: 62, height: 84)
                                .overlay(Rectangle().stroke(Bark.ink.opacity(0.20), lineWidth: 1))
                            VStack(alignment: .leading, spacing: 3) {
                                Text(bowBySlug(p).name).font(Bark.serifBold(15)).foregroundColor(Bark.ink)
                                Text("Read the pattern before you start")
                                    .font(Bark.serif(12)).foregroundColor(Bark.inkPale)
                            }
                            Spacer()
                            StrokeGlyph(shape: GlyphArrowRight(), tone: Bark.inkPale, width: 1.4)
                                .frame(width: 16, height: 16)
                        }
                        .padding(10)
                        .background(Paperboard())
                    }
                    .buttonStyle(.plain)
                }

                if taken {
                    WoodButton(title: "Take a stave to the bench") {
                        pending = commission.pattern
                        tab = 1
                        presentation.wrappedValue.dismiss()
                    }
                    QuietButton(title: "Give it back", tone: Bark.oxblood) {
                        store.drop(commission)
                        presentation.wrappedValue.dismiss()
                    }
                } else {
                    WoodButton(title: "Take the work") {
                        store.take(commission)
                        presentation.wrappedValue.dismiss()
                    }
                }
            }
            .padding(14)
        }
        .background(Bark.paper.ignoresSafeArea())
        .navigationBarTitle(client.name, displayMode: .inline)
    }
}

struct ToolShopView: View {
    @EnvironmentObject var store: TillerStore

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        SmallCap(text: "Purse")
                        Text("\(store.save.money)").font(Bark.serifBold(26)).foregroundColor(Bark.ink)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        SmallCap(text: "Owned")
                        Text("\(store.save.tools.count) of \(shopTools.count)")
                            .font(Bark.serifBold(18)).foregroundColor(Bark.inkSoft)
                    }
                }
                .padding(12)
                .background(Paperboard())
                Text("Every tool here changes what the bench can do, not what it looks like.")
                    .font(Bark.serifItalic(14)).foregroundColor(Bark.inkPale)
                    .multilineTextAlignment(.center)
                ForEach(shopTools) { t in
                    ToolShopRow(tool: t)
                }
            }
            .padding(14)
        }
        .background(Bark.paper.ignoresSafeArea())
        .navigationBarTitle("Tool Chest", displayMode: .inline)
    }
}

struct ToolShopRow: View {
    @EnvironmentObject var store: TillerStore
    let tool: ShopTool

    private var owned: Bool { store.save.tools.contains(tool.slug) }
    private var affordable: Bool { store.save.money >= tool.price }

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                PlateBand(name: tool.plate, focusY: 0.48, zoom: 1.25, maxDim: 460)
                    .frame(width: 66, height: 66)
                    .overlay(Rectangle().stroke(Bark.ink.opacity(0.20), lineWidth: 1))
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text(tool.name).font(Bark.serifBold(16)).foregroundColor(Bark.ink)
                        Spacer()
                        if owned {
                            SmallCap(text: "owned", tone: Bark.moss)
                        } else {
                            Text("\(tool.price)").font(Bark.serifBold(16))
                                .foregroundColor(affordable ? Bark.walnut : Bark.inkPale)
                        }
                    }
                    Text(tool.line).font(Bark.serif(12)).foregroundColor(Bark.inkPale)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            HStack(spacing: 6) {
                Rectangle().fill(Bark.moss.opacity(0.7)).frame(width: 4, height: 4)
                Text(tool.effect).font(Bark.serifBold(13))
                    .foregroundColor(owned ? Bark.moss.opacity(0.9) : Bark.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            if !owned {
                WoodButton(title: affordable ? "Buy it" : "Not enough in the purse",
                           enabled: affordable) {
                    store.buy(tool)
                }
            }
        }
        .padding(12)
        .background(Paperboard())
    }
}
