import SwiftUI

/// Per-day styling/markers for a ``UCalendarDay`` (CalendarDay.d.ts).
public struct UCalendarDayInfo: Sendable {
    /// Pastel tint fill marking the day (uses `tone.tint`, ink text).
    public let tone: UTone?
    /// Up to 3 × 5pt marker dots under the number.
    public let dots: [UTone]
    /// A single 11pt Lucide icon marker under the number (tinted with text).
    public let icon: String?
    /// Coral counter pinned top-right.
    public let count: Int?
    public let disabled: Bool

    public init(
        tone: UTone? = nil,
        dots: [UTone] = [],
        icon: String? = nil,
        count: Int? = nil,
        disabled: Bool = false
    ) {
        self.tone = tone
        self.dots = dots
        self.icon = icon
        self.count = count
        self.disabled = disabled
    }
}

/// One calendar day pill (CalendarDay.d.ts / `ult-calday`): a pill-rounded number
/// with optional dots / icon markers and a top-right counter.
///
/// Variants: default · `selected` (`controlActive` fill, onControlActive text) ·
/// `today` (1.5pt `borderStrong` inset outline) · `muted` (adjacent month,
/// tertiary text) · disabled (from `info`, disabled text + no tap). An optional
/// `info.tone` paints a pastel tint behind the number.
public struct UCalendarDay: View {
    private let day: Int
    private let selected: Bool
    private let today: Bool
    private let muted: Bool
    private let info: UCalendarDayInfo?
    private let action: (() -> Void)?
    @Environment(\.uHaptic) private var hapticOverride

    public init(
        day: Int,
        selected: Bool = false,
        today: Bool = false,
        muted: Bool = false,
        info: UCalendarDayInfo? = nil,
        action: (() -> Void)? = nil
    ) {
        self.day = day
        self.selected = selected
        self.today = today
        self.muted = muted
        self.info = info
        self.action = action
    }

    private var disabled: Bool { info?.disabled ?? false }

    private var numberColor: Color {
        if selected { return UColor.onControlActive }
        if disabled { return UColor.textDisabled }
        if info?.tone != nil { return UColor.textPrimary }
        if muted { return UColor.textTertiary }
        return UColor.textPrimary
    }

    private var fill: Color {
        if selected { return UColor.controlActive }
        if let tone = info?.tone { return tone.tint }
        return .clear
    }

    @ViewBuilder private var content: some View {
        VStack(spacing: 3) {
            Text("\(day)")
                .uText(.label)
                .fontWeight(.semibold)
                .foregroundStyle(numberColor)
            markers
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 52)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: URadius.pill, style: .continuous).fill(fill)
        )
        .overlay {
            if today && !selected {
                RoundedRectangle(cornerRadius: URadius.pill, style: .continuous)
                    .strokeBorder(UColor.borderStrong, lineWidth: USize.borderStrong)
            }
        }
        .overlay(alignment: .topTrailing) {
            if let count = info?.count {
                counter(count)
            }
        }
        .contentShape(RoundedRectangle(cornerRadius: URadius.pill, style: .continuous))
    }

    @ViewBuilder private var markers: some View {
        if let icon = info?.icon {
            UIcon(icon, size: 11)
                .foregroundStyle(numberColor)
                .frame(minHeight: 6)
        } else if let dots = info?.dots, !dots.isEmpty {
            HStack(spacing: 3) {
                ForEach(Array(dots.prefix(3).enumerated()), id: \.offset) { _, tone in
                    Circle().fill(tone.fill).frame(width: 5, height: 5)
                }
            }
            .frame(minHeight: 6)
        } else {
            Color.clear.frame(height: 6)
        }
    }

    private func counter(_ count: Int) -> some View {
        Text("\(count)")
            .font(UFont.custom("Bold", size: 10))
            .foregroundStyle(.white)
            .padding(.horizontal, 4)
            .frame(minWidth: 16, minHeight: 16)
            .background(Capsule().fill(UColor.coral))
            .offset(x: -4, y: 2)
    }

    public var body: some View {
        if let action, !disabled {
            Button {
                if !selected { fireSemanticHaptic(.selection, override: hapticOverride) }
                action()
            } label: { content }
                // Suppress press haptic; fires `.selection` on an actual day
                // change instead (no double-fire).
                .uHaptic(.none)
                .buttonStyle(.uPressable)
                .accessibilityLabel("\(day)")
                .accessibilityAddTraits(selected ? [.isButton, .isSelected] : .isButton)
        } else {
            content
                .accessibilityLabel("\(day)")
                .accessibilityAddTraits(selected ? .isSelected : [])
        }
    }
}
