import SwiftUI
import Ultimate

// MARK: - Colors

struct ColorsPage: View {
    private struct Swatch: Identifiable {
        let id = UUID()
        let name: String
        let color: Color
    }

    private let text: [Swatch] = [
        .init(name: "textPrimary", color: UColor.textPrimary),
        .init(name: "textSecondary", color: UColor.textSecondary),
        .init(name: "textTertiary", color: UColor.textTertiary),
        .init(name: "textDisabled", color: UColor.textDisabled),
        .init(name: "textOnInverse", color: UColor.textOnInverse),
    ]
    private let surfaces: [Swatch] = [
        .init(name: "surfaceApp", color: UColor.surfaceApp),
        .init(name: "surfaceCard", color: UColor.surfaceCard),
        .init(name: "surfaceSunken", color: UColor.surfaceSunken),
        .init(name: "surfaceFill", color: UColor.surfaceFill),
        .init(name: "surfaceInverse", color: UColor.surfaceInverse),
    ]
    private let borders: [Swatch] = [
        .init(name: "borderHairline", color: UColor.borderHairline),
        .init(name: "borderStrong", color: UColor.borderStrong),
    ]
    private let accents: [Swatch] = [
        .init(name: "accentPrimary", color: UColor.accentPrimary),
        .init(name: "accentHighlight", color: UColor.accentHighlight),
    ]
    private let status: [Swatch] = [
        .init(name: "success", color: UColor.success),
        .init(name: "warning", color: UColor.warning),
        .init(name: "danger", color: UColor.danger),
        .init(name: "info", color: UColor.info),
    ]
    private let control: [Swatch] = [
        .init(name: "controlActive", color: UColor.controlActive),
        .init(name: "onControlActive", color: UColor.onControlActive),
        .init(name: "navBackground", color: UColor.navBackground),
        .init(name: "navActive", color: UColor.navActive),
    ]

    var body: some View {
        GalleryPage(title: "Colors") {
            swatchSection("Text", text)
            swatchSection("Surfaces", surfaces)
            swatchSection("Borders", borders)
            swatchSection("Accents", accents)
            swatchSection("Status", status)
            swatchSection("Control", control)

            SpecimenSection(title: "Candy palette") {
                VStack(spacing: USpacing.s2) {
                    ForEach(Array(UTone.allCases.enumerated()), id: \.offset) { _, tone in
                        candyRow(tone)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func swatchSection(_ title: String, _ swatches: [Swatch]) -> some View {
        SpecimenSection(title: title) {
            VStack(spacing: USpacing.s2) {
                ForEach(swatches) { s in
                    HStack(spacing: USpacing.s3) {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(s.color)
                            .frame(width: 32, height: 32)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .strokeBorder(UColor.borderHairline, lineWidth: 1)
                            )
                        Text(s.name).uText(.label).foregroundStyle(UColor.textPrimary)
                        Spacer()
                    }
                }
            }
        }
    }

    private func candyRow(_ tone: UTone) -> some View {
        HStack(spacing: USpacing.s3) {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(tone.fill).frame(width: 32, height: 32)
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(tone.tint).frame(width: 32, height: 32)
            Text(String(describing: tone))
                .uText(.label).foregroundStyle(UColor.textPrimary)
            Spacer()
        }
    }
}

// MARK: - Typography

struct TypographyPage: View {
    private let styles: [(UTextStyle, String)] = [
        (.display, "display"), (.title1, "title1"), (.title2, "title2"),
        (.title3, "title3"), (.headline, "headline"), (.body, "body"),
        (.label, "label"), (.caption, "caption"), (.micro, "micro"),
    ]

    var body: some View {
        GalleryPage(title: "Typography") {
            SpecimenSection(title: "Ramp") {
                VStack(alignment: .leading, spacing: USpacing.s5) {
                    ForEach(Array(styles.enumerated()), id: \.offset) { _, item in
                        VStack(alignment: .leading, spacing: USpacing.s1) {
                            Text(item.1).uText(.caption).foregroundStyle(UColor.textSecondary)
                            Text("The quick brown fox")
                                .uText(item.0)
                                .foregroundStyle(UColor.textPrimary)
                        }
                    }
                }
            }

            SpecimenSection(title: "Numbers are heroes") {
                HStack(alignment: .lastTextBaseline, spacing: 3) {
                    Text("50.0").uText(.display).foregroundStyle(UColor.textPrimary)
                    Text("kg").uText(.label).foregroundStyle(UColor.textSecondary)
                }
            }
        }
    }
}

// MARK: - Spacing & Radius

struct SpacingPage: View {
    private let spacings: [(String, CGFloat)] = [
        ("s1 · 4", USpacing.s1), ("s2 · 8", USpacing.s2), ("s3 · 12", USpacing.s3),
        ("s4 · 16", USpacing.s4), ("s5 · 20", USpacing.s5), ("s6 · 24", USpacing.s6),
        ("s8 · 32", USpacing.s8), ("s10 · 40", USpacing.s10), ("s12 · 48", USpacing.s12),
    ]
    private let radii: [(String, CGFloat)] = [
        ("xs", URadius.xs), ("sm", URadius.sm), ("md", URadius.md),
        ("lg", URadius.lg), ("xl", URadius.xl), ("xxl", URadius.xxl),
    ]
    private let controls: [(String, CGFloat)] = [
        ("sm · 36", USize.controlSm), ("md · 48", USize.controlMd), ("lg · 56", USize.controlLg),
    ]

    var body: some View {
        GalleryPage(title: "Spacing & Radius") {
            SpecimenSection(title: "Spacing") {
                VStack(alignment: .leading, spacing: USpacing.s2) {
                    ForEach(Array(spacings.enumerated()), id: \.offset) { _, item in
                        HStack(spacing: USpacing.s3) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(UColor.accentHighlight)
                                .frame(width: item.1, height: 16)
                            Text(item.0).uText(.caption).foregroundStyle(UColor.textSecondary)
                        }
                    }
                }
            }

            SpecimenSection(title: "Radius") {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3),
                          spacing: USpacing.s4) {
                    ForEach(Array(radii.enumerated()), id: \.offset) { _, item in
                        VStack(spacing: USpacing.s2) {
                            RoundedRectangle(cornerRadius: item.1, style: .continuous)
                                .fill(UColor.surfaceFill)
                                .frame(width: 56, height: 56)
                            Text(item.0).uText(.caption).foregroundStyle(UColor.textSecondary)
                        }
                    }
                }
            }

            SpecimenSection(title: "Control sizes") {
                HStack(spacing: USpacing.s3) {
                    ForEach(Array(controls.enumerated()), id: \.offset) { _, item in
                        VStack(spacing: USpacing.s2) {
                            Capsule()
                                .fill(UColor.surfaceFill)
                                .frame(width: item.1 + 24, height: item.1)
                            Text(item.0).uText(.caption).foregroundStyle(UColor.textSecondary)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Shadows

struct ShadowsPage: View {
    private let shadows: [(String, UShadow)] = [
        ("card", .card), ("float", .float), ("sheet", .sheet),
    ]

    var body: some View {
        GalleryPage(title: "Shadows") {
            ForEach(Array(shadows.enumerated()), id: \.offset) { _, item in
                Specimen(label: item.0) {
                    RoundedRectangle(cornerRadius: URadius.xl, style: .continuous)
                        .fill(UColor.surfaceCard)
                        .frame(height: 80)
                        .uShadow(item.1)
                        .padding(.vertical, USpacing.s2)
                }
            }
        }
    }
}
