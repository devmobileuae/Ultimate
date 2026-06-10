import SwiftUI

/// Linear progress (`ult-progressbar`): an 8pt pill track (`surfaceFill`) with a
/// `controlActive` (or candy `tone`) fill. The fill width animates with
/// `easeOut(slow)` on progress change. `progress` is clamped to 0...1.
public struct UProgressBar: View {
    private let progress: Double
    private let tone: UTone?

    public init(progress: Double, tone: UTone? = nil) {
        self.progress = progress
        self.tone = tone
    }

    private var clamped: Double { min(1, max(0, progress)) }
    private var fillColor: Color { tone?.fill ?? UColor.controlActive }

    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(UColor.surfaceFill)
                Capsule()
                    .fill(fillColor)
                    .frame(width: geo.size.width * clamped)
                    .animation(UMotion.easeOut(UMotion.slow), value: clamped)
            }
        }
        .frame(height: 8)
        .accessibilityElement()
        .accessibilityValue(Text("\(Int((clamped * 100).rounded())) percent"))
        .accessibilityAddTraits(.updatesFrequently)
    }
}
