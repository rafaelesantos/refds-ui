import SwiftUI

struct PreviewWrapper<Content: View>: View {

    @ViewBuilder let content: Content

    var body: some View {
        content
    }

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
}
