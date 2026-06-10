import SwiftUI

/// Screen header (TopBar.d.ts / `ult-topbar`): a centered title3 title flanked by
/// round icon buttons. The title is centered in a ZStack while leading/trailing
/// pin to the edges, so an uneven pair never shifts the title off-center.
public struct UTopBar<Leading: View, Trailing: View>: View {
    private let title: String
    private let leading: Leading
    private let trailing: Trailing

    public init(
        title: String,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.leading = leading()
        self.trailing = trailing()
    }

    public var body: some View {
        ZStack {
            Text(title)
                .uText(.title3)
                .foregroundStyle(UColor.textPrimary)
                .lineLimit(1)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, USize.controlLg)
                .accessibilityAddTraits(.isHeader)

            HStack(spacing: USpacing.s3) {
                leading
                Spacer(minLength: 0)
                trailing
            }
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: USize.controlLg)
    }
}

public extension UTopBar where Leading == UIconButton, Trailing == EmptyView {
    /// Common case: a soft back chevron on the left, nothing trailing.
    init(title: String, backAction: @escaping () -> Void) {
        self.init(
            title: title,
            leading: {
                UIconButton(
                    "chevron-left",
                    variant: .soft,
                    accessibilityLabel: "Back",
                    action: backAction
                )
            },
            trailing: { EmptyView() }
        )
    }
}
