import SwiftUI

/// Screen header (TopBar.d.ts / `ult-topbar`): a centered title3 title flanked by
/// round icon buttons. The title is centered in a ZStack while leading/trailing
/// pin to the edges, so an uneven pair never shifts the title off-center.
///
/// Styles: `.plain` (default) renders bare, for bars living inside the scroll
/// column. `.glass` backs the bar with a faded frosted strip that extends up
/// through the status bar — pin the bar (e.g. `safeAreaInset(edge: .top)`) and
/// scrolling content dissolves under it.
public struct UTopBar<Leading: View, Trailing: View>: View {
    public enum Style: Sendable {
        case plain, glass
    }

    private let title: String
    private let style: Style
    private let leading: Leading
    private let trailing: Trailing

    public init(
        title: String,
        style: Style = .plain,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.style = style
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
        .background {
            if style == .glass {
                // Frost reaches up through the status bar and melts out a
                // little below the bar so content dissolves under it.
                UGlassEdgeFade(edge: .top, height: USize.controlLg + 64)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
}

public extension UTopBar where Leading == UIconButton, Trailing == EmptyView {
    /// Common case: a soft back chevron on the left, nothing trailing.
    init(title: String, style: Style = .plain, backAction: @escaping () -> Void) {
        self.init(
            title: title,
            style: style,
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
