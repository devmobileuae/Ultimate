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
                        .gesture(
                            DragGesture(minimumDistance: 10)
                                .onChanged { value in
                                    let t = value.translation.height
                                    dragOffset = t < 0 ? t * 0.2 : t
                                }
                                .onEnded { value in
                                    let translation = value.translation.height
                                    let predicted = value.predictedEndTranslation.height
                                    if translation > 120 || predicted > 240 {
                                        dismiss()
                                    } else {
                                        withAnimation(UMotion.spring()) {
                                            dragOffset = 0
                                        }
                                    }
                                }
                        )
                }
            }
            .animation(UMotion.easeOut(UMotion.slow), value: isPresented)
            .onChange(of: isPresented) { _, newValue in
                if newValue { dragOffset = 0 }
            }
        }
    }

    private var sheetCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Drag indicator / grabber
            Capsule()
                .fill(UColor.borderHairline)
                .frame(width: 36, height: 5)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 8)
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
