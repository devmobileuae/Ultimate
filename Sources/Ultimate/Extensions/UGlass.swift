import SwiftUI

/// Shared glass building block: ultra-thin material, a faint card tint, a
/// hairline rim and a top highlight that reads as a machined edge catching
/// light. Generic over any ``InsettableShape`` so cards (rounded rect), buttons
/// (capsule) and icon buttons (circle) share one treatment.
@ViewBuilder
func glassBackground<S: InsettableShape>(_ shape: S) -> some View {
    shape
        .fill(.ultraThinMaterial)
        .overlay {
            shape.fill(UColor.surfaceCard.opacity(0.12))
        }
        .overlay {
            shape.strokeBorder(
                LinearGradient(
                    colors: [.white.opacity(0.45), .white.opacity(0.08)],
                    startPoint: .top, endPoint: .bottom),
                lineWidth: 1)
        }
}

/// Frosted glass surface: ultra-thin material, a faint card tint, a hairline
/// rim and a top highlight that reads as a machined edge catching light.
/// Designed for content sitting on colorful or photographic backdrops.
public struct UGlassModifier: ViewModifier {
    let radius: CGFloat

    public func body(content: Content) -> some View {
        content
            .background {
                glassBackground(RoundedRectangle(cornerRadius: radius, style: .continuous))
            }
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
}

public extension View {
    /// Ultimate's glass surface. Default radius matches cards (`URadius.xl`).
    func uGlass(radius: CGFloat = URadius.xl) -> some View {
        modifier(UGlassModifier(radius: radius))
    }
}
