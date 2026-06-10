import Foundation

/// 4px base scale (spacing.css).
public enum USpacing {
    public static let s1: CGFloat = 4
    public static let s2: CGFloat = 8
    public static let s3: CGFloat = 12
    public static let s4: CGFloat = 16
    public static let s5: CGFloat = 20
    public static let s6: CGFloat = 24
    public static let s8: CGFloat = 32
    public static let s10: CGFloat = 40
    public static let s12: CGFloat = 48
    /// Screen edge gutters.
    public static let gutter: CGFloat = 16
}

/// Corner radii — Ultimate is generously rounded.
public enum URadius {
    public static let xs: CGFloat = 8      // tiny tags
    public static let sm: CGFloat = 12     // small tiles, inner inputs
    public static let md: CGFloat = 16     // stat tiles, list groups
    public static let lg: CGFloat = 20     // cells, small cards, menus
    public static let xl: CGFloat = 28     // cards, promo blocks, dialogs
    public static let xxl: CGFloat = 36    // sheets, screen blocks, headers
    public static let pill: CGFloat = 999  // ALL controls
}

/// Control sizes & hit targets.
public enum USize {
    public static let controlSm: CGFloat = 36
    public static let controlMd: CGFloat = 48   // default button
    public static let controlLg: CGFloat = 56   // primary CTA, nav
    public static let tapMin: CGFloat = 44
    public static let borderHairline: CGFloat = 1
    public static let borderStrong: CGFloat = 1.5
}

/// Shared control size enum used by Button, IconButton.
public enum UControlSize: Sendable {
    case sm, md, lg
    public var height: CGFloat {
        switch self {
        case .sm: USize.controlSm
        case .md: USize.controlMd
        case .lg: USize.controlLg
        }
    }
}
