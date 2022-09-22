import SwiftUI

public struct IsFadeInKey: EnvironmentKey {
    public static var defaultValue: Bool = false
}

public extension EnvironmentValues {
    var isFadeIn: Bool {
        get { self[IsFadeInKey.self] }
        set { self[IsFadeInKey.self] = newValue }
    }
}
