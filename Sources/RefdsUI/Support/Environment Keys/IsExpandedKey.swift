import SwiftUI

public struct IsExpandedKey: EnvironmentKey {
    public static var defaultValue: Bool = false
}

public extension EnvironmentValues {
    var isExpanded: Bool {
        get { self[IsExpandedKey.self] }
        set { self[IsExpandedKey.self] = newValue }
    }
}
