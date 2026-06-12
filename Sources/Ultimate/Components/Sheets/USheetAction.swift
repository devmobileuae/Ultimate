import SwiftUI

/// Action-sheet row (`ult-action` / SheetAction.d.ts): a 56pt soft pill with a
/// leading icon + headline label.
///
/// - `.soft` — `surfaceFill` pill (radius lg 20);
/// - `.plain` — borderless list row (no fill, 52pt) for Pura-style menus;
/// - `destructive` — `dangerWash` fill with `danger` icon/label.
public struct USheetAction: View {
    public enum Style { case soft, plain }

    private let icon: String
    private let label: String
    private let style: Style
    private let destructive: Bool
    private let action: () -> Void
    @Environment(\.uHaptic) private var hapticOverride

    public init(
        icon: String,
        label: String,
        style: Style = .soft,
        destructive: Bool = false,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.label = label
        self.style = style
        self.destructive = destructive
        self.action = action
    }

    private var background: Color {
        if destructive { return UColor.dangerWash }
        switch style {
        case .soft: return UColor.surfaceFill
        case .plain: return .clear
        }
    }

    private var foreground: Color {
        destructive ? UColor.danger : UColor.textPrimary
    }

    private var minHeight: CGFloat { style == .plain ? 52 : 56 }
    private var horizontalPadding: CGFloat { style == .plain ? USpacing.s1 : USpacing.s4 }

    public var body: some View {
        Button {
            // Destructive rows warn instead of the generic press haptic.
            if destructive { fireSemanticHaptic(.warning, override: hapticOverride) }
            action()
        } label: {
            HStack(spacing: USpacing.s3) {
                UIcon(icon, size: 22)
                Text(label)
                    .uText(.headline)
                Spacer(minLength: 0)
            }
            .foregroundStyle(foreground)
            .padding(.horizontal, horizontalPadding)
            .frame(minHeight: minHeight)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: URadius.lg, style: .continuous).fill(background)
            )
            .contentShape(RoundedRectangle(cornerRadius: URadius.lg, style: .continuous))
        }
        // Destructive rows fire `.warning` in the action; suppress the generic
        // press haptic there to avoid a double-fire. Non-destructive rows keep
        // the inherited press haptic.
        .modifier(SuppressPressHapticIf(suppressed: destructive))
        .buttonStyle(.uPressable)
    }
}

/// Sets `.uHaptic(.none)` only when `suppressed`, otherwise leaves the inherited
/// press haptic untouched.
private struct SuppressPressHapticIf: ViewModifier {
    let suppressed: Bool
    func body(content: Content) -> some View {
        if suppressed { content.uHaptic(.none) } else { content }
    }
}
