import SwiftUI

/// One option in a ``UDropdown`` (Dropdown.d.ts `DropdownItem`).
public struct UDropdownOption: Identifiable, Sendable {
    /// Index-stable id assigned by ``UDropdown``.
    public let id: Int
    public let label: String
    public let icon: String?
    public let destructive: Bool

    public init(label: String, icon: String? = nil, destructive: Bool = false) {
        self.id = 0
        self.label = label
        self.icon = icon
        self.destructive = destructive
    }

    fileprivate init(id: Int, label: String, icon: String?, destructive: Bool) {
        self.id = id
        self.label = label
        self.icon = icon
        self.destructive = destructive
    }
}

private struct TriggerHeightKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

/// Dropdown (Dropdown.d.ts / `ult-dropdown` + `ult-menu`): a trigger that toggles
/// a floating rounded menu.
///
/// The menu is a `surfaceCard` card (radius `URadius.lg` = 20, `.float` shadow,
/// 6pt padding) of 48pt rows (radius `URadius.md` = 16) that wash with `pressWash`
/// on press; the selected row shows a trailing `check`; destructive rows render in
/// `UColor.danger` and wash with `dangerWash`. It floats 8pt below the trigger,
/// leading-aligned, and opens/closes with a 140ms ease-out opacity+scale(0.98,
/// anchor: .top) transition.
///
/// Outside-tap close: while open, a transparent full-bleed catcher is laid behind
/// the menu (expanded far past the component bounds) so a tap anywhere outside the
/// menu dismisses it; selecting a row or re-tapping the trigger also closes it.
///
/// IMPORTANT: the open menu escapes the component's bounds via `.zIndex(100)`.
/// Callers must NOT clip the ancestor that hosts a `UDropdown`.
public struct UDropdown<Trigger: View>: View {
    @Binding private var selection: Int
    private let options: [UDropdownOption]
    private let trigger: Trigger

    @State private var isOpen = false
    @State private var triggerHeight: CGFloat = 0

    public init(
        selection: Binding<Int>,
        options: [UDropdownOption],
        @ViewBuilder trigger: () -> Trigger
    ) {
        self._selection = selection
        self.options = options
        self.trigger = trigger()
    }

    private var indexedOptions: [UDropdownOption] {
        options.enumerated().map { index, o in
            UDropdownOption(id: index, label: o.label, icon: o.icon, destructive: o.destructive)
        }
    }

    public var body: some View {
        Button {
            withAnimation(UMotion.easeOut(UMotion.fast)) { isOpen.toggle() }
        } label: {
            trigger
        }
        .buttonStyle(.uPressable)
        .background(
            GeometryReader { geo in
                Color.clear.preference(key: TriggerHeightKey.self, value: geo.size.height)
            }
        )
        .onPreferenceChange(TriggerHeightKey.self) { triggerHeight = $0 }
        .background(alignment: .topLeading) {
            if isOpen {
                // Full-bleed outside-tap catcher behind the menu.
                Color.clear
                    .contentShape(Rectangle())
                    .frame(width: 4000, height: 4000)
                    .offset(x: -2000, y: -2000)
                    .onTapGesture {
                        withAnimation(UMotion.easeOut(UMotion.fast)) { isOpen = false }
                    }
            }
        }
        .overlay(alignment: .topLeading) {
            if isOpen {
                menu
                    .offset(y: triggerHeight + USpacing.s2)
                    .transition(.scale(scale: 0.98, anchor: .top).combined(with: .opacity))
                    .zIndex(100)
            }
        }
        .zIndex(isOpen ? 100 : 0)
    }

    private var menu: some View {
        VStack(spacing: 2) {
            ForEach(indexedOptions) { option in
                row(option)
            }
        }
        .padding(6)
        .frame(minWidth: 220, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: URadius.lg, style: .continuous)
                .fill(UColor.surfaceCard)
        )
        .uShadow(.float)
        .fixedSize(horizontal: false, vertical: true)
    }

    private func row(_ option: UDropdownOption) -> some View {
        let isSelected = option.id == selection
        let tint = option.destructive ? UColor.danger : UColor.textPrimary
        return Button {
            selection = option.id
            withAnimation(UMotion.easeOut(UMotion.fast)) { isOpen = false }
        } label: {
            HStack(spacing: USpacing.s3) {
                if let icon = option.icon {
                    UIcon(icon, size: 18)
                }
                Text(option.label)
                    .uText(.label)
                    .fontWeight(isSelected ? .semibold : .medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if isSelected {
                    UIcon("check", size: 18)
                }
            }
            .foregroundStyle(tint)
            .padding(.horizontal, USpacing.s3)
            .frame(minHeight: 48)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(RoundedRectangle(cornerRadius: URadius.md, style: .continuous))
        }
        .buttonStyle(RowPressStyle(destructive: option.destructive))
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}

/// Row press feedback: a `pressWash` (or `dangerWash`) fill inside a 16pt radius,
/// matching `ult-menu__item:active`.
private struct RowPressStyle: ButtonStyle {
    let destructive: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: URadius.md, style: .continuous)
                    .fill(configuration.isPressed
                          ? (destructive ? UColor.dangerWash : UColor.pressWash)
                          : Color.clear)
            )
            .animation(UMotion.easeOut(UMotion.fast), value: configuration.isPressed)
    }
}

public extension UDropdown where Trigger == _UDropdownDefaultTrigger {
    /// Convenience: a soft pill trigger showing the selected option's label and a
    /// trailing `chevron-down`.
    init(selection: Binding<Int>, options: [UDropdownOption]) {
        let label = options.indices.contains(selection.wrappedValue)
            ? options[selection.wrappedValue].label
            : "Select"
        self.init(selection: selection, options: options) {
            _UDropdownDefaultTrigger(label: label)
        }
    }
}

/// Default soft pill trigger for ``UDropdown``.
public struct _UDropdownDefaultTrigger: View {
    let label: String
    public var body: some View {
        HStack(spacing: USpacing.s2) {
            Text(label).uText(.label)
            UIcon("chevron-down", size: 16)
        }
        .foregroundStyle(UColor.textPrimary)
        .padding(.horizontal, USpacing.s4)
        .frame(height: USize.controlMd)
        .background(Capsule().fill(UColor.surfaceFill))
    }
}
