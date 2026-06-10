import SwiftUI
import Ultimate

struct BadgesPage: View {
    @State private var chipSel: Set<Int> = [0]

    private let avatarTones: [UTone] = UTone.allCases

    var body: some View {
        GalleryPage(title: "Badges & Avatars") {
            SpecimenSection(title: "Badge") {
                HStack(spacing: USpacing.s5) {
                    UBadge(count: 1, tone: .coral)
                    UBadge(count: 12, tone: .peri)
                    UBadge(count: 99, tone: .amber)
                    UBadge(tone: .coral)
                    UBadge(tone: .mint)
                }
            }

            SpecimenSection(title: "Chip") {
                VStack(alignment: .leading, spacing: USpacing.s3) {
                    chipRow("soft", .soft, base: 0)
                    chipRow("outline", .outline, base: 3)
                    chipRow("white", .white, base: 6)
                    Specimen(label: "with icon") {
                        HStack(spacing: USpacing.s2) {
                            UChip("Filter", icon: "settings", variant: .soft,
                                  selected: chipSel.contains(9)) { toggle(9) }
                            UChip("Favorite", icon: "heart", variant: .outline,
                                  selected: chipSel.contains(10)) { toggle(10) }
                        }
                    }
                }
            }

            SpecimenSection(title: "Avatar") {
                VStack(alignment: .leading, spacing: USpacing.s4) {
                    Specimen(label: "all tones · 40") {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: USpacing.s2) {
                                ForEach(Array(avatarTones.enumerated()), id: \.offset) { _, t in
                                    UAvatar(initials: "AB", tone: t, size: 40)
                                }
                            }
                        }
                    }
                    Specimen(label: "sizes 32 / 40 / 64") {
                        HStack(alignment: .bottom, spacing: USpacing.s3) {
                            UAvatar(initials: "JA", tone: .coral, size: 32)
                            UAvatar(initials: "JA", tone: .coral, size: 40)
                            UAvatar(initials: "JA", tone: .coral, size: 64)
                        }
                    }
                }
            }

            SpecimenSection(title: "Avatar stack") {
                VStack(alignment: .leading, spacing: USpacing.s4) {
                    Specimen(label: "3 (within max)") {
                        UAvatarStack([
                            (initials: "JA", tone: .coral),
                            (initials: "MK", tone: .peri),
                            (initials: "RL", tone: .mint),
                        ])
                    }
                    Specimen(label: "6 (overflow +N)") {
                        UAvatarStack([
                            (initials: "JA", tone: .coral),
                            (initials: "MK", tone: .peri),
                            (initials: "RL", tone: .mint),
                            (initials: "SP", tone: .amber),
                            (initials: "TW", tone: .lilac),
                            (initials: "VX", tone: .pink),
                        ])
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func chipRow(_ label: String, _ variant: UChip.Variant, base: Int) -> some View {
        Specimen(label: label) {
            HStack(spacing: USpacing.s2) {
                UChip("Unselected", variant: variant,
                      selected: chipSel.contains(base)) { toggle(base) }
                UChip("Selected", variant: variant,
                      selected: chipSel.contains(base + 1)) { toggle(base + 1) }
            }
        }
    }

    private func toggle(_ id: Int) {
        if chipSel.contains(id) { chipSel.remove(id) } else { chipSel.insert(id) }
    }
}
