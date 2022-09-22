import CoreGraphics
import UIKit

public enum BorderWidth {
    public static let hairline: CGFloat = 1.0 / UIScreen.main.scale
    public static let thin: CGFloat = UIScreen.main.scale > 2 ? 0.66 : 1
    public static let emphasis: CGFloat = 1.5
    public static let selection: CGFloat = 2.0
}

public extension CGFloat {
    static let hairline: CGFloat = BorderWidth.hairline
}
