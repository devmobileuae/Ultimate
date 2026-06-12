import SwiftUI

/// +/− stepper. Horizontal pill (default) or compact vertical (28×26 buttons)
/// for cart rows. Clamps to range.
public struct UStepper: View {
    public enum Axis { case horizontal, verticalCompact }

    @Binding var value: Int
    let range: ClosedRange<Int>
    let axis: Axis
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.uHaptic) private var hapticOverride

    public init(value: Binding<Int>, in range: ClosedRange<Int> = 0...99,
                axis: Axis = .horizontal) {
        self._value = value
        self.range = range
        self.axis = axis
    }

    private var buttonSize: CGSize {
        axis == .horizontal ? CGSize(width: 32, height: 32) : CGSize(width: 28, height: 26)
    }
    private var valueFontSize: CGFloat { axis == .horizontal ? 14 : 13 }

    private func step(_ delta: Int) {
        let next = value + delta
        guard range.contains(next) else { return }   // clamped no-op stays silent
        fireSemanticHaptic(.selection, override: hapticOverride)
        withAnimation(UMotion.easeOut(UMotion.fast)) { value = next }
    }

    private func button(_ icon: String, delta: Int, label: String) -> some View {
        Button { step(delta) } label: {
            UIcon(icon, size: 18)
                .foregroundStyle(UColor.textPrimary)
                .frame(width: buttonSize.width, height: buttonSize.height)
                .contentShape(.capsule)
        }
        // Suppress the generic press haptic; `step()` fires `.selection` on an
        // actual change so a clamped tap makes no feedback (no double-fire).
        .uHaptic(.none)
        .buttonStyle(.uPressable)
        .disabled(!range.contains(value + delta))
        .opacity(range.contains(value + delta) ? 1 : 0.35)
        .accessibilityLabel(label)
    }

    private var valueLabel: some View {
        Text("\(value)")
            .font(UFont.custom("SemiBold", size: valueFontSize))
            .foregroundStyle(UColor.textPrimary)
            .frame(minWidth: 24)
            .monospacedDigit()
    }

    public var body: some View {
        Group {
            switch axis {
            case .horizontal:
                HStack(spacing: USpacing.s2) {
                    button("minus", delta: -1, label: "Decrement")
                    valueLabel
                    button("plus", delta: 1, label: "Increment")
                }
                .padding(4)
            case .verticalCompact:
                VStack(spacing: 0) {
                    button("plus", delta: 1, label: "Increment")
                    valueLabel
                    button("minus", delta: -1, label: "Decrement")
                }
                .padding(.vertical, 6).padding(.horizontal, 4)
            }
        }
        .background(UColor.surfaceFill, in: .capsule)
        .opacity(isEnabled ? 1 : 0.4)
        .accessibilityElement(children: .contain)
        .accessibilityValue("\(value)")
    }
}
