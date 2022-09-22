import UIKit
import SwiftUI

var refdsUIFontNames: [Font.Weight: String] {
    var fonts = [Font.Weight: String]()
    
    if let iconsFontURL = Bundle.current.url(forResource: "Icons.ttf", withExtension: nil) {
        _ = Font.registerFont(at: iconsFontURL)
    }
    
    for case let (weight, url?) in Font.refdsUIFonts {
        guard let font = Font.registerFont(at: url) else { continue }
        fonts[weight] = font.postScriptName as String?
    }
    
    return fonts
}

public extension Font {
    static let refdsUIIconFontName = "orbit-icons"

    static var refdsUIFonts: [Font.Weight: URL?] = [
        .thin: Bundle.current.url(forResource: "Moderat-Thin.ttf", withExtension: nil),
        .light: Bundle.current.url(forResource: "Moderat-Light.ttf", withExtension: nil),
        .regular: Bundle.current.url(forResource: "Moderat-Regular.ttf", withExtension: nil),
        .medium: Bundle.current.url(forResource: "Moderat-Medium.ttf", withExtension: nil),
        .bold: Bundle.current.url(forResource: "Moderat-Bold.ttf", withExtension: nil),
        .black: Bundle.current.url(forResource: "Moderat-Black.ttf", withExtension: nil)
    ]

    static func refdsUI(size: CGFloat, scaledSize: CGFloat, weight: Weight = .regular, style: Font.TextStyle = .body) -> Font {

        if refdsUIFontNames.isEmpty {
            return nonScalingSystemFont(size: scaledSize, weight: weight)
        }

        guard let fontName = refdsUIFontNames[weight] else {
            assertionFailure("Unsupported font weight")
            return nonScalingSystemFont(size: scaledSize, weight: weight)
        }

        return customFont(fontName, size: size, style: style)
    }

    static func refdsUIIcon(size: CGFloat, style: Font.TextStyle = .body) -> Font {
        customFont(refdsUIIconFontName, size: size, style: style)
    }

    static func registerFont(at url: URL) -> CGFont? {

        guard let data = try? Data(contentsOf: url),
              let dataProvider = CGDataProvider(data: data as CFData),
              let font = CGFont(dataProvider)
        else {
            fatalError("Unable to load custom font from \(url)")
        }

        var error: Unmanaged<CFError>?
        if CTFontManagerRegisterGraphicsFont(font, &error) == false {
            print("Custom font registration error: \(String(describing: error))")
        }

        return font
    }

    private static func nonScalingSystemFont(size: CGFloat, weight: Font.Weight) -> Font {
        .system(size: size, weight: weight)
    }

    private static func customFont(_ name: String, size: CGFloat, style: Font.TextStyle = .body) -> Font {
        if #available(iOS 14.0, *) {
            return .custom(name, size: size, relativeTo: style)
        } else {
            return .custom(name, size: size)
        }
    }
}

extension Font.Weight {

    var uiKit: UIFont.Weight {
        switch self {
            case .regular:  return .regular
            case .bold:     return .bold
            case .medium:   return .medium
            default:        return .regular
        }
    }
}

public extension ContentSizeCategory {

    var ratio: CGFloat {
        switch self {
            case .extraSmall:                           return 0.8
            case .small:                                return 0.85
            case .medium:                               return 0.9
            case .large:                                return 1        
            case .extraLarge:                           return 1.1
            case .extraExtraLarge:                      return 1.2
            case .extraExtraExtraLarge:                 return 1.35
            case .accessibilityMedium:                  return 1.6
            case .accessibilityLarge:                   return 1.9
            case .accessibilityExtraLarge:              return 2.35
            case .accessibilityExtraExtraLarge:         return 2.75
            case .accessibilityExtraExtraExtraLarge:    return 3.1
            @unknown default:                           return 1
        }
    }

    var controlRatio: CGFloat {
        1 + (max(1, ratio) - 1) * 0.5
    }

    @available(iOS, deprecated: 15.0, message: "Use DynamicTypeSize.isAccessibilitySize instead from iOS 15.0")
    var isAccessibilitySize: Bool {
        ratio >= 1.6
    }
}
