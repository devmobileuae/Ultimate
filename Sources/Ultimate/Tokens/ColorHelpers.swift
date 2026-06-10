import SwiftUI
import UIKit

extension UIColor {
    convenience init(rgb: UInt32, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255,
            green: CGFloat((rgb >> 8) & 0xFF) / 255,
            blue: CGFloat(rgb & 0xFF) / 255,
            alpha: alpha
        )
    }
}

extension Color {
    /// Static color from hex.
    init(rgb: UInt32, alpha: CGFloat = 1) {
        self.init(uiColor: UIColor(rgb: rgb, alpha: alpha))
    }
    /// Dynamic color resolving per color scheme (supports subtree
    /// `.environment(\.colorScheme, .dark)` scoping, e.g. one dark screen).
    init(light: UIColor, dark: UIColor) {
        self.init(uiColor: UIColor { trait in
            trait.userInterfaceStyle == .dark ? dark : light
        })
    }
    init(light: UInt32, dark: UInt32, lightAlpha: CGFloat = 1, darkAlpha: CGFloat = 1) {
        self.init(light: UIColor(rgb: light, alpha: lightAlpha),
                  dark: UIColor(rgb: dark, alpha: darkAlpha))
    }
}
