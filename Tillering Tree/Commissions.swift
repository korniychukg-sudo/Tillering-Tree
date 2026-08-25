import SwiftUI

struct Client: Identifiable {
    let slug: String
    let name: String
    let trade: String
    let temper: String
    let opens: Int
    var id: String { slug }
}

let clientBook: [Client] = [
    Client(slug: "jack", name: "Coppice Jack", trade: "hurdle maker",
           temper: "Wants a working bow by the weekend and does not much care whose name is on it.",
           opens: 0),
    Client(slug: "alard", name: "Alard the Fletcher", trade: "arrowsmith",
           temper: "Matches shafts to bows for a living, so the weight had better be the weight you said.",
           opens: 0),
    Client(slug: "warden", name: "The Butts Warden", trade: "keeper of the range",
           temper: "Judges a bow by its curve. He has seen a great many and remembers the bad ones.",
           opens: 22),
    Client(slug: "reed", name: "Wilhelmina Reed", trade: "horse archer",
           temper: "Short bows only, and they have to shoot hard for their length.",
           opens: 46),
    Client(slug: "ashcombe", name: "Lady Ashcombe", trade: "collector",
           temper: "Pays for wood you would not dare cut, and will not tolerate string follow.",
           opens: 74),
    Client(slug: "osric", name: "Master Osric", trade: "warbow captain",
           temper: "Heavy bows for men who can pull them. Nothing under eighty pounds interests him.",
           opens: 108),
    Client(slug: "antiquary", name: "The Antiquary", trade: "museum copyist",
           temper: "Wants the exact pattern, the exact timber and the exact weight. No substitutions.",
           opens: 148),
    Client(slug: "proof", name: "The Guild Proof-Master", trade: "warden of the craft",
           temper: "Sets the piece that decides whether you are a bowyer or a man with a drawknife.",
           opens: 200),
]

func clientBySlug(_ s: String) -> Client { clientBook.first { $0.slug == s } ?? clientBook[0] }

struct Commission: Codable, Identifiable {
    var id: String
    var client: String
    var issued: Date
    var days: Int
    var pay: Int
    var rep: Int
    var title: String
    var line: String
    var pattern: String?
    var shape: String?
    var weight: Int?
    var weightTol: Int
    var maxFollow: Double?
    var minEvenness: Double?
    var minScore: Int?
    var taken: Bool
    var done: Bool

    var due: Date { Calendar.current.date(byAdding: .day, value: days, to: issued) ?? issued }

    func daysLeft(_ now: Date) -> Int {
        let a = Calendar.current.startOfDay(for: now)
        let b = Calendar.current.startOfDay(for: due)
        return Calendar.current.dateComponents([.day], from: a, to: b).day ?? 0
    }

    var demands: [String] {
        var out: [String] = []
        if let p = pattern { out.append(bowBySlug(p).name) }
        else if let s = shape, let sh = LimbShape(rawValue: s) { out.append(shapeWord(sh) + " pattern") }
        if let w = weight { out.append("\(w) lb, give or take \(weightTol)") }
        if let f = maxFollow { out.append(String(format: "string follow under %.1f in", f)) }
        if let e = minEvenness { out.append("tiller at least \(Int(e * 100)) per cent") }
        if let s = minScore { out.append("an end of six scoring \(s)") }
        return out
    }

    var needsShooting: Bool { minScore != nil }
}

func shapeWord(_ s: LimbShape) -> String {
    switch s {
    case .longbow: return "Longbow"
    case .flatbow: return "Flatbow"
    case .holmegaard: return "Holmegaard"
    case .recurve: return "Recurve"
    case .composite: return "Composite"
    case .yumi: return "Asymmetric"
    case .deflex: return "Deflex"
    case .pyramid: return "Pyramid"
    }
}

func matches(_ c: Commission, bow: FinishedBow) -> Bool {
    let entry = bowBySlug(bow.slug)
    if let p = c.pattern, p != bow.slug { return false }
    if let s = c.shape, entry.shape.rawValue != s { return false }
    if let w = c.weight, abs(bow.pounds - Double(w)) > Double(c.weightTol) { return false }
    if let f = c.maxFollow, bow.follow > f { return false }
    if let e = c.minEvenness, bow.evenness < e { return false }
    if let s = c.minScore, bow.best < s { return false }
    return true
}

func missedBy(_ c: Commission, bow: FinishedBow) -> String? {
    let entry = bowBySlug(bow.slug)
    if let p = c.pattern, p != bow.slug { return "wanted a \(bowBySlug(p).name)" }
    if let s = c.shape, entry.shape.rawValue != s,
       let sh = LimbShape(rawValue: s) { return "wanted a \(shapeWord(sh).lowercased()) pattern" }
    if let w = c.weight, abs(bow.pounds - Double(w)) > Double(c.weightTol) {
        return bow.pounds > Double(w) ? "\(Int(bow.pounds.rounded() - Double(w))) lb over"
                                      : "\(Int(Double(w) - bow.pounds.rounded())) lb under"
    }
    if let f = c.maxFollow, bow.follow > f { return String(format: "%.1f in of follow, too much", bow.follow) }
    if let e = c.minEvenness, bow.evenness < e { return "tiller only \(Int(bow.evenness * 100)) per cent" }
    if let s = c.minScore, bow.best < s { return "not shot to \(s) yet" }
    return nil
}

private func payFor(_ weight: Int, _ tol: Int, _ extras: Int, _ days: Int) -> Int {
    let base = 40 + weight / 2
    let tight = max(0, 6 - tol) * 14
    let rush = max(0, 8 - days) * 9
    return base + tight + rush + extras * 26
}

func makeCommission(_ client: Client, seed: DaySeed, salt: UInt64, now: Date, rank: Int) -> Commission {
    var rng = Seeded(seed.value &+ salt &* 2654435761 &+ hashString(client.slug))
    let pool: [BowEntry]
    var days = rng.i(4, 11)
    var tol = 5
    var extras = 0
    var minEven: Double? = nil
    var maxFollow: Double? = nil
    var minScore: Int? = nil
    var pattern: String? = nil
    var shape: String? = nil

    switch client.slug {
    case "jack":
        pool = bowLibrary.filter { $0.difficulty <= 2 }
        days = rng.i(3, 6)
        tol = 7
    case "alard":
        pool = bowLibrary.filter { $0.difficulty <= 3 }
        tol = 3
        extras += 1
    case "warden":
        pool = bowLibrary.filter { $0.difficulty <= 3 }
        minEven = 0.86
        extras += 1
    case "reed":
        pool = bowLibrary.filter { $0.length < 0.72 }
        tol = 4
        minScore = 32
        extras += 2
    case "ashcombe":
        pool = bowLibrary.filter { $0.ring == .yew || $0.ring == .porous }
        maxFollow = 1.2
        tol = 4
        extras += 2
    case "osric":
        pool = bowLibrary.filter { $0.weight >= 80 }
        tol = 6
        minEven = 0.80
        extras += 2
    case "antiquary":
        pool = bowLibrary
        tol = 3
        extras += 3
        days = rng.i(7, 14)
    default:
        pool = bowLibrary.filter { $0.difficulty >= 3 }
        tol = 3
        minEven = 0.90
        maxFollow = 1.4
        minScore = 38
        extras += 4
        days = rng.i(9, 16)
    }

    let entry = pool.isEmpty ? bowLibrary[rng.i(0, bowLibrary.count - 1)] : pool[rng.i(0, pool.count - 1)]
    if client.slug == "antiquary" || client.slug == "proof" || rng.chance(0.34) {
        pattern = entry.slug
    } else {
        shape = entry.shape.rawValue
    }
    let drift = rng.i(-4, 4)
    let want = max(24, entry.weight + drift)
    if rank >= 3 { tol = max(2, tol - 1) }

    let pay = payFor(want, tol, extras, days)
    let head = commissionTitle(client.slug, entry: entry, rng: &rng)
    let line = commissionLine(client.slug, entry: entry, want: want, rng: &rng)

    return Commission(id: "\(client.slug)-\(dayKey(now))-\(salt)", client: client.slug,
                      issued: now, days: days, pay: pay, rep: 8 + extras * 4,
                      title: head, line: line, pattern: pattern, shape: shape,
                      weight: want, weightTol: tol, maxFollow: maxFollow,
                      minEvenness: minEven, minScore: minScore, taken: false, done: false)
}

private func commissionTitle(_ slug: String, entry: BowEntry, rng: inout Seeded) -> String {
    switch slug {
    case "jack": return rng.chance(0.5) ? "A bow for the coppice" : "Something to shoot by Saturday"
    case "alard": return "A bow to match a sheaf of shafts"
    case "warden": return "A bow for the range to learn on"
    case "reed": return "Short bow, hard cast"
    case "ashcombe": return "For the case in the long gallery"
    case "osric": return "A war bow, and mean it"
    case "antiquary": return "A copy of the \(entry.name)"
    default: return "The proof piece"
    }
}

private func commissionLine(_ slug: String, entry: BowEntry, want: Int, rng: inout Seeded) -> String {
    switch slug {
    case "jack":
        return "Nothing fancy. It has to bend and it has to still be in one piece at the end of the week."
    case "alard":
        return "I have a sheaf spined for this weight and no patience for a bow that comes in light."
    case "warden":
        return "Beginners will draw it badly for years. Give me a curve that will forgive them."
    case "reed":
        return "It goes on a horse, so it stays short, and I want to see it group before I pay."
    case "ashcombe":
        return "I will be looking at it unstrung on a stand. Anything that follows the string is no use to me."
    case "osric":
        return "\(want) pounds. If it comes in at seventy I will find someone who can count."
    case "antiquary":
        return "The \(entry.name), in \(entry.timber.lowercased()), to the weight it was recorded at. No improvements."
    default:
        return "Everything at once, to the numbers. This is the piece the guild judges you on."
    }
}

func rollBoard(_ save: TillerSave, now: Date) -> [Commission] {
    let seed = DaySeed(now, salt: 0x80D)
    let open = clientBook.filter { $0.opens <= save.repTotal }
    var out: [Commission] = []
    let count = min(open.count, 2 + min(2, save.repTotal / 70))
    for i in 0..<count {
        let c = open[(Int(seed.value % UInt64(max(1, open.count))) + i * 3) % open.count]
        if out.contains(where: { $0.client == c.slug }) { continue }
        out.append(makeCommission(c, seed: seed, salt: UInt64(i), now: now,
                                  rank: BowyerRank.level(save.xp)))
    }
    if out.isEmpty, let first = open.first {
        out.append(makeCommission(first, seed: seed, salt: 9, now: now,
                                  rank: BowyerRank.level(save.xp)))
    }
    return out
}
