import SwiftUI
import Ultimate

struct CardsPage: View {
    @State private var animatedProgress = 0.4

    var body: some View {
        GalleryPage(title: "Cards & Progress") {
            SpecimenSection(title: "Card") {
                VStack(spacing: USpacing.s4) {
                    Specimen(label: ".card") {
                        UCard {
                            cardBody("White card", "Whisper shadow, no border.")
                        }
                    }
                    Specimen(label: ".tone(.amber)") {
                        UCard(fill: .tone(.amber)) {
                            cardBody("Toned card", "Bold 500 fill, ink content.")
                        }
                    }
                    Specimen(label: ".tint(.peri)") {
                        UCard(fill: .tint(.peri)) {
                            cardBody("Tinted card", "Pastel 100 fill, ink content.")
                        }
                    }
                    Specimen(label: ".glass (over a colorful backdrop)") {
                        UCard(fill: .glass) {
                            cardBody("Glass card", "Material, tint, rim, highlight — no shadow.")
                        }
                        .padding(USpacing.s5)
                        .background(
                            LinearGradient(colors: [UColor.peri, UColor.lilac],
                                           startPoint: .topLeading, endPoint: .bottomTrailing),
                            in: .rect(cornerRadius: URadius.xxl)
                        )
                    }
                }
            }

            SpecimenSection(title: "Event card") {
                VStack(spacing: USpacing.s4) {
                    UEventCard(
                        time: "TODAY · 14:00",
                        title: "Design review",
                        subtitle: "Ultimate design system",
                        chips: ["Remote", "1h"],
                        avatars: [
                            (initials: "JA", tone: .coral),
                            (initials: "MK", tone: .peri),
                            (initials: "RL", tone: .mint),
                        ],
                        tone: .amber,
                        action: {}
                    )
                    UEventCard(
                        time: "FRI · 09:00",
                        title: "Standup",
                        chips: ["15m"]
                    )
                }
            }

            SpecimenSection(title: "Stat tile") {
                HStack(spacing: USpacing.s3) {
                    UStatTile(caption: "Balance", value: "4,682", unit: "$", tone: .mint)
                    UStatTile(caption: "Weight", value: "50.0", unit: "kg", tone: .peri)
                    UStatTile(caption: "Streak", value: "12", unit: "d", tone: .coral)
                }
            }

            SpecimenSection(title: "Progress bar") {
                VStack(spacing: USpacing.s4) {
                    Specimen(label: "0.0") { UProgressBar(progress: 0) }
                    Specimen(label: "0.4") { UProgressBar(progress: 0.4) }
                    Specimen(label: "1.0") { UProgressBar(progress: 1) }
                    Specimen(label: "toned (.coral)") {
                        UProgressBar(progress: 0.7, tone: .coral)
                    }
                    Specimen(label: "animated") {
                        VStack(spacing: USpacing.s3) {
                            UProgressBar(progress: animatedProgress, tone: .peri)
                            UButton("Randomize", variant: .soft, size: .sm) {
                                animatedProgress = Double.random(in: 0...1)
                            }
                        }
                    }
                }
            }

            SpecimenSection(title: "Progress ring") {
                HStack(spacing: USpacing.s6) {
                    UProgressRing(progress: 0.66, size: 48, label: "2/3")
                    UProgressRing(progress: 0.66, size: 64, tone: .coral, label: "2/3")
                }
            }
        }
    }

    private func cardBody(_ title: String, _ subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: USpacing.s1) {
            Text(title).uText(.title3)
            Text(subtitle).uText(.body)
        }
    }
}
