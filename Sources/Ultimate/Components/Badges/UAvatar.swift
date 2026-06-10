import SwiftUI

/// Initials on a pastel candy tint (Avatar.d.ts / `ult-avatar`).
///
/// Text is ALWAYS ink (`textOnAccent`) on the `tone.tint` fill — pastels read in
/// both themes. Initials font scales with `size`.
public struct UAvatar: View {
    private let initials: String
    private let tone: UTone
    private let size: CGFloat

    public init(initials: String, tone: UTone = .peri, size: CGFloat = 40) {
        self.initials = initials
        self.tone = tone
        self.size = size
    }

    public var body: some View {
        Text(initials)
            .font(UFont.custom("SemiBold", size: size * 0.38))
            .foregroundStyle(UColor.textOnAccent)
            .frame(width: size, height: size)
            .background(Circle().fill(tone.tint))
            .accessibilityLabel(initials)
    }
}

/// Overlapping avatar row (Avatar.d.ts / `ult-avastack`): −10pt overlap, a 2pt
/// `surfaceCard` ring per avatar, and an ink "+N" pip when the list is longer
/// than `max`.
public struct UAvatarStack: View {
    private let entries: [(initials: String, tone: UTone)]
    private let maxCount: Int
    private let size: CGFloat

    public init(
        _ entries: [(initials: String, tone: UTone)],
        max: Int = 4,
        size: CGFloat = 32
    ) {
        self.entries = entries
        self.maxCount = max
        self.size = size
    }

    private var visible: ArraySlice<(initials: String, tone: UTone)> {
        entries.prefix(maxCount)
    }
    private var overflow: Int { Swift.max(0, entries.count - maxCount) }

    public var body: some View {
        HStack(spacing: -10) {
            ForEach(Array(visible.enumerated()), id: \.offset) { _, entry in
                UAvatar(initials: entry.initials, tone: entry.tone, size: size)
                    .overlay(Circle().strokeBorder(UColor.surfaceCard, lineWidth: 2))
            }
            if overflow > 0 {
                Text("+\(overflow)")
                    .uText(.micro)
                    .foregroundStyle(UColor.textOnInverse)
                    .frame(width: size, height: size)
                    .background(Circle().fill(UColor.surfaceInverse))
                    .overlay(Circle().strokeBorder(UColor.surfaceCard, lineWidth: 2))
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(entries.count) people")
    }
}
