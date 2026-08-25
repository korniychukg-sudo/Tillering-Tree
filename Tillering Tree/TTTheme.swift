import SwiftUI
import UIKit
import ImageIO

enum Bark {
    static let paper = Color(red: 0.933, green: 0.918, blue: 0.882)
    static let paperWarm = Color(red: 0.949, green: 0.929, blue: 0.878)
    static let card = Color(red: 0.968, green: 0.957, blue: 0.929)
    static let ink = Color(red: 0.110, green: 0.106, blue: 0.098)
    static let inkSoft = Color(red: 0.263, green: 0.251, blue: 0.235)
    static let inkPale = Color(red: 0.459, green: 0.447, blue: 0.427)
    static let sepia = Color(red: 0.333, green: 0.263, blue: 0.180)
    static let oxblood = Color(red: 0.529, green: 0.208, blue: 0.169)
    static let moss = Color(red: 0.404, green: 0.463, blue: 0.353)

    static let oak = Color(red: 0.635, green: 0.494, blue: 0.310)
    static let oakDark = Color(red: 0.400, green: 0.298, blue: 0.180)
    static let oakPale = Color(red: 0.769, green: 0.639, blue: 0.443)
    static let walnut = Color(red: 0.478, green: 0.333, blue: 0.220)
    static let walnutDark = Color(red: 0.302, green: 0.204, blue: 0.137)
    static let yew = Color(red: 0.706, green: 0.541, blue: 0.353)
    static let yewHeart = Color(red: 0.541, green: 0.302, blue: 0.180)
    static let yewSap = Color(red: 0.902, green: 0.820, blue: 0.651)
    static let osage = Color(red: 0.788, green: 0.616, blue: 0.212)
    static let osageDark = Color(red: 0.518, green: 0.373, blue: 0.106)
    static let hickory = Color(red: 0.792, green: 0.702, blue: 0.522)
    static let bamboo = Color(red: 0.831, green: 0.769, blue: 0.549)
    static let horn = Color(red: 0.286, green: 0.243, blue: 0.208)
    static let sinew = Color(red: 0.878, green: 0.831, blue: 0.741)
    static let hemp = Color(red: 0.769, green: 0.706, blue: 0.573)
    static let leather = Color(red: 0.435, green: 0.271, blue: 0.176)
    static let linen = Color(red: 0.855, green: 0.827, blue: 0.761)
    static let iron = Color(red: 0.353, green: 0.353, blue: 0.361)
    static let steel = Color(red: 0.600, green: 0.616, blue: 0.627)
    static let brass = Color(red: 0.741, green: 0.596, blue: 0.286)
    static let lamp = Color(red: 0.973, green: 0.859, blue: 0.639)
    static let dusk = Color(red: 0.286, green: 0.286, blue: 0.325)
    static let night = Color(red: 0.106, green: 0.102, blue: 0.106)
    static let gold = Color(red: 0.902, green: 0.749, blue: 0.239)

    static func serif(_ s: CGFloat) -> Font { .custom("Georgia", size: s) }
    static func serifBold(_ s: CGFloat) -> Font { .custom("Georgia-Bold", size: s) }
    static func serifItalic(_ s: CGFloat) -> Font { .custom("Georgia-Italic", size: s) }
}

enum Plates {
    private static let cache = NSCache<NSString, UIImage>()
    static func image(_ name: String, maxDim: CGFloat = 1200) -> UIImage? {
        let key = "\(name)@\(Int(maxDim))" as NSString
        if let hit = cache.object(forKey: key) { return hit }
        guard let path = Bundle.main.path(forResource: name, ofType: "jpg", inDirectory: "Art"),
              let src = CGImageSourceCreateWithURL(URL(fileURLWithPath: path) as CFURL, nil)
        else { return nil }
        let opts: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDim * UIScreen.main.scale
        ]
        guard let cg = CGImageSourceCreateThumbnailAtIndex(src, 0, opts as CFDictionary) else { return nil }
        let img = UIImage(cgImage: cg)
        cache.setObject(img, forKey: key)
        return img
    }
}

struct PlateView: View {
    let name: String
    var maxDim: CGFloat = 1100
    var mode: ContentMode = .fit
    var body: some View {
        GeometryReader { geo in
            if let img = Plates.image(name, maxDim: maxDim) {
                Image(uiImage: img).resizable().aspectRatio(contentMode: mode)
                    .frame(width: geo.size.width, height: geo.size.height).clipped()
            } else {
                Rectangle().fill(Bark.paperWarm).frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
}

struct PlateBand: View {
    let name: String
    var focusY: CGFloat = 0.34
    var zoom: CGFloat = 1.0
    var maxDim: CGFloat = 700
    var body: some View {
        GeometryReader { geo in
            if let img = Plates.image(name, maxDim: maxDim) {
                let iw = img.size.width, ih = img.size.height
                let scale = max(geo.size.width / iw, geo.size.height / ih) * zoom
                Image(uiImage: img).resizable()
                    .frame(width: iw * scale, height: ih * scale)
                    .offset(x: (geo.size.width - iw * scale) / 2,
                            y: geo.size.height / 2 - ih * scale * focusY)
            } else { Rectangle().fill(Bark.paperWarm) }
        }
        .clipped()
    }
}

struct Paperboard: View {
    var tone: Color = Bark.card
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(tone)
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Bark.ink.opacity(0.16), lineWidth: 1))
    }
}

struct RuleLine: View {
    var tone: Color = Bark.inkPale
    var body: some View { Rectangle().fill(tone.opacity(0.34)).frame(height: 1) }
}

struct SmallCap: View {
    let text: String
    var tone: Color = Bark.inkPale
    var size: CGFloat = 11
    var body: some View {
        Text(text.uppercased()).font(Bark.serif(size)).tracking(2.2).foregroundColor(tone)
    }
}

struct WoodButton: View {
    let title: String
    var tone: Color = Bark.walnut
    var enabled: Bool = true
    let action: () -> Void
    var body: some View {
        Button(action: { if enabled { action() } }) {
            Text(title.uppercased())
                .font(Bark.serifBold(13)).tracking(2.0)
                .foregroundColor(enabled ? Bark.paperWarm : Bark.paperWarm.opacity(0.5))
                .frame(maxWidth: .infinity).padding(.vertical, 13)
                .background(RoundedRectangle(cornerRadius: 3)
                    .fill(enabled ? tone : Bark.inkPale.opacity(0.45)))
                .overlay(RoundedRectangle(cornerRadius: 3).stroke(Bark.ink.opacity(0.30), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

struct QuietButton: View {
    let title: String
    var tone: Color = Bark.inkSoft
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title.uppercased())
                .font(Bark.serif(12)).tracking(2.0).foregroundColor(tone)
                .frame(maxWidth: .infinity).padding(.vertical, 11)
                .background(RoundedRectangle(cornerRadius: 3).fill(Bark.paperWarm))
                .overlay(RoundedRectangle(cornerRadius: 3).stroke(tone.opacity(0.34), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

enum BowyerRank {
    static let names = ["Splitter", "Rougher", "Tillerer", "Bowyer", "Master Bowyer", "Warbow Maker"]
    static let steps = [0, 240, 720, 1650, 3300, 6000]
    static func level(_ xp: Int) -> Int {
        var lv = 0
        for (i, s) in steps.enumerated() where xp >= s { lv = i }
        return lv
    }
    static func name(_ xp: Int) -> String { names[min(level(xp), names.count - 1)] }
    static func progress(_ xp: Int) -> Double {
        let lv = level(xp)
        guard lv < steps.count - 1 else { return 1 }
        return max(0, min(1, Double(xp - steps[lv]) / Double(steps[lv + 1] - steps[lv])))
    }
    static func nextAt(_ xp: Int) -> Int? {
        let lv = level(xp)
        return lv < steps.count - 1 ? steps[lv + 1] : nil
    }
}

struct DaySeed {
    let value: UInt64
    init(_ date: Date, salt: UInt64 = 0) {
        let c = Calendar.current.dateComponents([.year, .month, .day], from: date)
        var h: UInt64 = 1469598103934665603
        for n in [c.year ?? 0, c.month ?? 0, c.day ?? 0] {
            h = (h ^ UInt64(bitPattern: Int64(n))) &* 1099511628211
        }
        h = (h ^ salt) &* 1099511628211
        value = h
    }
    func pick<T>(_ items: [T], _ o: UInt64 = 0) -> T {
        items[Int((value &+ o &* 2654435761) % UInt64(max(1, items.count)))]
    }
    func int(_ lo: Int, _ hi: Int, _ o: UInt64 = 0) -> Int {
        lo + Int((value &+ o &* 40503) % UInt64(max(1, hi - lo + 1)))
    }
    func unit(_ o: UInt64 = 0) -> Double {
        Double((value &+ o &* 2246822519) % 100000) / 100000.0
    }
}

func dayKey(_ d: Date) -> String {
    let c = Calendar.current.dateComponents([.year, .month, .day], from: d)
    return String(format: "%04d-%02d-%02d", c.year ?? 0, c.month ?? 0, c.day ?? 0)
}

func shortDate(_ d: Date) -> String {
    let f = DateFormatter(); f.dateFormat = "d MMM"; f.locale = Locale(identifier: "en_US")
    return f.string(from: d)
}

struct Seeded {
    private var s: UInt64
    init(_ seed: UInt64) { s = seed == 0 ? 0x9E3779B97F4A7C15 : seed }
    mutating func next() -> UInt64 { s ^= s << 13; s ^= s >> 7; s ^= s << 17; return s }
    mutating func d() -> Double { Double(next() % 1_000_000) / 1_000_000.0 }
    mutating func r(_ a: Double, _ b: Double) -> Double { a + d() * (b - a) }
    mutating func i(_ a: Int, _ b: Int) -> Int { a + Int(next() % UInt64(max(1, b - a + 1))) }
    mutating func chance(_ p: Double) -> Bool { d() < p }
    mutating func signed() -> Double { d() * 2 - 1 }
}

func hashString(_ s: String) -> UInt64 {
    var h: UInt64 = 14695981039346656037
    for b in s.utf8 { h = (h ^ UInt64(b)) &* 1099511628211 }
    return h
}

func gradeWord(_ s: Double) -> String {
    switch s {
    case 0.93...: return "Faultless"
    case 0.82..<0.93: return "Clean"
    case 0.70..<0.82: return "Sound"
    case 0.56..<0.70: return "Serviceable"
    case 0.38..<0.56: return "Rough"
    default: return "Ruined"
    }
}
