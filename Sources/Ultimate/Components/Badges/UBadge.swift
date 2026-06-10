import SwiftUI

/// Count or status badge (Badge.d.ts / `ult-badge`): a 20pt bold count pill, or
/// an 8pt notification dot when `count` is nil. Default tone coral.
public struct UBadge: View {
    private let count: Int?
    private let tone: UTone

    public init(count: Int? = nil, tone: UTone = .coral) {
        self.count = count
        self.tone = tone
    }

    public var body: some View {
        if let count {
            Text("\(count)")
                .uText(.micro)
                .foregroundStyle(tone.onFill)
                .padding(.horizontal, 6)
                .frame(minWidth: 20, minHeight: 20)
                .background(Capsule().fill(tone.fill))
                .accessibilityLabel("\(count)")
        } else {
            Circle()
                .fill(tone.fill)
                .frame(width: 8, height: 8)
                .accessibilityHidden(true)
        }
    }
}
