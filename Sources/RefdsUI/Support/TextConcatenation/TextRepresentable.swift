import SwiftUI

public protocol TextRepresentable {

    func swiftUIText(sizeCategory: ContentSizeCategory) -> SwiftUI.Text?
}
