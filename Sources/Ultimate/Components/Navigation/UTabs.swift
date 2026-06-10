import SwiftUI

/// Horizontally scrollable chip-tab row (Tabs.d.ts / `ult-tabs`): the selected
/// tab is a `controlActive` pill. Composes ``UChip`` (selected) directly — the
/// `ult-tabs` chip metrics match `ult-chip`; only the row gap (8pt) differs.
public struct UTabs: View {
    @Binding private var selection: Int
    private let titles: [String]

    public init(selection: Binding<Int>, titles: [String]) {
        self._selection = selection
        self.titles = titles
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: USpacing.s2) {
                ForEach(Array(titles.enumerated()), id: \.offset) { index, title in
                    UChip(
                        title,
                        selected: index == selection,
                        action: { selection = index }
                    )
                }
            }
        }
        .animation(UMotion.easeOut(UMotion.fast), value: selection)
    }
}
