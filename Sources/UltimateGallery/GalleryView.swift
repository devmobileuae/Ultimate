import SwiftUI
import Ultimate

/// Catalog of every Ultimate token and component in every state.
///
/// Dogfoods the design system: the index itself is built from `UCellGroup` +
/// `UCell` rows on a paper background, navigating to one page per token group
/// and component family.
public struct GalleryView: View {
    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: USpacing.s6) {
                    group("Tokens", GalleryDestination.tokenPages)
                    group("Components", GalleryDestination.componentPages)
                }
                .padding(USpacing.gutter)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(UColor.surfaceApp)
            .navigationTitle("Ultimate")
            .navigationDestination(for: GalleryDestination.self) { $0.page }
        }
    }

    @ViewBuilder
    private func group(_ heading: String, _ pages: [GalleryDestination]) -> some View {
        VStack(alignment: .leading, spacing: USpacing.s3) {
            Text(heading)
                .uText(.caption)
                .foregroundStyle(UColor.textSecondary)
                .padding(.horizontal, USpacing.s4)
            UCellGroup {
                ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                    NavigationLink(value: page) {
                        UCell(
                            icon: page.icon,
                            iconTint: page.tone.tint,
                            title: page.title,
                            chevron: true,
                            showsDivider: index < pages.count - 1
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

/// One row in the gallery index; carries its destination page.
enum GalleryDestination: Hashable {
    case colors, typography, spacingRadius, shadows, theming
    case buttons, controls, inputs, cells, badgesAvatars
    case navigation, calendar, cardsProgress, sheetsToasts

    static let tokenPages: [GalleryDestination] = [
        .colors, .typography, .spacingRadius, .shadows, .theming,
    ]
    static let componentPages: [GalleryDestination] = [
        .buttons, .controls, .inputs, .cells, .badgesAvatars,
        .navigation, .calendar, .cardsProgress, .sheetsToasts,
    ]

    var title: String {
        switch self {
        case .colors: "Colors"
        case .typography: "Typography"
        case .spacingRadius: "Spacing & Radius"
        case .shadows: "Shadows"
        case .theming: "Theming"
        case .buttons: "Buttons"
        case .controls: "Controls"
        case .inputs: "Inputs"
        case .cells: "Cells"
        case .badgesAvatars: "Badges & Avatars"
        case .navigation: "Navigation"
        case .calendar: "Calendar"
        case .cardsProgress: "Cards & Progress"
        case .sheetsToasts: "Sheets & Toasts"
        }
    }

    var icon: String {
        switch self {
        case .colors: "heart"
        case .typography: "pencil"
        case .spacingRadius: "settings"
        case .shadows: "moon"
        case .theming: "star"
        case .buttons: "zap"
        case .controls: "settings"
        case .inputs: "search"
        case .cells: "receipt"
        case .badgesAvatars: "user"
        case .navigation: "house"
        case .calendar: "calendar"
        case .cardsProgress: "credit-card"
        case .sheetsToasts: "bell"
        }
    }

    var tone: UTone {
        switch self {
        case .colors: .coral
        case .typography: .amber
        case .spacingRadius: .peri
        case .shadows: .lilac
        case .theming: .sky
        case .buttons: .tangerine
        case .controls: .sky
        case .inputs: .mint
        case .cells: .pink
        case .badgesAvatars: .lime
        case .navigation: .coral
        case .calendar: .peri
        case .cardsProgress: .amber
        case .sheetsToasts: .mint
        }
    }

    @ViewBuilder var page: some View {
        switch self {
        case .colors: ColorsPage()
        case .typography: TypographyPage()
        case .spacingRadius: SpacingPage()
        case .shadows: ShadowsPage()
        case .theming: ThemingPage()
        case .buttons: ButtonsPage()
        case .controls: ControlsPage()
        case .inputs: InputsPage()
        case .cells: CellsPage()
        case .badgesAvatars: BadgesPage()
        case .navigation: NavigationPage()
        case .calendar: CalendarPage()
        case .cardsProgress: CardsPage()
        case .sheetsToasts: SheetsPage()
        }
    }
}
