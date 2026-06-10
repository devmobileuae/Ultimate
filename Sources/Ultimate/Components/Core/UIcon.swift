import SwiftUI
import LucideIcons

/// Thin-line Lucide icon. Tints with the current foreground style.
/// Default 22pt — the system's standard inline icon size.
public struct UIcon: View {
    let name: String
    let size: CGFloat

    public init(_ name: String, size: CGFloat = 22) {
        self.name = name
        self.size = size
    }

    public var body: some View {
        if let image = UIImage(lucideId: name) {
            Image(uiImage: image)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        } else {
            // Unknown icon id: visible placeholder, not a crash.
            RoundedRectangle(cornerRadius: 4)
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [3]))
                .frame(width: size, height: size)
        }
    }
}
