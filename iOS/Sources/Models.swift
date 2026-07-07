import Foundation

struct LogEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var location: String
    var intensity: String
    var notes: String
    var date: Date = Date()
}
