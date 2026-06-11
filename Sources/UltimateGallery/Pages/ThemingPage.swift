import SwiftUI
import Ultimate

/// Demonstrates `UltimateTheme.configure(_:)`: pick a preset and the whole
/// gallery rebrands — accent, selection fills, primary buttons. "Stock"
/// restores the built-in Ultimate look.
struct ThemingPage: View {
    private struct Preset: Identifiable {
        let id = UUID()
        let name: String
        let swatch: UInt32
        let theme: UTheme
    }

    private static let presets: [Preset] = [
        Preset(name: "Stock", swatch: 0xE8552F, theme: UTheme()),
        Preset(name: "Garnet", swatch: 0xC44569, theme: UTheme(
            accentPrimary: .init(light: 0xC44569, dark: 0xE58BA3),
            controlActive: .init(light: 0xC44569, dark: 0xE58BA3),
            onControlActive: .init(light: 0xFFFFFF, dark: 0x121020)
        )),
        Preset(name: "Ocean", swatch: 0x2D7FF9, theme: UTheme(
            surfaceInverse: .init(light: 0x0B3B8C, dark: 0xFFFFFF),
            accentPrimary: .init(light: 0x2D7FF9, dark: 0x7FD1F7),
            controlActive: .init(light: 0x2D7FF9, dark: 0x7FD1F7),
            onControlActive: .init(light: 0xFFFFFF, dark: 0x07203F),
            navBackground: .init(0x0B3B8C)
        )),
        Preset(name: "Forest", swatch: 0x2E7D4F, theme: UTheme(
            accentPrimary: .init(light: 0x2E7D4F, dark: 0xA3E29C),
            controlActive: .init(light: 0x2E7D4F, dark: 0xA3E29C),
            onControlActive: .init(light: 0xFFFFFF, dark: 0x0D2417)
        )),
    ]

    @State private var selected = 0
    @State private var switchOn = true
    @State private var progress = 0.6

    var body: some View {
        GalleryPage(title: "Theming") {
            Text("Themes apply app-wide via UltimateTheme.configure — every token resolves the active theme at draw time. Visit other pages to see the rebrand.")
                .uText(.label)
                .foregroundStyle(UColor.textSecondary)

            Specimen(label: "presets") {
                HStack(spacing: USpacing.s2) {
                    ForEach(Array(Self.presets.enumerated()), id: \.element.id) { index, preset in
                        UChip(preset.name, selected: index == selected) {
                            selected = index
                            UltimateTheme.configure(preset.theme)
                        }
                    }
                }
            }

            // .id(selected) rebuilds the sample when the theme changes —
            // colors resolve the active theme at draw time, but SwiftUI only
            // redraws views whose tree changed. Runtime theme switchers should
            // do the same at their root (see README).
            SpecimenSection(title: "Live sample") {
                Specimen(label: "accent + primary") {
                    HStack(spacing: USpacing.s2) {
                        UButton("Primary") {}
                        UButton("Accent", variant: .accent) {}
                    }
                }
                Specimen(label: "selection fills") {
                    HStack(spacing: USpacing.s4) {
                        USwitch(isOn: $switchOn)
                        UChip("Selected", selected: true)
                        UProgressRing(progress: progress, label: "60%")
                    }
                }
                Specimen(label: "progress") {
                    UProgressBar(progress: progress)
                }
            }
            .id(selected)
        }
        .onDisappear {
            // Leaving the page keeps the chosen theme — that's the point —
            // but reset the demo to Stock so the rest of the gallery isn't
            // surprising on a fresh visit. Comment this out to keep exploring.
            selected = 0
            UltimateTheme.reset()
        }
    }
}
