import SwiftUI

struct FinishedBow: Codable, Identifiable {
    var id: String
    var slug: String
    var made: Date
    var pounds: Double
    var drawTo: Int
    var follow: Double
    var evenness: Double
    var balance: Double
    var grade: Double
    var shots: Int
    var best: Int
    var cast: Double
}

struct TillerSave: Codable {
    var xp: Int = 0
    var streak: Int = 0
    var lastDay: String = ""
    var bows: [FinishedBow] = []
    var readGuides: [String] = []
    var seenBows: [String] = []
    var jobDone: [String] = []
    var scrapes: Int = 0
    var broken: Int = 0
    var bestGrade: Double = 0
    var shotsFired: Int = 0
    var rangeBest: Int = 0
    var toolsSeen: [String] = []
    var dKey: String = ""
    var dBows: Int = 0
    var dArrows: Int = 0
    var dReads: Int = 0
    var dBestEnd: Int = 0
    var dBroken: Int = 0
    var dBestGrade: Double = 0
}

final class TillerStore: ObservableObject {
    @Published var save = TillerSave()
    private let key = "tillering.tree.save.v1"

    init() { load() }

    func load() {
        if let d = UserDefaults.standard.data(forKey: key),
           let s = try? JSONDecoder().decode(TillerSave.self, from: d) {
            save = s
        }
        touchDay()
    }

    func persist() {
        if let d = try? JSONEncoder().encode(save) {
            UserDefaults.standard.set(d, forKey: key)
        }
    }

    func touchDay() {
        let today = dayKey(Date())
        guard save.lastDay != today else { return }
        if let prev = Calendar.current.date(byAdding: .day, value: -1, to: Date()),
           save.lastDay == dayKey(prev) {
            save.streak += 1
        } else if save.lastDay.isEmpty {
            save.streak = 1
        } else {
            save.streak = 1
        }
        save.lastDay = today
        save.dKey = today
        save.dBows = 0
        save.dArrows = 0
        save.dReads = 0
        save.dBestEnd = 0
        save.dBroken = 0
        save.dBestGrade = 0
        persist()
    }

    func award(_ n: Int) {
        save.xp += n
        persist()
    }

    func record(_ bow: FinishedBow) {
        save.bows.insert(bow, at: 0)
        save.dBows += 1
        save.dBestGrade = max(save.dBestGrade, bow.grade)
        save.bestGrade = max(save.bestGrade, bow.grade)
        if !save.seenBows.contains(bow.slug) { save.seenBows.append(bow.slug) }
        award(Int(120 + bow.grade * 260))
        persist()
    }

    func markBroken() {
        save.broken += 1
        save.dBroken += 1
        persist()
    }

    func markRead(_ slug: String) {
        guard !save.readGuides.contains(slug) else { return }
        save.readGuides.append(slug)
        save.dReads += 1
        award(14)
    }

    func markSeen(_ slug: String) {
        guard !save.seenBows.contains(slug) else { return }
        save.seenBows.append(slug)
        award(8)
    }

    func markTool(_ slug: String) {
        guard !save.toolsSeen.contains(slug) else { return }
        save.toolsSeen.append(slug)
        award(6)
    }

    func finishJob(_ key: String, reward: Int) {
        guard !save.jobDone.contains(key) else { return }
        save.jobDone.append(key)
        award(reward)
    }

    var jobDoneToday: Bool { save.jobDone.contains(dayKey(Date())) }

    func logShots(_ n: Int, score: Int) {
        save.shotsFired += n
        save.dArrows += n
        save.dBestEnd = max(save.dBestEnd, score)
        save.rangeBest = max(save.rangeBest, score)
        persist()
    }

    func updateBow(_ id: String, shots: Int, best: Int) {
        guard let i = save.bows.firstIndex(where: { $0.id == id }) else { return }
        save.bows[i].shots += shots
        save.bows[i].best = max(save.bows[i].best, best)
        persist()
    }
}
