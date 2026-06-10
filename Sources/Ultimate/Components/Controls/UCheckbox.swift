import SwiftUI

/// 26pt square, 9pt corner radius; fills controlActive with a white check pop.
/// Unchecked: transparent with a 1.5pt hairline ring (ult-check spec).
public struct UCheckbox: View {
    @Binding var isChecked: Bool
    @Environment(\.isEnabled) private var isEnabled

    public init(isChecked: Binding<Bool>) { self._isChecked = isChecked }

    public var body: some View {
        Button {
            withAnimation(UMotion.spring()) { isChecked.toggle() }
        } label: {
            RoundedRectangle(cornerRadius: 9, style: .continuous)
                .fill(isChecked ? UColor.controlActive : .clear)
                .overlay {
                    if !isChecked {
                        RoundedRectangle(cornerRadius: 9, style: .continuous)
                            .strokeBorder(UColor.borderHairline, lineWidth: USize.borderStrong)
                    }
                }
                .overlay {
                    UIcon("check", size: 16)
                        .foregroundStyle(UColor.onControlActive)
                        .opacity(isChecked ? 1 : 0)
                        .scaleEffect(isChecked ? 1 : 0.5)
                }
                .frame(width: 26, height: 26)
                .opacity(isEnabled ? 1 : 0.4)
        }
        .buttonStyle(.plain)
        .frame(minWidth: USize.tapMin, minHeight: USize.tapMin)
        .accessibilityRepresentation { Toggle("", isOn: $isChecked).labelsHidden() }
    }
}
