import SwiftUI
import Ultimate

struct NavigationPage: View {
    @State private var navSelection = 0
    @State private var tabSelection = 0
    @State private var dateSelection = Date()
    @State private var dateAccentSelection = Date()
    @State private var dropdown1 = 0
    @State private var dropdown2 = 1

    private let navItems = [
        UBottomNav.Item(icon: "house", label: "Home"),
        UBottomNav.Item(icon: "search", label: "Search"),
        UBottomNav.Item(icon: "calendar", label: "Calendar"),
        UBottomNav.Item(icon: "user", label: "Profile"),
    ]

    private var weekDates: [Date] {
        let cal = Calendar.current
        let start = cal.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return (0..<14).compactMap { cal.date(byAdding: .day, value: $0, to: start) }
    }

    private let dropdownOptions = [
        UDropdownOption(label: "Edit", icon: "pencil"),
        UDropdownOption(label: "Share", icon: "share-2"),
        UDropdownOption(label: "Download", icon: "download"),
        UDropdownOption(label: "Delete", icon: "trash-2", destructive: true),
    ]

    var body: some View {
        GalleryPage(title: "Navigation") {
            SpecimenSection(title: "Bottom nav") {
                UBottomNav(selection: $navSelection, items: navItems)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, USpacing.s2)
            }

            SpecimenSection(title: "Top bar") {
                VStack(spacing: USpacing.s4) {
                    UTopBar(title: "Back convenience", backAction: {})
                    UTopBar(
                        title: "Custom",
                        leading: {
                            UIconButton("chevron-left", variant: .soft,
                                        accessibilityLabel: "Back") {}
                        },
                        trailing: {
                            UIconButton("settings", variant: .soft,
                                        accessibilityLabel: "Settings") {}
                        }
                    )
                }
            }

            SpecimenSection(title: "Tabs") {
                UTabs(selection: $tabSelection,
                      titles: ["All", "Unread", "Mentions", "Archived", "Spam"])
            }

            SpecimenSection(title: "Date strip") {
                VStack(alignment: .leading, spacing: USpacing.s4) {
                    Specimen(label: "outlined") {
                        UDateStrip(selection: $dateSelection, dates: weekDates)
                    }
                    Specimen(label: "onAccent (coral header)") {
                        VStack(alignment: .leading, spacing: USpacing.s3) {
                            Text("This week").uText(.headline)
                                .foregroundStyle(UColor.textOnCoral)
                            UDateStrip(selection: $dateAccentSelection,
                                       dates: weekDates, style: .onAccent)
                        }
                        .padding(USpacing.s4)
                        .background(
                            RoundedRectangle(cornerRadius: URadius.xxl, style: .continuous)
                                .fill(UColor.coral)
                        )
                    }
                }
            }

            SpecimenSection(title: "Nav circle") {
                UNavCircleRow {
                    UNavCircle(icon: "plus", label: "Add", tone: .soft) {}
                    UNavCircle(icon: "send", label: "Send", tone: .dark) {}
                    UNavCircle(icon: "wallet", label: "Bills", tone: .white, badge: 3) {}
                    UNavCircle(icon: "gift", label: "Rewards",
                               tone: .candy(.amber)) {}
                    UNavCircle(icon: "star", label: "Saved", tone: .soft, selected: true) {}
                }
            }

            SpecimenSection(title: "Dropdown") {
                HStack(alignment: .top, spacing: USpacing.s8) {
                    Specimen(label: "default trigger") {
                        UDropdown(selection: $dropdown1,
                                  options: [
                                    UDropdownOption(label: "Newest"),
                                    UDropdownOption(label: "Oldest"),
                                    UDropdownOption(label: "Popular"),
                                  ])
                    }
                    Specimen(label: "custom trigger") {
                        UDropdown(selection: $dropdown2, options: dropdownOptions) {
                            UIcon("settings", size: 18)
                                .foregroundStyle(UColor.textPrimary)
                                .frame(width: USize.controlMd, height: USize.controlMd)
                                .background(Circle().fill(UColor.surfaceFill))
                        }
                    }
                }
            }
        }
    }
}
