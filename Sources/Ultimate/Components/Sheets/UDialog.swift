import SwiftUI

public extension View {
    /// Centered confirm dialog (`ult-dialog` / Dialog.d.ts): a 320pt-max card,
    /// radius xl 28, centered text, with stacked pill actions — primary
    /// (`UButton .primary`, block) over cancel (`.ghost`, block).
    ///
    /// Scrim tap and Cancel both dismiss; the card scales in/out (0.96 + opacity)
    /// via the `isPresented`-driven transition (`easeOut(base)`).
    func uDialog(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        primaryLabel: String,
        primaryAction: @escaping () -> Void,
        cancelLabel: String = "Cancel"
    ) -> some View {
        modifier(UDialogModifier(
            isPresented: isPresented,
            title: title,
            message: message,
            primaryLabel: primaryLabel,
            primaryAction: primaryAction,
            cancelLabel: cancelLabel
        ))
    }
}

private struct UDialogModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String?
    let primaryLabel: String
    let primaryAction: () -> Void
    let cancelLabel: String

    private func dismiss() {
        withAnimation(UMotion.easeOut(UMotion.base)) { isPresented = false }
    }

    func body(content: Content) -> some View {
        content.overlay {
            ZStack {
                if isPresented {
                    UColor.scrim
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture { dismiss() }
                        .accessibilityAddTraits(.isButton)
                        .accessibilityLabel("Dismiss")

                    dialogCard
                        .padding(USpacing.s6)
                        .transition(.scale(scale: 0.96).combined(with: .opacity))
                }
            }
            .animation(UMotion.easeOut(UMotion.base), value: isPresented)
        }
    }

    private var dialogCard: some View {
        VStack(spacing: USpacing.s2) {
            Text(title)
                .uText(.title3)
                .multilineTextAlignment(.center)
            if let message {
                Text(message)
                    .uText(.body)
                    .foregroundStyle(UColor.textSecondary)
                    .multilineTextAlignment(.center)
            }
            VStack(spacing: USpacing.s2) {
                UButton(primaryLabel, variant: .primary, block: true) {
                    primaryAction()
                    dismiss()
                }
                UButton(cancelLabel, variant: .ghost, block: true) {
                    dismiss()
                }
            }
            .padding(.top, USpacing.s2)
        }
        .frame(maxWidth: 320)
        .padding(.top, USpacing.s6)
        .padding(.horizontal, USpacing.s5)
        .padding(.bottom, USpacing.s5)
        .background(
            RoundedRectangle(cornerRadius: URadius.xl, style: .continuous)
                .fill(UColor.surfaceCard)
        )
        .uShadow(.float)
        .accessibilityAddTraits(.isModal)
    }
}
