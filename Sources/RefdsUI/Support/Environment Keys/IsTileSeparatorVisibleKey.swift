import SwiftUI

public struct IsTileSeparatorVisibleKey: EnvironmentKey {
    public static var defaultValue: Bool = true
}

public extension EnvironmentValues {
    var isTileSeparatorVisible: Bool {
        get { self[IsTileSeparatorVisibleKey.self] }
        set { self[IsTileSeparatorVisibleKey.self] = newValue }
    }
}
