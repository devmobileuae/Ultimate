import SwiftUI
import Ultimate

struct CalendarPage: View {
    @State private var month = Date()
    @State private var selection: Date? = Date()

    private let cal = Calendar.current

    var body: some View {
        GalleryPage(title: "Calendar") {
            SpecimenSection(title: "Month") {
                UCard {
                    UCalendar(month: $month, selection: $selection) { date in
                        dayInfo(for: date)
                    }
                }
            }

            SpecimenSection(title: "Day variants") {
                HStack(spacing: USpacing.s2) {
                    dayChip("default") { UCalendarDay(day: 4) }
                    dayChip("selected") { UCalendarDay(day: 4, selected: true) }
                    dayChip("today") { UCalendarDay(day: 4, today: true) }
                    dayChip("muted") { UCalendarDay(day: 4, muted: true) }
                    dayChip("disabled") {
                        UCalendarDay(day: 4, info: UCalendarDayInfo(disabled: true))
                    }
                }
            }

            SpecimenSection(title: "Marker variants") {
                HStack(spacing: USpacing.s2) {
                    dayChip("tone") {
                        UCalendarDay(day: 7, info: UCalendarDayInfo(tone: .mint))
                    }
                    dayChip("dots") {
                        UCalendarDay(day: 8, info: UCalendarDayInfo(dots: [.coral, .peri, .amber]))
                    }
                    dayChip("icon") {
                        UCalendarDay(day: 9, info: UCalendarDayInfo(icon: "heart"))
                    }
                    dayChip("count") {
                        UCalendarDay(day: 10, info: UCalendarDayInfo(count: 3))
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func dayChip<V: View>(_ label: String, @ViewBuilder _ day: () -> V) -> some View {
        VStack(spacing: USpacing.s1) {
            day().frame(width: 44)
            Text(label).uText(.micro).foregroundStyle(UColor.textSecondary)
        }
    }

    /// Demonstrates every marker on real dates around the visible month.
    private func dayInfo(for date: Date) -> UCalendarDayInfo? {
        let d = cal.component(.day, from: date)
        switch d {
        case 3: return UCalendarDayInfo(tone: .mint)
        case 6: return UCalendarDayInfo(tone: .amber)
        case 9: return UCalendarDayInfo(dots: [.coral])
        case 12: return UCalendarDayInfo(dots: [.coral, .peri])
        case 15: return UCalendarDayInfo(dots: [.coral, .peri, .lime])
        case 18: return UCalendarDayInfo(icon: "heart")
        case 21: return UCalendarDayInfo(count: 2)
        case 24: return UCalendarDayInfo(count: 5)
        case 27: return UCalendarDayInfo(disabled: true)
        default: return nil
        }
    }
}
