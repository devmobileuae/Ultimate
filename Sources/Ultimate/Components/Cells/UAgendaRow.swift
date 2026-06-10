import SwiftUI

/// Plan/agenda row (AgendaRow.d.ts / `ult-agenda`): label left, time range right,
/// on a soft rounded pill (radius `lg`).
///
/// `active: true` paints a coral fill with white-ink label — use for exactly ONE
/// current segment per list.
public struct UAgendaRow: View {
    private let label: String
    private let timeRange: String
    private let active: Bool

    public init(label: String, timeRange: String, active: Bool = false) {
        self.label = label
        self.timeRange = timeRange
        self.active = active
    }

    private var labelColor: Color { active ? UColor.textOnCoral : UColor.textPrimary }
    private var timeColor: Color { active ? UColor.textOnCoral : UColor.textSecondary }

    public var body: some View {
        HStack(alignment: .top, spacing: USpacing.s4) {
            Text(label)
                .uText(.label)
                .fontWeight(.semibold)
                .foregroundStyle(labelColor)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(timeRange)
                .uText(.label)
                .foregroundStyle(timeColor)
                .opacity(active ? 0.85 : 1)
                .fixedSize()
        }
        .padding(.vertical, USpacing.s4)
        .padding(.horizontal, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: URadius.lg, style: .continuous)
                .fill(active ? UColor.coral : UColor.surfaceFill)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label), \(timeRange)")
    }
}
