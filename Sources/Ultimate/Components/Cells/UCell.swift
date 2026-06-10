import SwiftUI

/// 44pt circle with a 20pt icon — the standard cell leading (`ult-cell__leading`).
public struct UCellIconCircle: View {
    private let icon: String
    private let tint: Color?

    /// - Parameter tint: circle fill, defaults to `surfaceFill`.
    public init(icon: String, tint: Color? = nil) {
        self.icon = icon
        self.tint = tint
    }

    public var body: some View {
        UIcon(icon, size: 20)
            .foregroundStyle(UColor.textPrimary)
            .frame(width: 44, height: 44)
            .background(Circle().fill(tint ?? UColor.surfaceFill))
    }
}

/// List row (Cell.d.ts / `ult-cell`): leading node, title/subtitle, trailing value,
/// optional chevron, and an inset bottom hairline divider.
///
/// When `action` is non-nil the row becomes a button that washes with `pressWash`
/// (rectangular, no scale) while pressed. Pass `showsDivider: false` on the last
/// row of a `UCellGroup`.
public struct UCell<Leading: View, Trailing: View>: View {
    private let title: String
    private let subtitle: String?
    private let value: String?
    private let chevron: Bool
    private let showsDivider: Bool
    private let action: (() -> Void)?
    private let leading: Leading
    private let trailing: Trailing

    public init(
        title: String,
        subtitle: String? = nil,
        value: String? = nil,
        chevron: Bool = false,
        showsDivider: Bool = true,
        action: (() -> Void)? = nil,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.subtitle = subtitle
        self.value = value
        self.chevron = chevron
        self.showsDivider = showsDivider
        self.action = action
        self.leading = leading()
        self.trailing = trailing()
    }

    // Leading column width (44pt circle) + row gap, used to inset the divider.
    private let leadingInset: CGFloat = 44 + USpacing.s3

    @ViewBuilder private var rowContent: some View {
        HStack(spacing: USpacing.s3) {
            leading

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .uText(.headline)
                    .foregroundStyle(UColor.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .uText(.label)
                        .foregroundStyle(UColor.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: USpacing.s2) {
                if let value {
                    Text(value)
                        .uText(.body)
                        .foregroundStyle(UColor.textSecondary)
                }
                trailing
                if chevron {
                    UIcon("chevron-right", size: 18)
                        .foregroundStyle(UColor.textTertiary)
                }
            }
        }
        .padding(.horizontal, USpacing.s4)
        .padding(.vertical, USpacing.s3)
        .frame(minHeight: 64)
        .contentShape(.rect)
    }

    @ViewBuilder private var divider: some View {
        if showsDivider {
            Rectangle()
                .fill(UColor.borderHairline)
                .frame(height: USize.borderHairline)
                .padding(.leading, leadingInset + USpacing.s4)
        }
    }

    public var body: some View {
        VStack(spacing: 0) {
            if let action {
                Button(action: action) { rowContent }
                    .buttonStyle(UCellButtonStyle())
            } else {
                rowContent
            }
            divider
        }
    }
}

/// Press feedback for tappable cells: rectangular `pressWash` overlay, no scale.
private struct UCellButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? UColor.pressWash : Color.clear)
            .animation(UMotion.easeOut(UMotion.fast), value: configuration.isPressed)
    }
}

// MARK: - Convenience init (icon circle leading, no trailing)

public extension UCell where Leading == UCellIconCircle, Trailing == EmptyView {
    /// Common case: a soft icon circle leading and no custom trailing node.
    init(
        icon: String,
        iconTint: Color? = nil,
        title: String,
        subtitle: String? = nil,
        value: String? = nil,
        chevron: Bool = false,
        showsDivider: Bool = true,
        action: (() -> Void)? = nil
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            value: value,
            chevron: chevron,
            showsDivider: showsDivider,
            action: action,
            leading: { UCellIconCircle(icon: icon, tint: iconTint) },
            trailing: { EmptyView() }
        )
    }
}
