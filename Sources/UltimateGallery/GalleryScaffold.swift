import SwiftUI
import Ultimate

/// Wraps every gallery page: paper background, scroll column, gutters,
/// and a light/dark toggle so each page is verifiable in both themes without
/// leaving the app (same subtree-scoping mechanism the design's dark screens use).
///
/// The dark toggle lives as a floating pill INSIDE the scheme-scoped content
/// (overlaid top-trailing) rather than in the navigation toolbar — a toolbar
/// item sits outside the `.environment(\.colorScheme, …)` subtree, so it would
/// not flip with the page. Placing it inside keeps it consistent with the rest
/// of the page and lets it recolor itself.
struct GalleryPage<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    @State private var darkMode = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: USpacing.s5) { content() }
                .padding(USpacing.gutter)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(UColor.surfaceApp)
        .overlay(alignment: .topTrailing) {
            UIconButton(
                darkMode ? "sun" : "moon",
                variant: .white,
                size: .sm,
                accessibilityLabel: darkMode ? "Switch to light mode" : "Switch to dark mode"
            ) {
                withAnimation(UMotion.easeOut()) { darkMode.toggle() }
            }
            .padding(USpacing.s4)
        }
        .environment(\.colorScheme, darkMode ? .dark : .light)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// Labeled specimen: caption above, content below.
struct Specimen<Content: View>: View {
    let label: String
    @ViewBuilder let content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: USpacing.s2) {
            Text(label).uText(.caption).foregroundStyle(UColor.textSecondary)
            content()
        }
    }
}

/// Section header inside a page.
struct SpecimenSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: USpacing.s3) {
            Text(title).uText(.title3).foregroundStyle(UColor.textPrimary)
            content()
        }
        .padding(.top, USpacing.s3)
    }
}
