import SwiftUI

/// 56pt pill text field with optional caption label above (Input.d.ts / `ult-field`).
///
/// Soft gray fill (`surfaceFill`), or white card fill + card shadow when `onCard`.
/// Focus draws an ink hairline-strong ring. Placeholder is `textTertiary`.
public struct UInput: View {
    @Binding private var text: String
    private let label: String?
    private let placeholder: String
    private let icon: String?
    private let onCard: Bool

    @FocusState private var focused: Bool

    public init(
        text: Binding<String>,
        label: String? = nil,
        placeholder: String = "",
        icon: String? = nil,
        onCard: Bool = false
    ) {
        self._text = text
        self.label = label
        self.placeholder = placeholder
        self.icon = icon
        self.onCard = onCard
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: USpacing.s2) {
            if let label {
                Text(label)
                    .uText(.caption)
                    .foregroundStyle(UColor.textSecondary)
                    .padding(.horizontal, USpacing.s5)
            }

            HStack(spacing: USpacing.s2) {
                if let icon {
                    UIcon(icon, size: 20)
                        .foregroundStyle(UColor.textTertiary)
                }
                TextField(
                    "",
                    text: $text,
                    prompt: Text(placeholder).foregroundStyle(UColor.textTertiary)
                )
                .uText(.body)
                .foregroundStyle(UColor.textPrimary)
                .focused($focused)
                .tint(UColor.accentPrimary)
            }
            .padding(.horizontal, USpacing.s5)
            .frame(height: USize.controlLg)
            .background {
                if onCard {
                    Capsule().fill(UColor.surfaceCard).uShadow(.card)
                } else {
                    Capsule().fill(UColor.surfaceFill)
                }
            }
            .overlay {
                Capsule().strokeBorder(
                    UColor.borderStrong,
                    lineWidth: focused ? USize.borderStrong : 0
                )
            }
            .animation(UMotion.easeOut(UMotion.fast), value: focused)
            .contentShape(.capsule)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label ?? placeholder)
    }
}
