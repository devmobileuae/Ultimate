import SwiftUI

/// 6pt track (surfaceFill), controlActive fill, 24pt white thumb with a
/// 3pt surfaceCard ring. Drag gesture updates value continuously.
public struct USlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    @Environment(\.isEnabled) private var isEnabled

    public init(value: Binding<Double>, in range: ClosedRange<Double> = 0...1) {
        self._value = value
        self.range = range
    }

    private let thumb: CGFloat = 24
    private let trackHeight: CGFloat = 6

    private func fraction() -> Double {
        let span = range.upperBound - range.lowerBound
        guard span > 0 else { return 0 }
        return min(1, max(0, (value - range.lowerBound) / span))
    }

    public var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let usable = max(0, width - thumb)
            let frac = fraction()
            let thumbX = usable * frac

            ZStack(alignment: .leading) {
                // Empty track
                Capsule()
                    .fill(UColor.borderHairline)
                    .frame(height: trackHeight)
                // Active fill, centered under the thumb
                Capsule()
                    .fill(UColor.controlActive)
                    .frame(width: thumbX + thumb / 2, height: trackHeight)
                // Thumb
                Circle()
                    .fill(.white)
                    .overlay(Circle().strokeBorder(UColor.surfaceCard, lineWidth: 3))
                    .uShadow(.card)
                    .frame(width: thumb, height: thumb)
                    .offset(x: thumbX)
            }
            .frame(maxHeight: .infinity)
            .contentShape(.rect)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { g in
                        guard usable > 0 else { return }
                        let x = min(usable, max(0, g.location.x - thumb / 2))
                        let span = range.upperBound - range.lowerBound
                        value = range.lowerBound + (x / usable) * span
                    }
            )
        }
        .frame(height: max(thumb, USize.tapMin))
        .opacity(isEnabled ? 1 : 0.4)
        .accessibilityRepresentation {
            Slider(value: $value, in: range)
        }
    }
}
