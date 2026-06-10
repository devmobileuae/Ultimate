import SwiftUI

public extension View {
    /// Transient pill toast (`ult-toast` / Toast.d.ts): a `surfaceInverse`
    /// capsule (ink in light, white in dark) with `textOnInverse` content, an
    /// optional leading icon, and a float shadow. Min height 52, padding 12×20.
    ///
    /// Pinned bottom-center above the home indicator; slides in/out from the
    /// bottom and auto-dismisses after `duration`.
    func uToast(
        isPresented: Binding<Bool>,
        icon: String? = nil,
        message: String,
        duration: TimeInterval = 2.5
    ) -> some View {
        modifier(UToastModifier(
            isPresented: isPresented,
            icon: icon,
            message: message,
            duration: duration
        ))
    }
}

private struct UToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let icon: String?
    let message: String
    let duration: TimeInterval

    func body(content: Content) -> some View {
        content.overlay(alignment: .bottom) {
            ZStack {
                if isPresented {
                    toast
                        .padding(.bottom, USpacing.s6)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .task(id: isPresented) {
                            // Guard the already-false case; sleep then auto-dismiss.
                            guard isPresented else { return }
                            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                            guard !Task.isCancelled, isPresented else { return }
                            withAnimation(UMotion.easeOut(UMotion.slow)) { isPresented = false }
                        }
                }
            }
            .animation(UMotion.easeOut(UMotion.slow), value: isPresented)
        }
    }

    private var toast: some View {
        HStack(spacing: USpacing.s3) {
            if let icon {
                UIcon(icon, size: 18)
            }
            Text(message)
                .uText(.label)
        }
        .foregroundStyle(UColor.textOnInverse)
        .padding(.vertical, USpacing.s3)
        .padding(.horizontal, USpacing.s5)
        .frame(minHeight: 52)
        .background(Capsule().fill(UColor.surfaceInverse))
        .uShadow(.float)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(message)
        .accessibilityAddTraits(.isStaticText)
    }
}
