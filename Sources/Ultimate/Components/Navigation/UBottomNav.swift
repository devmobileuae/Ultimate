import SwiftUI

/// Floating ink pill tab bar (BottomNav.d.ts / `ult-bottomnav`).
///
/// ALWAYS ink in both themes (`navBackground`), lifted by a `.float` shadow and
/// a 1pt `navRing` (visible only in dark). 56pt icon items; the active item is a
/// white circle (`navActive`) holding the icon in ink, sliding between slots with
/// a 220ms ease-out via `matchedGeometryEffect`. Inactive icons are white at 55%.
///
/// Caller overlays this ~16–26pt above the bottom edge.
public struct UBottomNav: View {
    public struct Item: Sendable {
        public let icon: String
        /// Accessibility label only — never rendered.
        public let label: String
        public init(icon: String, label: String) {
            self.icon = icon
            self.label = label
        }
    }

    @Binding private var selection: Int
    private let items: [Item]
    @Namespace private var pill
    @Environment(\.uHaptic) private var hapticOverride

    public init(selection: Binding<Int>, items: [Item]) {
        self._selection = selection
        self.items = items
    }

    public var body: some View {
        HStack(spacing: USpacing.s1) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                let isSelected = index == selection
                Button {
                    if selection != index {
                        fireSemanticHaptic(.selection, override: hapticOverride)
                    }
                    selection = index
                } label: {
                    UIcon(item.icon, size: 24)
                        .foregroundStyle(
                            isSelected ? UColor.navBackground : Color.white.opacity(0.55)
                        )
                        .frame(width: USize.controlLg, height: USize.controlLg)
                        .background {
                            if isSelected {
                                Circle()
                                    .fill(UColor.navActive)
                                    .matchedGeometryEffect(id: "activePill", in: pill)
                            }
                        }
                }
                // Suppress press haptic; the button fires `.selection` on an
                // actual tab change instead (no double-fire).
                .uHaptic(.none)
                .buttonStyle(.uPressable)
                .accessibilityLabel(item.label)
                .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
            }
        }
        .animation(UMotion.easeOut(UMotion.base), value: selection)
        .padding(6)
        .background(Capsule().fill(UColor.navBackground))
        .overlay {
            Capsule().strokeBorder(UColor.navRing, lineWidth: 1)
        }
        .uShadow(.float)
    }
}
