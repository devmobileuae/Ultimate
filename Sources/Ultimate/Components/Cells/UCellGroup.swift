import SwiftUI

/// White rounded container hosting `UCell` rows (`ult-cellgroup`).
///
/// The last cell in the group should pass `showsDivider: false` so no hairline
/// hangs below the final row.
public struct UCellGroup<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(UColor.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: URadius.lg, style: .continuous))
    }
}
