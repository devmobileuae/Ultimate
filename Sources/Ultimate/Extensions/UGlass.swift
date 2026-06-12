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

/// Surface style for Ultimate's modal chrome (bottom sheet, dialog).
public enum UModalStyle: Sendable {
    /// Solid `surfaceCard` with the standard elevation shadow (default).
    case card
    /// Frosted glass — the content behind the scrim shimmers through.
    /// No shadow: glass floats by contrast.
    case glass
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

    /// Pins a faded frosted strip to a screen edge (status-bar/home areas
    /// included), so scrolling content dissolves under the system chrome —
    /// the modern "glass fade" edge treatment. Non-interactive; overlay it on
    /// the screen shell ABOVE the scroll view but below floating chrome.
    ///
    /// `height` is measured from the screen edge inclusive of the safe area;
    /// the frost is solid through the first ~55% and melts to clear after.
    func uEdgeFade(_ edge: VerticalEdge = .top, height: CGFloat = 96) -> some View {
        overlay(alignment: edge == .top ? .top : .bottom) {
            UGlassEdgeFade(edge: edge, height: height)
        }
    }
}

/// The faded frosted strip used by ``SwiftUICore/View/uEdgeFade(_:height:)``.
/// Exposed for custom placement (e.g. inside a `safeAreaInset`).
public struct UGlassEdgeFade: View {
    let edge: VerticalEdge
    let height: CGFloat

    public init(edge: VerticalEdge = .top, height: CGFloat = 96) {
        self.edge = edge
        self.height = height
    }

    public var body: some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .overlay(UColor.surfaceApp.opacity(0.3))
            .mask {
                LinearGradient(
                    stops: [
                        .init(color: .white, location: 0),
                        .init(color: .white, location: 0.55),
                        .init(color: .clear, location: 1),
                    ],
                    startPoint: edge == .top ? .top : .bottom,
                    endPoint: edge == .top ? .bottom : .top
                )
            }
            .frame(height: height)
            .ignoresSafeArea(edges: edge == .top ? .top : .bottom)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}
