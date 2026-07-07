import Foundation
import Combine

final class Store: ObservableObject {
    @Published var entries: [LogEntry] = []
    @Published var categoryFilterEnabled: Bool = true
    @Published var isProUnlocked: Bool = false

    // Seed data ships with 3 entries. Keep this above the seed count
    // so a fresh install never immediately hits the paywall.
    static let freeTierLimit = 15

    private let fileURL: URL

    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let dir = appSupport.appendingPathComponent("Fireflyseason", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("entries.json")
        load()
    }

    var canAddMore: Bool {
        isProUnlocked || entries.count < Store.freeTierLimit
    }

    func add(_ entry: LogEntry) {
        guard canAddMore else { return }
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: LogEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: LogEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([LogEntry].self, from: data) else {
            entries = [
            LogEntry(location: "Back Yard", intensity: "Light", notes: "First few blinks near tree line", date: Date().addingTimeInterval(-0)),
            LogEntry(location: "Front Field", intensity: "Moderate", notes: "Scattered across the field at dusk", date: Date().addingTimeInterval(-259200)),
            LogEntry(location: "Wood Edge", intensity: "Light", notes: "A handful near the fence", date: Date().addingTimeInterval(-518400))
            ]
            save()
            return
        }
        entries = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
