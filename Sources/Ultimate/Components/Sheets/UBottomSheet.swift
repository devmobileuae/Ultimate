import SwiftUI

public extension View {
    /// Floating action sheet (`ult-sheet` / BottomSheet.d.ts): inset 12pt from
    /// ALL edges, radius xxl 36, 20pt padding, sheet shadow. The header is a
    /// title (20/700) with an optional subtitle on the left and a 36pt soft X
    /// circle on the right; 16pt to the body, which stacks at 8pt (the caller
    /// includes any full-width CTA last).
    ///
    /// Scrim tap and the X both dismiss; both directions animate via the
    /// `isPresented`-driven transition (`easeOut(slow)`).
    func uBottomSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        title: String,
        subtitle: String? = nil,
        style: UModalStyle = .card,
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        modifier(UBottomSheetModifier(
            isPresented: isPresented,
            title: title,
            subtitle: subtitle,
            style: style,
            sheetContent: content
        ))
    }
}

private struct UBottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let subtitle: String?
    let style: UModalStyle
    @ViewBuilder let sheetContent: () -> SheetContent

    @State private var dragOffset: CGFloat = 0
    /// Per-gesture decision: nil = undecided, true = this touch is a sheet-drag,
    /// false = locked out (the first movement went sideways → a control owns it).
    @State private var dragIsSheet: Bool? = nil

    private func dismiss() {
        withAnimation(UMotion.easeOut(UMotion.slow)) { isPresented = false }
    }

    func body(content: Content) -> some View {
        content.overlay {
            ZStack(alignment: .bottom) {
                if isPresented {
                    UColor.scrim
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture { dismiss() }
                        .accessibilityAddTraits(.isButton)
                        .accessibilityLabel("Dismiss")

                    sheetCard
                        .padding(USpacing.s3)  // 12pt inset from all edges
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .offset(y: dragOffset)
                        // Whole-card drag-to-dismiss. `simultaneousGesture` lets the
                        // buttons/sliders/chips inside keep recognizing taps — a tap
                        // (no movement) never trips the 20pt minimum, so it goes to
                        // the control; only a real vertical drag moves the sheet.
                        .simultaneousGesture(dragGesture)
                }
            }
            .animation(UMotion.easeOut(UMotion.slow), value: isPresented)
            .onChange(of: isPresented) { _, newValue in
                if newValue { dragOffset = 0; dragIsSheet = nil }
            }
        }
    }

    /// Whole-card drag-to-dismiss, attached via `simultaneousGesture` so it never
    /// blocks taps on the body's controls. The direction is decided ONCE, on the
    /// first movement of each touch: if that first movement is vertical-dominant
    /// it's a sheet-drag; otherwise (a horizontal control drag like a slider) the
    /// sheet is locked out for the rest of that touch — even if the finger later
    /// moves down. So a control interaction never turns into a sheet swipe.
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 12)
            .onChanged { value in
                if dragIsSheet == nil {
                    dragIsSheet = abs(value.translation.height) > abs(value.translation.width)
                }
                guard dragIsSheet == true else { return }
                let t = value.translation.height
                dragOffset = t < 0 ? t * 0.2 : t
            }
            .onEnded { value in
                let wasSheetDrag = dragIsSheet == true
                dragIsSheet = nil
                guard wasSheetDrag else { return }
                if value.translation.height > 120 || value.predictedEndTranslation.height > 240 {
                    dismiss()
                } else {
                    withAnimation(UMotion.spring()) { dragOffset = 0 }
                }
            }
    }

    private var sheetCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Grabber — purely visual; the whole card is the drag surface.
            Capsule()
                .fill(UColor.borderHairline)
                .frame(width: 36, height: 5)
                .frame(maxWidth: .infinity)
                .padding(.top, 2)
                .padding(.bottom, 12)
                .accessibilityHidden(true)

            HStack(alignment: .top, spacing: USpacing.s3) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .uText(.title3)
                        .font(UFont.custom("Bold", size: 20))  // CSS sheet title is 20/700
                    if let subtitle {
                        Text(subtitle)
                            .uText(.label)
                            .foregroundStyle(UColor.textSecondary)
                    }
                }
                Spacer(minLength: 0)
                UIconButton(
                    "x",
                    variant: .soft,
                    size: .sm,
                    accessibilityLabel: "Close",
                    action: dismiss
                )
            }
            .frame(minHeight: 36, alignment: .top)
            .padding(.bottom, USpacing.s4)

            VStack(alignment: .leading, spacing: USpacing.s2) {
                sheetContent()
            }
        }
        .padding(USpacing.s5)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            let shape = RoundedRectangle(cornerRadius: URadius.xxl, style: .continuous)
            if style == .glass {
                glassBackground(shape)
            } else {
                shape.fill(UColor.surfaceCard)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: URadius.xxl, style: .continuous))
        .modifier(UModalShadow(enabled: style == .card, shadow: .sheet))
        .accessibilityAddTraits(.isModal)
    }
}

/// Shadow only for solid modal chrome — glass floats by contrast.
struct UModalShadow: ViewModifier {
    let enabled: Bool
    let shadow: UShadow
    func body(content: Content) -> some View {
        if enabled { content.uShadow(shadow) } else { content }
    }
}
