import SwiftUI

public struct IsElevationEnabledKey: EnvironmentKey {
    public static var defaultValue: Bool = true
}

public extension EnvironmentValues {
    var isElevationEnabled: Bool {
        get { self[IsElevationEnabledKey.self] }
        set { self[IsElevationEnabledKey.self] = newValue }
    }
}
