import SwiftUI

/// Circular progress ring (`ProgressRing`): a soft `surfaceFill` track under a
/// round-capped `controlActive` (or candy `tone`) arc, with an optional centered
/// label. The trim animates with `easeOut(slow)` on progress change.
/// `progress` is clamped to 0...1.
public struct UProgressRing: View {
    private let progress: Double
    private let size: CGFloat
    private let lineWidth: CGFloat
    private let tone: UTone?
    private let label: String?

    public init(
        progress: Double,
        size: CGFloat = 48,
        lineWidth: CGFloat = 5,
        tone: UTone? = nil,
        label: String? = nil
    ) {
        self.progress = progress
        self.size = size
        self.lineWidth = lineWidth
        self.tone = tone
        self.label = label
    }

    private var clamped: Double { min(1, max(0, progress)) }
    private var fillColor: Color { tone?.fill ?? UColor.controlActive }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(UColor.surfaceFill, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: clamped)
                .stroke(fillColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(UMotion.easeOut(UMotion.slow), value: clamped)
            if let label {
                Text(label)
                    .font(UFont.custom("SemiBold", size: max(11, size * 0.26)))
                    .foregroundStyle(UColor.textPrimary)
            }
        }
        .frame(width: size, height: size)
        .accessibilityElement()
        .accessibilityValue(Text(label ?? "\(Int((clamped * 100).rounded())) percent"))
    }
}
