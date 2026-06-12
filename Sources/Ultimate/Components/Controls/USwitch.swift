import SwiftUI

/// Toggle — 52×32 pill track, 24pt white thumb, spring slide.
/// Track: controlActive when on (ink light / lime dark), surfaceFill off.
public struct USwitch: View {
    @Binding var isOn: Bool
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.uHaptic) private var hapticOverride

    public init(isOn: Binding<Bool>) { self._isOn = isOn }

    public var body: some View {
        Button {
            fireSemanticHaptic(.selection, override: hapticOverride)
            withAnimation(UMotion.spring()) { isOn.toggle() }
        } label: {
            Capsule()
                .fill(isOn ? UColor.controlActive : UColor.surfaceFill)
                .frame(width: 52, height: 32)
                .overlay(alignment: isOn ? .trailing : .leading) {
                    Circle()
                        .fill(.white)
                        .frame(width: 24, height: 24)
                        .padding(4)
                        .uShadow(.card)
                }
                .opacity(isEnabled ? 1 : 0.4)
        }
        .buttonStyle(.plain)
        .frame(minWidth: USize.tapMin, minHeight: USize.tapMin)
        .accessibilityRepresentation { Toggle("", isOn: $isOn).labelsHidden() }
    }
}
