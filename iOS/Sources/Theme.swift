import SwiftUI

enum Theme {
    static let background = Color(red: 0.06, green: 0.07, blue: 0.05)
    static let accent = Color(red: 0.75, green: 0.85, blue: 0.25)
    static let accentSecondary = Color(red: 0.20, green: 0.20, blue: 0.35)
    static let cardBackground = background.opacity(0.6)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.65)

    static var titleFont: Font { .system(.title2, design: .serif).weight(.bold) }
    static var headlineFont: Font { .system(.headline, design: .rounded) }
    static var bodyFont: Font { .system(.body, design: .rounded) }
    static var captionFont: Font { .system(.caption, design: .rounded) }

    static let cardCornerRadius: CGFloat = 16
}
