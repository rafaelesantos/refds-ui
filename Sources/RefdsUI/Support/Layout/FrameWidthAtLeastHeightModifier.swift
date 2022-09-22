import SwiftUI

struct FrameWidthAtLeastHeightModifier: ViewModifier {

    @State var height: CGFloat = 0

    public func body(content: Content) -> some View {
        ZStack {
            Color.clear
                .frame(width: height, height: 1)

            ContentHeightReader(height: $height) {
                content
            }
        }
    }
}

extension View {
    func frameWidthAtLeastHeight() -> some View {
        modifier(
            FrameWidthAtLeastHeightModifier()
        )
    }
}

// MARK: - Previews
struct FrameWidthAtLeastHeightModifierModifierPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            Text("1")
                .frameWidthAtLeastHeight()

            Text("Label")
                .frameWidthAtLeastHeight()
        }
        .previewLayout(.sizeThatFits)
    }
}
