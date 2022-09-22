import SwiftUI

struct IdealSizeValue {
    var horizontal = false
    var vertical = false
}

struct IdealSizeKey: EnvironmentKey {
    static var defaultValue = IdealSizeValue()
}

extension EnvironmentValues {

    var idealSize: IdealSizeValue {
        get { self[IdealSizeKey.self] }
        set { self[IdealSizeKey.self] = newValue }
    }
}

public extension View {
    func idealSize(horizontal: Bool = false, vertical: Bool = false) -> some View {
        environment(\.idealSize, .init(horizontal: horizontal, vertical: vertical))
    }
    
    func idealSize() -> some View {
        idealSize(horizontal: true, vertical: true)
    }
}
