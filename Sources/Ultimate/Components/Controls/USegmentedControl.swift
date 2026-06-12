import SwiftUI

/// Pill track (surfaceFill, 4pt padding), 38pt items; selected item is a
/// controlActive pill with onControlActive text, slides with UMotion.easeOut.
public struct USegmentedControl: View {
    @Binding var selection: Int
    let items: [String]
    @Namespace private var pill
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.uHaptic) private var hapticOverride

    public init(selection: Binding<Int>, items: [String]) {
        self._selection = selection
        self.items = items
    }

    public var body: some View {
        HStack(spacing: 2) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, title in
                let isSelected = index == selection
                Button {
                    if selection != index {
                        fireSemanticHaptic(.selection, override: hapticOverride)
                    }
                    withAnimation(UMotion.easeOut()) { selection = index }
                } label: {
                    Text(title)
                        .font(UFont.custom("SemiBold", size: 14))
                        .foregroundStyle(isSelected ? UColor.onControlActive : UColor.textSecondary)
                        .padding(.horizontal, USpacing.s5)
                        .frame(height: 38)
                        .frame(maxWidth: .infinity)
                        .background {
                            if isSelected {
                                Capsule()
                                    .fill(UColor.controlActive)
                                    .matchedGeometryEffect(id: "pill", in: pill)
                            }
                        }
                        .contentShape(.capsule)
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
            }
        }
        .padding(4)
        .background(UColor.surfaceFill, in: .capsule)
        .opacity(isEnabled ? 1 : 0.4)
    }
}
