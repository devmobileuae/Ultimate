import SwiftUI

/// Pastel stat tile (StatTile.d.ts): caption label over a big number on a candy
/// tint. Ink text in BOTH themes (pastels don't invert).
///
/// Per `StatTile.jsx`: fill = `tone-100` tint, radius lg (20), padding 14×16,
/// caption (full ink) over a title2 value; an optional `unit` drops to label
/// size, baseline-aligned ("Numbers are heroes").
public struct UStatTile: View {
    private let caption: String
    private let value: String
    private let unit: String?
    private let tone: UTone

    public init(
        caption: String,
        value: String,
        unit: String? = nil,
        tone: UTone = .mint
    ) {
        self.caption = caption
        self.value = value
        self.unit = unit
        self.tone = tone
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: USpacing.s1) {
            Text(caption)
                .uText(.caption)
            HStack(alignment: .lastTextBaseline, spacing: 3) {
                Text(value)
                    .uText(.title2)
                if let unit {
                    Text(unit)
                        .uText(.label)
                }
            }
        }
        .foregroundStyle(UColor.textOnAccent)  // ink, constant across themes
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 14)
        .padding(.horizontal, USpacing.s4)
        .background(RoundedRectangle(cornerRadius: URadius.lg, style: .continuous).fill(tone.tint))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(caption): \(value)\(unit.map { " \($0)" } ?? "")")
    }
}
