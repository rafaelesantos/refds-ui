import UIKit
import SwiftUI

public extension Image {
    enum Symbol: CaseIterable, AssetNameProviding {

        case apple
        case facebook
        case google

        case logoKiwiComSymbol
        case logoKiwiComFull

        case navigateBack
        case navigateClose
    }

    static func refdsUI(_ image: Symbol) -> Image {
        Image(image.assetName, bundle: .current)
    }
}

public extension UIImage {
    static func image(_ image: AssetNameProviding) -> UIImage {
        guard let uiImage = UIImage(named: image.assetName, in: Bundle.current, compatibleWith: nil) else {
            assertionFailure("Cannot find image \(image.assetName) in bundle")
            return UIImage()
        }

        return uiImage
    }
    
    static func refdsUI(image: Image.Symbol) -> UIImage {
        Self.image(image)
    }

    static func refdsUI(illustration: Illustration.Image) -> UIImage {
        image(illustration)
    }
}
