import SwiftUI
import Ultimate

struct CellsPage: View {
    @State private var wifi = true

    var body: some View {
        GalleryPage(title: "Cells") {
            SpecimenSection(title: "Cell group") {
                UCellGroup {
                    UCell(icon: "settings", title: "Settings",
                          subtitle: "Tap me — press wash", chevron: true,
                          action: {})
                    UCell(icon: "wallet", iconTint: UColor.mintTint,
                          title: "Balance", value: "$4,682")
                    UCell(icon: "bell", title: "Notifications",
                          subtitle: "Daily summary at 9am")
                    UCell(title: "Wi-Fi", chevron: false,
                          leading: { UCellIconCircle(icon: "zap", tint: UColor.skyTint) },
                          trailing: { USwitch(isOn: $wifi) })
                    UCell(title: "Jane Appleseed", subtitle: "Account owner",
                          showsDivider: false,
                          leading: { UAvatar(initials: "JA", tone: .peri, size: 44) },
                          trailing: { EmptyView() })
                }
            }

            SpecimenSection(title: "Agenda rows") {
                VStack(spacing: USpacing.s2) {
                    UAgendaRow(label: "Morning standup", timeRange: "09:00 – 09:30")
                    UAgendaRow(label: "Focus block", timeRange: "10:00 – 12:00", active: true)
                    UAgendaRow(label: "Design review", timeRange: "14:00 – 15:00")
                }
            }
        }
    }
}
