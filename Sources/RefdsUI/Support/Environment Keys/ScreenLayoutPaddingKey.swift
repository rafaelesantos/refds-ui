import SwiftUI

public struct ScreenLayoutPaddingKey: EnvironmentKey {
    public static var defaultValue: ScreenLayoutPadding?
}

public extension EnvironmentValues {
    var screenLayoutPadding: ScreenLayoutPadding? {
        get { self[ScreenLayoutPaddingKey.self] }
        set { self[ScreenLayoutPaddingKey.self] = newValue }
    }
}
