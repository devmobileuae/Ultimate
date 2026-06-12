import SwiftUI

/// 26pt circle; selected = thick controlActive ring (~10pt inner hole visible),
/// unselected = 1.5pt hairline ring (ult-radio spec).
public struct URadio: View {
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.uHaptic) private var hapticOverride

    public init(isSelected: Bool, action: @escaping () -> Void) {
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button {
            // Selecting an already-selected radio is a no-op — stay silent.
            if !isSelected { fireSemanticHaptic(.selection, override: hapticOverride) }
            action()
        } label: {
            Circle()
                .strokeBorder(
                    isSelected ? UColor.controlActive : UColor.borderHairline,
                    lineWidth: isSelected ? 8 : USize.borderStrong
                )
                .frame(width: 26, height: 26)
                .animation(UMotion.spring(), value: isSelected)
                .opacity(isEnabled ? 1 : 0.4)
        }
        .buttonStyle(.plain)
        .frame(minWidth: USize.tapMin, minHeight: USize.tapMin)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}
