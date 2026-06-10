import SwiftUI

/// Search field: leading "search" icon, 56pt pill, ink focus ring (SearchBar.d.ts).
/// Same fill/focus behavior as `UInput`.
public struct USearchBar: View {
    @Binding private var text: String
    private let placeholder: String
    private let onCard: Bool

    @FocusState private var focused: Bool

    public init(
        text: Binding<String>,
        placeholder: String = "Search",
        onCard: Bool = false
    ) {
        self._text = text
        self.placeholder = placeholder
        self.onCard = onCard
    }

    public var body: some View {
        HStack(spacing: USpacing.s2) {
            UIcon("search", size: 20)
                .foregroundStyle(UColor.textTertiary)
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
        .accessibilityElement(children: .combine)
        .accessibilityLabel(placeholder)
    }
}
