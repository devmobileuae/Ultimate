import SwiftUI

/// Month calendar (Calendar.d.ts / `ult-cal`): a title row with prev/next nav,
/// a weekday header, and a 7-column grid of ``UCalendarDay`` cells.
///
/// Pure layout over Foundation's `Calendar` math — no date pickers, no data
/// assumptions. Leading/trailing adjacent-month days render muted; today uses
/// `calendar.isDateInToday`; the selection binding compares same-day. Per-day
/// markers come from the `dayInfo` closure. Selecting any day (including a muted
/// adjacent-month day) selects it.
public struct UCalendar: View {
    @Binding private var month: Date
    @Binding private var selection: Date?
    private let calendar: Calendar
    private let dayInfo: (Date) -> UCalendarDayInfo?

    public init(
        month: Binding<Date>,
        selection: Binding<Date?>,
        calendar: Calendar = .current,
        dayInfo: @escaping (Date) -> UCalendarDayInfo? = { _ in nil }
    ) {
        self._month = month
        self._selection = selection
        self.calendar = calendar
        self.dayInfo = dayInfo
    }

    private var monthStart: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: month)) ?? month
    }

    /// Weekday symbols rotated to honor `calendar.firstWeekday`.
    private var weekdaySymbols: [String] {
        let symbols = calendar.veryShortWeekdaySymbols
        let shift = calendar.firstWeekday - 1
        return Array(symbols[shift...] + symbols[..<shift])
    }

    /// Every cell date in the grid: leading adjacent-month padding, this month,
    /// then trailing padding to complete the final week.
    private var gridDates: [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: monthStart) else { return [] }
        let firstWeekday = calendar.component(.weekday, from: monthStart)
        let leading = (firstWeekday - calendar.firstWeekday + 7) % 7

        var dates: [Date] = []
        for offset in stride(from: -leading, to: 0, by: 1) {
            if let d = calendar.date(byAdding: .day, value: offset, to: monthStart) { dates.append(d) }
        }
        for day in range {
            if let d = calendar.date(byAdding: .day, value: day - 1, to: monthStart) { dates.append(d) }
        }
        let trailing = (7 - dates.count % 7) % 7
        if let last = dates.last {
            for offset in 1...max(trailing, 0) where trailing > 0 {
                if let d = calendar.date(byAdding: .day, value: offset, to: last) { dates.append(d) }
            }
        }
        return dates
    }

    private let columns = Array(repeating: GridItem(.flexible(), spacing: USpacing.s1), count: 7)

    public var body: some View {
        VStack(spacing: USpacing.s3) {
            header
            HStack(spacing: USpacing.s1) {
                ForEach(Array(weekdaySymbols.enumerated()), id: \.offset) { _, symbol in
                    Text(symbol)
                        .uText(.caption)
                        .foregroundStyle(UColor.textTertiary)
                        .frame(maxWidth: .infinity)
                }
            }
            LazyVGrid(columns: columns, spacing: USpacing.s1) {
                ForEach(gridDates, id: \.timeIntervalSince1970) { date in
                    dayCell(date)
                }
            }
        }
    }

    private var header: some View {
        HStack(spacing: USpacing.s2) {
            Text(month.formatted(Date.FormatStyle().month(.wide).year()))
                .uText(.title3)
                .foregroundStyle(UColor.textPrimary)
            Spacer(minLength: 0)
            UIconButton("chevron-left", variant: .soft, size: .sm,
                        accessibilityLabel: "Previous month") {
                changeMonth(by: -1)
            }
            UIconButton("chevron-right", variant: .soft, size: .sm,
                        accessibilityLabel: "Next month") {
                changeMonth(by: 1)
            }
        }
    }

    private func changeMonth(by value: Int) {
        if let next = calendar.date(byAdding: .month, value: value, to: monthStart) {
            withAnimation(UMotion.easeOut(UMotion.base)) { month = next }
        }
    }

    private func dayCell(_ date: Date) -> some View {
        let dayNumber = calendar.component(.day, from: date)
        let inMonth = calendar.isDate(date, equalTo: monthStart, toGranularity: .month)
        let isSelected = selection.map { calendar.isDate($0, inSameDayAs: date) } ?? false
        let isToday = calendar.isDateInToday(date)
        return UCalendarDay(
            day: dayNumber,
            selected: isSelected,
            today: isToday,
            muted: !inMonth,
            info: dayInfo(date),
            action: { selection = date }
        )
        .accessibilityLabel(date.formatted(.dateTime.weekday(.wide).day().month(.wide).year()))
    }
}
