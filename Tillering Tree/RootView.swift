import SwiftUI

struct RootView: View {
    @StateObject private var store = TillerStore()
    @State private var tab = 0
    @State private var pending: String? = nil
    @Environment(\.scenePhase) private var phase

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch tab {
                case 0: TodayView(pending: $pending, tab: $tab)
                case 1: BenchView(pending: $pending)
                case 2: RackView()
                case 3: RangeView()
                default: BookView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            ShopTabBar(tab: $tab)
        }
        .environmentObject(store)
        .background(Bark.paper.ignoresSafeArea())
        .onChange(of: phase) { p in
            if p != .active { store.persist() }
            if p == .active { store.touchDay() }
        }
    }


}

struct ShopTabBar: View {
    @Binding var tab: Int

    var body: some View {
        HStack(spacing: 0) {
            item(0, "Shop") { AnyView(StrokeGlyph(shape: GlyphLamp(), tone: tone(0), width: 1.5)) }
            item(1, "Bench") { AnyView(StrokeGlyph(shape: GlyphKnife(), tone: tone(1), width: 1.5)) }
            item(2, "Rack") { AnyView(StrokeGlyph(shape: GlyphBow(bend: 0.24), tone: tone(2), width: 1.7)) }
            item(3, "Butts") { AnyView(StrokeGlyph(shape: GlyphTarget(), tone: tone(3), width: 1.4)) }
            item(4, "Book") { AnyView(StrokeGlyph(shape: GlyphBook(), tone: tone(4), width: 1.5)) }
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
        .background(
            Bark.linen
                .overlay(Rectangle().fill(Bark.ink.opacity(0.16)).frame(height: 1), alignment: .top)
                .ignoresSafeArea(edges: .bottom)
        )
    }

    private func tone(_ i: Int) -> Color { tab == i ? Bark.walnutDark : Bark.inkPale.opacity(0.75) }

    private func item(_ i: Int, _ label: String, glyph: @escaping () -> AnyView) -> some View {
        Button(action: { tab = i }) {
            VStack(spacing: 4) {
                glyph().frame(width: 24, height: 24)
                Text(label.uppercased()).font(Bark.serif(9)).tracking(1.4).foregroundColor(tone(i))
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
