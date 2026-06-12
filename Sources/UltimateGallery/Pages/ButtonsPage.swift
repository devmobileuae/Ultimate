import SwiftUI
import Ultimate

struct ButtonsPage: View {
    private let variants: [(String, UButtonVariant)] = [
        ("primary", .primary), ("accent", .accent), ("soft", .soft),
        ("white", .white), ("outline", .outline), ("ghost", .ghost),
    ]
    private let iconVariants: [(String, UIconButtonVariant)] = [
        ("soft", .soft), ("white", .white), ("dark", .dark),
        ("outline", .outline), ("ghost", .ghost),
    ]

    var body: some View {
        GalleryPage(title: "Buttons") {
            ForEach(Array(variants.enumerated()), id: \.offset) { _, item in
                SpecimenSection(title: item.0) {
                    VStack(alignment: .leading, spacing: USpacing.s3) {
                        HStack(spacing: USpacing.s3) {
                            UButton("Small", variant: item.1, size: .sm) {}
                            UButton("Medium", variant: item.1, size: .md) {}
                            UButton("Large", variant: item.1, size: .lg) {}
                        }
                        HStack(spacing: USpacing.s3) {
                            UButton("Icon", variant: item.1, icon: "plus") {}
                            UButton("Next", variant: item.1, iconRight: "arrow-right") {}
                            UButton("Disabled", variant: item.1) {}.disabled(true)
                        }
                        UButton("Block", variant: item.1, block: true) {}
                    }
                }
            }

            SpecimenSection(title: "Icon buttons") {
                VStack(alignment: .leading, spacing: USpacing.s3) {
                    ForEach(Array(iconVariants.enumerated()), id: \.offset) { _, item in
                        Specimen(label: item.0) {
                            HStack(spacing: USpacing.s3) {
                                UIconButton("bell", variant: item.1, size: .sm,
                                            accessibilityLabel: "Notifications small") {}
                                UIconButton("bell", variant: item.1, size: .md,
                                            accessibilityLabel: "Notifications medium") {}
                                UIconButton("bell", variant: item.1, size: .lg,
                                            accessibilityLabel: "Notifications large") {}
                                UIconButton("bell", variant: item.1,
                                            accessibilityLabel: "Disabled") {}.disabled(true)
                            }
                        }
                    }
                    Specimen(label: "signature dark action") {
                        UIconButton("arrow-up-right", variant: .dark, size: .lg,
                                    accessibilityLabel: "Open") {}
                    }
                }
            }

            SpecimenSection(title: "glass") {
                VStack(alignment: .leading, spacing: USpacing.s4) {
                    HStack(spacing: USpacing.s3) {
                        UButton("Small", variant: .glass, size: .sm) {}
                        UButton("Medium", variant: .glass, size: .md) {}
                        UButton("Large", variant: .glass, size: .lg) {}
                    }
                    HStack(spacing: USpacing.s3) {
                        UButton("Disabled", variant: .glass) {}.disabled(true)
                        UIconButton("bell", variant: .glass, size: .lg,
                                    accessibilityLabel: "Notifications") {}
                    }
                    UButton("Block", variant: .glass, block: true) {}
                }
                .padding(USpacing.s5)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(colors: [UColor.peri, UColor.lilac],
                                   startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: .rect(cornerRadius: URadius.xl)
                )
            }
        }
    }
}
