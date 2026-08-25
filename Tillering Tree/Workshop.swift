import SwiftUI

struct ShopTool: Identifiable {
    let slug: String
    let name: String
    let price: Int
    let line: String
    let effect: String
    let plate: String
    var id: String { slug }
}

let shopTools: [ShopTool] = [
    ShopTool(slug: "scale", name: "Spring Scale", price: 120,
             line: "Hangs on the string below the tree and turns an opinion into a number.",
             effect: "The draw weight reads exact instead of a guess.",
             plate: "tool-scale"),
    ShopTool(slug: "gizmo", name: "Tiller Gizmo", price: 180,
             line: "A block with a pencil through it. Run it along the limb and it finds what you cannot see.",
             effect: "Marks the laziest part of each limb while you tiller.",
             plate: "tool-gizmo"),
    ShopTool(slug: "scraper", name: "Cabinet Scraper", price: 150,
             line: "A burnished hook on a rectangle of steel. Takes a shaving, not a bite.",
             effect: "Scrapes cut a third as deep, so you can stop exactly where you meant to.",
             plate: "tool-scraper"),
    ShopTool(slug: "longstring", name: "Long String", price: 90,
             line: "Several inches too long on purpose. Shows the bend without straining anything.",
             effect: "The first three notches no longer strain the limbs.",
             plate: "tool-square"),
    ShopTool(slug: "rasp", name: "Cabinet Rasp", price: 110,
             line: "Hand stitched teeth in staggered rows. Hogs wood without leaving tracks.",
             effect: "Roughing out takes off far more per pass.",
             plate: "tool-rasp"),
    ShopTool(slug: "square", name: "Bow Square", price: 70,
             line: "Clips to the string and reads brace height and nocking point together.",
             effect: "Shows the brace height the bow actually wants.",
             plate: "tool-square"),
    ShopTool(slug: "steam", name: "Steam Box", price: 260,
             line: "An hour over boiling water and wood forgets some of what you did to it.",
             effect: "Takes half the set out of a finished bow, once per bow.",
             plate: "tool-drawknife"),
    ShopTool(slug: "sinew", name: "Sinew and Hide Glue", price: 300,
             line: "Laid in courses, dried for weeks, and the back stops being the weak part.",
             effect: "Staves take far more strain before a limb lets go.",
             plate: "tool-stave"),
]

func toolBySlug(_ s: String) -> ShopTool { shopTools.first { $0.slug == s } ?? shopTools[0] }

struct Kit {
    let owned: [String]
    var hasScale: Bool { owned.contains("scale") }
    var hasGizmo: Bool { owned.contains("gizmo") }
    var hasScraper: Bool { owned.contains("scraper") }
    var hasLongString: Bool { owned.contains("longstring") }
    var hasRasp: Bool { owned.contains("rasp") }
    var hasSquare: Bool { owned.contains("square") }
    var hasSteam: Bool { owned.contains("steam") }
    var hasSinew: Bool { owned.contains("sinew") }

    var scrapeBite: Double { hasScraper ? 0.0072 : 0.014 }
    var planeBonus: Double { hasRasp ? 2.1 : 1.0 }
    var breakBonus: Double { hasSinew ? 1.34 : 1.0 }
    var safeNotches: Int { hasLongString ? 10 : 7 }

    func weightReading(_ pounds: Double, seed: UInt64) -> String {
        if hasScale { return "\(Int(pounds.rounded())) lb" }
        var rng = Seeded(seed &+ UInt64(pounds * 4))
        let step = 5.0
        let blur = (pounds + rng.signed() * 2.4) / step
        return "about \(Int(blur.rounded() * step)) lb"
    }
}
