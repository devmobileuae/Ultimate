import SwiftUI

/// Week date strip (DateStrip.d.ts / `ult-datestrip`): day pills stacking a
/// weekday caption (13) over a day number (17 semibold).
///
/// `.outlined` (default) draws a 1pt hairline ring, selected = `controlActive`
/// fill with `onControlActive` content (the weekday at 0.7 opacity). `.onAccent`
/// is the compact borderless variant for colored headers: content inherits the
/// header's foreground, and the selected day flips to a `surfaceCard` fill.
public struct UDateStrip: View {
    public enum Style { case outlined, onAccent }

    @Binding private var selection: Date
    private let dates: [Date]
    private let style: Style
    private let calendar = Calendar.current
    @Environment(\.uHaptic) private var hapticOverride

    public init(selection: Binding<Date>, dates: [Date], style: Style = .outlined) {
        self._selection = selection
        self.dates = dates
        self.style = style
    }

    private func weekdayName(_ date: Date) -> String {
        let i = calendar.component(.weekday, from: date) - 1
        return calendar.shortWeekdaySymbols[i]
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: USpacing.s2) {
                ForEach(dates, id: \.timeIntervalSince1970) { date in
                    dayPill(date)
                }
            }
        }
        .animation(UMotion.easeOut(UMotion.fast), value: selection)
    }

    @ViewBuilder
    private func dayPill(_ date: Date) -> some View {
        let isSelected = calendar.isDate(date, inSameDayAs: selection)
        let day = calendar.component(.day, from: date)
        Button {
            if !isSelected { fireSemanticHaptic(.selection, override: hapticOverride) }
            selection = date
        } label: {
            VStack(spacing: USpacing.s1) {
                Text(weekdayName(date))
                    .uText(.caption)
                    .opacity(weekdayOpacity(isSelected))
                Text("\(day)")
                    .uText(.headline)
            }
            .modifier(ForegroundIfSet(color: foreground(isSelected)))
            .frame(maxWidth: .infinity)
            .frame(minWidth: 44)
            .padding(.vertical, style == .outlined ? USpacing.s3 : USpacing.s2)
            .background(Capsule().fill(background(isSelected)))
            .overlay {
                if style == .outlined && !isSelected {
                    Capsule().strokeBorder(UColor.borderHairline, lineWidth: USize.borderHairline)
                }
            }
            .contentShape(.capsule)
        }
        // Suppress press haptic; the button fires `.selection` on an actual
        // day change instead (no double-fire).
        .uHaptic(.none)
        .buttonStyle(.uPressable)
        .accessibilityLabel(date.formatted(.dateTime.weekday(.wide).day().month(.wide)))
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }

    private func background(_ selected: Bool) -> Color {
        guard selected else { return .clear }
        return style == .outlined ? UColor.controlActive : UColor.surfaceCard
    }

    /// Returns nil when the content should inherit the parent's foreground
    /// (onAccent unselected days sit on a colored header).
    private func foreground(_ selected: Bool) -> Color? {
        switch style {
        case .outlined:
            return selected ? UColor.onControlActive : UColor.textPrimary
        case .onAccent:
            return selected ? UColor.textPrimary : nil
        }
    }

    private func weekdayOpacity(_ selected: Bool) -> Double {
        if style == .outlined { return selected ? 0.7 : 1 }
        return selected ? 1 : 0.8
    }
}

/// Applies a foreground color only when one is provided, otherwise leaves the
/// inherited foreground untouched.
private struct ForegroundIfSet: ViewModifier {
    let color: Color?
    func body(content: Content) -> some View {
        if let color {
            content.foregroundStyle(color)
        } else {
            content
        }
    }
}
