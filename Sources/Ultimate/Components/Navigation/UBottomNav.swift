import SwiftUI

/// Floating pill tab bar (BottomNav.d.ts / `ult-bottomnav`).
///
/// Two styles:
/// - `.ink` (default): ALWAYS ink in both themes (`navBackground`), lifted by a
///   `.float` shadow and a 1pt `navRing` (visible only in dark). Active item is
///   a white circle (`navActive`) with an ink icon; inactive icons white @55%.
/// - `.glass`: frosted pill — the scrolling content shimmers through. Active
///   item is a `surfaceInverse` circle with `textOnInverse` icon; inactive
///   icons `textSecondary`. No shadow (glass floats by contrast).
///
/// The active circle slides between slots with a 220ms ease-out via
/// `matchedGeometryEffect`. Caller overlays this ~16–26pt above the bottom edge.
public struct UBottomNav: View {
    public enum Style: Sendable {
        case ink, glass
    }

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
    private let style: Style
    @Namespace private var pill
    @Environment(\.uHaptic) private var hapticOverride

    public init(selection: Binding<Int>, items: [Item], style: Style = .ink) {
        self._selection = selection
        self.items = items
        self.style = style
    }

    private var activeCircle: Color {
        style == .ink ? UColor.navActive : UColor.surfaceInverse
    }
    private var activeIcon: Color {
        style == .ink ? UColor.navBackground : UColor.textOnInverse
    }
    private var inactiveIcon: Color {
        style == .ink ? Color.white.opacity(0.55) : UColor.textSecondary
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
                        .foregroundStyle(isSelected ? activeIcon : inactiveIcon)
                        .frame(width: USize.controlLg, height: USize.controlLg)
                        .background {
                            if isSelected {
                                Circle()
                                    .fill(activeCircle)
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
        .background {
            if style == .glass {
                glassBackground(Capsule())
            } else {
                Capsule().fill(UColor.navBackground)
            }
        }
        .clipShape(Capsule())
        .overlay {
            if style == .ink {
                Capsule().strokeBorder(UColor.navRing, lineWidth: 1)
            }
        }
        .modifier(UModalShadow(enabled: style == .ink, shadow: .float))
    }
}
