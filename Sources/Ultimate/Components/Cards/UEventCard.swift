import SwiftUI

/// Event/schedule card (EventCard.d.ts): time caption, big title, optional
/// subtitle, an avatar stack top-trailing, and a bottom row of meta chips with a
/// dark action circle (arrow-up-right) bottom-trailing.
///
/// Built on `UCard`: white when `tone == nil`, otherwise a pastel `.tint(tone)`.
/// The reference (`EventCard.jsx`) overrides the card radius to 2xl (36).
public struct UEventCard: View {
    private let time: String
    private let title: String
    private let subtitle: String?
    private let chips: [String]
    private let avatars: [(initials: String, tone: UTone)]
    private let tone: UTone?
    private let action: (() -> Void)?

    public init(
        time: String,
        title: String,
        subtitle: String? = nil,
        chips: [String] = [],
        avatars: [(initials: String, tone: UTone)] = [],
        tone: UTone? = nil,
        action: (() -> Void)? = nil
    ) {
        self.time = time
        self.title = title
        self.subtitle = subtitle
        self.chips = chips
        self.avatars = avatars
        self.tone = tone
        self.action = action
    }

    // Toned cards put chips on white pills; the white card uses soft pills.
    private var chipVariant: UChip.Variant { tone == nil ? .soft : .white }

    public var body: some View {
        let fill: UCardFill = tone.map { .tint($0) } ?? .card
        return UCard(fill: fill) {
            VStack(alignment: .leading, spacing: USpacing.s5) {
                    HStack(alignment: .top, spacing: USpacing.s3) {
                        VStack(alignment: .leading, spacing: USpacing.s1) {
                            Text(time)
                                .uText(.caption)
                                .opacity(0.75)
                            Text(title)
                                .uText(.title2)
                            if let subtitle {
                                Text(subtitle)
                                    .uText(.label)
                                    .opacity(0.75)
                            }
                        }
                        if !avatars.isEmpty {
                            Spacer(minLength: 0)
                            UAvatarStack(avatars, max: 3, size: 34)
                        }
                    }

                    if !chips.isEmpty || action != nil {
                        HStack(alignment: .center, spacing: USpacing.s3) {
                            if !chips.isEmpty {
                                HStack(spacing: USpacing.s2) {
                                    ForEach(Array(chips.enumerated()), id: \.offset) { _, c in
                                        UChip(c, variant: chipVariant)
                                    }
                                }
                            }
                            Spacer(minLength: 0)
                            if let action {
                                UIconButton(
                                    "arrow-up-right",
                                    variant: .dark,
                                    accessibilityLabel: "Open \(title)",
                                    action: action
                                )
                            }
                        }
                    }
                }
            }
        }
    }

