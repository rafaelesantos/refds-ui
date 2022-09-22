import SwiftUI

struct RefdsUIFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory

    let size: CGFloat
    var weight: Font.Weight = .regular
    var style: Font.TextStyle = .body

    func body(content: Content) -> some View {
        let scaledSize = sizeCategory.ratio * size
        return content.font(.refdsUI(size: size, scaledSize: scaledSize, weight: weight, style: style))
    }
}

public extension View {
    func refdsUIFont(size: CGFloat, weight: Font.Weight = .regular, style: Font.TextStyle = .body) -> some View {
        return self.modifier(RefdsUIFont(size: size, weight: weight, style: style))
    }
}

public extension SwiftUI.Text {
    func refdsUIFont(
        size: CGFloat,
        weight: Font.Weight = .regular,
        style: Font.TextStyle = .body,
        sizeCategory: ContentSizeCategory
    ) -> SwiftUI.Text {
        let scaledSize = sizeCategory.ratio * size

        return self.font(.refdsUI(size: size, scaledSize: scaledSize, weight: weight, style: style))
    }
}
