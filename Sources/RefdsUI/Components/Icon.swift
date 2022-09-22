import SwiftUI

public struct Icon: View {

    public static let sfSymbolToRefdsUISizeRatio: CGFloat = 0.75
    public static let averageIconContentPadding: CGFloat = .xxxSmall

    @Environment(\.sizeCategory) var sizeCategory

    let content: Content
    let size: Size
    let baselineOffset: CGFloat

    public var body: some View {
        if content.isEmpty == false {
            iconContent
                .alignmentGuide(.firstTextBaseline) { dimensions in
                    iconContentBaselineOffset(height: dimensions.height)
                }
                .alignmentGuide(.lastTextBaseline) { dimensions in
                    iconContentBaselineOffset(height: dimensions.height)
                }
        }
    }

    @ViewBuilder var iconContent: some View {
        switch content {
            case .symbol(let symbol, let color?):
                SwiftUI.Text(verbatim: symbol.value)
                    .foregroundColor(color)
                    .font(.refdsUIIcon(size: size.value, style: size.textStyle))
                    .accessibility(label: SwiftUI.Text(String(describing: symbol)))
            case .symbol(let symbol, nil):
                SwiftUI.Text(verbatim: symbol.value)
                    // foregroundColor(nil) prevents further overrides
                    .font(.refdsUIIcon(size: size.value, style: size.textStyle))
                    .accessibility(label: SwiftUI.Text(String(describing: symbol)))
            case .image(let image, let mode):
                image
                    .resizable()
                    .aspectRatio(contentMode: mode)
                    .frame(width: size.value, height: size.value * sizeCategory.ratio)
                    .accessibility(hidden: true)
            case .countryFlag(let countryCode):
                CountryFlag(countryCode, size: size)
            case .sfSymbol(let systemName, let color?):
                Image(systemName: systemName)
                    .foregroundColor(color)
                    .font(.system(size: size.value * Self.sfSymbolToRefdsUISizeRatio * sizeCategory.ratio))
            case .sfSymbol(let systemName, nil):
                Image(systemName: systemName)
                    // foregroundColor(nil) prevents further overrides
                    .font(.system(size: size.value * Self.sfSymbolToRefdsUISizeRatio * sizeCategory.ratio))
        }
    }

    func iconContentBaselineOffset(height: CGFloat) -> CGFloat {
        baselineOffset + size.textBaselineAlignmentGuide(sizeCategory: sizeCategory, height: height)
    }
}

// MARK: - Inits
public extension Icon {
    
    init(content: Icon.Content, size: Size = .normal, baselineOffset: CGFloat = 0) {
        self.content = content
        self.size = size
        self.baselineOffset = baselineOffset
    }

    init(_ symbol: Icon.Symbol, size: Size = .normal, color: Color? = .inkNormal, baselineOffset: CGFloat = 0) {
        self.init(
            content: .symbol(symbol, color: color),
            size: size,
            baselineOffset: baselineOffset
        )
    }
    
    init(image: Image, size: Size = .normal, baselineOffset: CGFloat = 0) {
        self.init(
            content: .image(image),
            size: size,
            baselineOffset: baselineOffset
        )
    }
    
    init(countryCode: String, size: Size = .normal, baselineOffset: CGFloat = 0) {
        self.init(
            content: .countryFlag(countryCode),
            size: size,
            baselineOffset: baselineOffset
        )
    }
    
    init(sfSymbol: String, size: Size = .normal, color: Color? = .inkNormal, baselineOffset: CGFloat = 0) {
        self.init(
            content: .sfSymbol(sfSymbol, color: color),
            size: size,
            baselineOffset: baselineOffset
        )
    }
}

// MARK: - Types
public extension Icon {

    enum Content: Equatable {

        case symbol(Symbol, color: Color? = nil)

        case image(Image, mode: ContentMode = .fit)

        case countryFlag(String)

        case sfSymbol(String, color: Color? = nil)

        public var isEmpty: Bool {
            switch self {
                case .symbol(let symbol, _):            return symbol == .none
                case .image:                            return false
                case .countryFlag(let countryCode):     return countryCode.isEmpty
                case .sfSymbol(let sfSymbol, _):        return sfSymbol.isEmpty
            }
        }
    }

    enum Size: Equatable {

        case small

        case normal

        case large

        case xLarge

        case fontSize(CGFloat)

        case text(Text.Size)

        case heading(Heading.Style)

        case label(Label.Style)

        case custom(CGFloat)
        
        public var value: CGFloat {
            switch self {
                case .small:                            return 16
                case .normal:                           return 20
                case .large:                            return 24
                case .xLarge:                           return 28
                case .fontSize(let size):               return round(size * 1.31)
                case .text(let size):                   return size.iconSize
                case .heading(let style):               return style.iconSize
                case .label(let style):                 return style.iconSize
                case .custom(let size):                 return size
            }
        }

        public var textStyle: Font.TextStyle {
            switch self {
                case .small:                            return Text.Size.small.textStyle
                case .normal:                           return Text.Size.normal.textStyle
                case .large:                            return Text.Size.large.textStyle
                case .xLarge:                           return Text.Size.xLarge.textStyle
                case .fontSize:                         return .body
                case .text(let size):                   return size.textStyle
                case .heading(let style):               return style.textStyle
                case .label(let style):                 return style.textStyle
                case .custom:                           return .body
            }
        }
        
        public static func == (lhs: Icon.Size, rhs: Icon.Size) -> Bool {
            lhs.value == rhs.value
        }


        public var textLineHeight: CGFloat {
            switch self {
                case .small:                            return Text.Size.small.iconSize
                case .normal:                           return Text.Size.normal.iconSize
                case .large:                            return Text.Size.large.iconSize
                case .xLarge:                           return Text.Size.xLarge.iconSize
                case .fontSize(let size):               return round(size * 1.31)
                case .text(let size):                   return size.iconSize
                case .heading(let style):               return style.iconSize
                case .label(let style):                 return style.iconSize
                case .custom(let size):                 return size
            }
        }


        public func dynamicTextLineHeight(sizeCategory: ContentSizeCategory) -> CGFloat {
            round(textLineHeight * sizeCategory.ratio)
        }

        public func textBaselineAlignmentGuide(sizeCategory: ContentSizeCategory, height: CGFloat) -> CGFloat {
            round(dynamicTextLineHeight(sizeCategory: sizeCategory) * Text.firstBaselineRatio + height / 2)
        }

        public func baselineOffset(sizeCategory: ContentSizeCategory) -> CGFloat {
            round(dynamicTextLineHeight(sizeCategory: sizeCategory) * 0.2)
        }
    }
}

// MARK: - TextRepresentable
extension Icon: TextRepresentable {

    public func swiftUIText(sizeCategory: ContentSizeCategory) -> SwiftUI.Text? {
        if content.isEmpty { return nil }

        if #available(iOS 14.0, *) {
            return text(sizeCategory: sizeCategory)
        } else {
            return textFallback(sizeCategory: sizeCategory)
        }
    }

    @available(iOS 14.0, *)
    func text(sizeCategory: ContentSizeCategory) -> SwiftUI.Text {
        switch content {
            case .symbol(let symbol, let color?):
                return SwiftUI.Text(verbatim: symbol.value)
                    .baselineOffset(textBaselineOffset)
                    .foregroundColor(color)
                    .font(.refdsUIIcon(size: size.value, style: size.textStyle))
            case .symbol(let symbol, nil):
                return SwiftUI.Text(verbatim: symbol.value)
                    .baselineOffset(textBaselineOffset)
                    // foregroundColor(nil) prevents further overrides
                    .font(.refdsUIIcon(size: size.value, style: size.textStyle))
            case .image(let image, _):
                return SwiftUI.Text(image.resizable())
                    .baselineOffset(baselineOffset)
            case .countryFlag(let countryCode):
                return SwiftUI.Text(SwiftUI.Image(countryCode, bundle: .current).resizable())
                    .baselineOffset(baselineOffset)
            case .sfSymbol(let systemName, let color?):
                return SwiftUI.Text(Image(systemName: systemName)).foregroundColor(color)
                    .baselineOffset(baselineOffset)
                    .font(.system(size: size.value * Self.sfSymbolToRefdsUISizeRatio * sizeCategory.ratio))
            case .sfSymbol(let systemName, nil):
                return SwiftUI.Text(Image(systemName: systemName))
                    .baselineOffset(baselineOffset)
                    .font(.system(size: size.value * Self.sfSymbolToRefdsUISizeRatio * sizeCategory.ratio))
        }
    }

    func textFallback(sizeCategory: ContentSizeCategory) -> SwiftUI.Text? {
        switch content {
            case .symbol(let symbol, let color?):
                return SwiftUI.Text(verbatim: symbol.value)
                    .baselineOffset(textBaselineOffset)
                    .foregroundColor(color)
                    .font(.refdsUIIcon(size: size.value, style: size.textStyle))
            case .symbol(let symbol, nil):
                return SwiftUI.Text(verbatim: symbol.value)
                    .baselineOffset(textBaselineOffset)
                    // foregroundColor(nil) prevents further overrides
                    .font(.refdsUIIcon(size: size.value, style: size.textStyle))
            case .image, .countryFlag, .sfSymbol:
                assertionFailure(".image, .countryFlag, .sfSymbol as Text are only available in iOS 14.0 or newer")
                return nil
        }
    }

    var textBaselineOffset: CGFloat {
        baselineOffset - size.baselineOffset(sizeCategory: sizeCategory)
    }
}

// MARK: - Previews
struct IconPreviews: PreviewProvider {

    static let multilineText = "Multiline\nlong\ntext"
    static let sfSymbol = "info.circle.fill"
    
    static var previews: some View {
        PreviewWrapper {
            standalone
            snapshotSizes
            snapshotSizesText
            snapshotSizesLabelText
            snapshotSizesHeading
            snapshotSizesLabelHeading
            alignments
            baseline
            storybookMix
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        Icon(.informationCircle)
    }
    
    static var storybook: some View {
        VStack(alignment: .leading, spacing: .medium) {
            snapshotSizes
            snapshotSizesText
            snapshotSizesHeading
            alignments
        }
    }
    
    static var snapshotSizes: some View {
        VStack(alignment: .leading, spacing: .small) {
            HStack(spacing: .xSmall) {
                Text("16", color: .custom(.redNormal))
            
                HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                    Icon(.passengers, size: .small)
                    Text("Small text and icon size", size: .small)
                }
                .overlay(Separator(thickness: .hairline), alignment: .top)
                .overlay(Separator(thickness: .hairline), alignment: .bottom)
            }
            HStack(spacing: .xSmall) {
                Text("20", color: .custom(.orangeNormal))
            
                HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                    Icon(.passengers, size: .normal)
                    Text("Normal text and icon size", size: .normal)
                }
                .overlay(Separator(thickness: .hairline), alignment: .top)
                .overlay(Separator(thickness: .hairline), alignment: .bottom)
            }
            HStack(spacing: .xSmall) {
                Text("24", color: .custom(.greenNormal))
            
                HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                    Icon(.passengers, size: .large)
                    Text("Large text and icon size", size: .large)
                }
                .overlay(Separator(thickness: .hairline), alignment: .top)
                .overlay(Separator(thickness: .hairline), alignment: .bottom)
            }
        }
    }
    
    static func headingStack(_ style: Heading.Style) -> some View {
        HStack(spacing: .xSmall) {
            HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                Icon(.passengers, size: .heading(style))
                Heading("Heading", style: style)
            }
            .overlay(Separator(thickness: .hairline), alignment: .top)
            .overlay(Separator(thickness: .hairline), alignment: .bottom)
        }
    }
    
    static func labelHeadingStack(_ style: Heading.Style) -> some View {
        HStack(spacing: .xSmall) {
            Label("Label Heading", icon: .passengers, style: .heading(style))
                .overlay(Separator(thickness: .hairline), alignment: .top)
                .overlay(Separator(thickness: .hairline), alignment: .bottom)
        }
    }
    
    static func labelTextStack(_ size: Text.Size) -> some View {
        HStack(spacing: .xSmall) {
            Label("Label Text", icon: .passengers, style: .text(size))
                .overlay(Separator(), alignment: .top)
                .overlay(Separator(), alignment: .bottom)
        }
    }
    
    static func textStack(_ size: Text.Size) -> some View {
        HStack(spacing: .xSmall) {
            HStack(alignment: .firstTextBaseline, spacing: .xxSmall) {
                Icon(.passengers, size: .text(size))
                Text("Text", size: size)
            }
            .overlay(Separator(), alignment: .top)
            .overlay(Separator(), alignment: .bottom)
        }
    }
    
    static var snapshotSizesText: some View {
        VStack(alignment: .leading, spacing: .small) {
            textStack(.small)
            textStack(.normal)
            textStack(.large)
            textStack(.xLarge)
            textStack(.custom(50))
        }
        .previewDisplayName("Calculated sizes for Text")
    }
    
    static var snapshotSizesLabelText: some View {
        VStack(alignment: .leading, spacing: .small) {
            labelTextStack(.small)
            labelTextStack(.normal)
            labelTextStack(.large)
            labelTextStack(.xLarge)
            labelTextStack(.custom(50))
        }
        .previewDisplayName("Calculated sizes for Text in Label")
    }
    
    static var snapshotSizesHeading: some View {
        VStack(alignment: .leading, spacing: .small) {
            headingStack(.title6)
            headingStack(.title5)
            headingStack(.title4)
            headingStack(.title3)
            headingStack(.title2)
            headingStack(.title1)
            headingStack(.displaySubtitle)
            headingStack(.display)
        }
        .previewDisplayName("Calculated sizes for Heading")
    }
    
    static var snapshotSizesLabelHeading: some View {
        VStack(alignment: .leading, spacing: .small) {
            labelHeadingStack(.title6)
            labelHeadingStack(.title5)
            labelHeadingStack(.title4)
            labelHeadingStack(.title3)
            labelHeadingStack(.title2)
            labelHeadingStack(.title1)
            labelHeadingStack(.displaySubtitle)
            labelHeadingStack(.display)
        }
        .previewDisplayName("Calculated sizes for Heading in Label")
    }

    static var storybookMix: some View {
        VStack(alignment: .leading, spacing: .small) {
            Text("SF Symbol vs RefdsUI sizes (custom-font-label)", size: .small)
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Group {
                    Icon(sfSymbol: sfSymbol, size: .custom(Text.Size.xLarge.iconSize), color: nil)
                    Icon(sfSymbol: sfSymbol, size: .fontSize(Text.Size.xLarge.value), color: nil)
                    Icon(sfSymbol: sfSymbol, size: .label(.text(.xLarge)), color: nil)
                    Color.clear.frame(width: .xSmall, height: 1)
                    Icon(.informationCircle, size: .custom(Text.Size.xLarge.iconSize), color: nil)
                    Icon(.informationCircle, size: .fontSize(Text.Size.xLarge.value), color: nil)
                    Icon(.informationCircle, size: .label(.text(.xLarge)), color: nil)
                    Color.clear.frame(width: .xSmall, height: 1)
                    Text("XLarge", size: .xLarge, color: nil)
                }
                .foregroundColor(.blueNormal)
                .border(Color.cloudLightActive, width: .hairline)
            }
            .background(Separator(thickness: .hairline), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))
            
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Group {
                    Icon(sfSymbol: sfSymbol, size: .custom(Text.Size.small.iconSize), color: nil)
                    Icon(sfSymbol: sfSymbol, size: .fontSize(Text.Size.small.value), color: nil)
                    Icon(sfSymbol: sfSymbol, size: .label(.text(.small)), color: nil)
                    Color.clear.frame(width: .xSmall, height: 1)
                    Icon(.informationCircle, size: .custom(Text.Size.small.iconSize), color: nil)
                    Icon(.informationCircle, size: .fontSize(Text.Size.small.value), color: nil)
                    Icon(.informationCircle, size: .label(.text(.small)), color: nil)
                    Color.clear.frame(width: .xSmall, height: 1)
                    Text("Small", size: .small, color: nil)
                }
                .foregroundColor(.blueNormal)
                .border(Color.cloudLightActive, width: .hairline)
            }
            .background(Separator(thickness: .hairline), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))

            Text("Flag - Image - SF Symbol sizes", size: .small)
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Group {
                    Icon(countryCode: "cz", size: .xLarge)
                    Icon(image: .refdsUI(.facebook), size: .xLarge)
                    Icon(sfSymbol: sfSymbol, size: .xLarge, color: nil)
                    Text("Text", size: .custom(20), color: nil)
                }
                .foregroundColor(.blueNormal)
                .border(Color.cloudLightActive, width: .hairline)
            }
            .background(Separator(thickness: .hairline), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))

            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Group {
                    Icon(countryCode: "cz", size: .small)
                    Icon(image: .refdsUI(.facebook), size: .small)
                    Icon(sfSymbol: sfSymbol, size: .small, color: nil)
                    Text("Text", size: .small, color: nil)
                }
                .foregroundColor(.blueNormal)
                .border(Color.cloudLightActive, width: .hairline)
            }
            .background(Separator(thickness: .hairline), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))

            Text("Baseline alignment", size: .small)
            HStack(alignment: .firstTextBaseline) {
                Group {
                    Text("O", size: .custom(30))
                    Icon(.informationCircle, size: .fontSize(30))
                    Icon(.informationCircle, size: .fontSize(8))
                    Text("O", size: .custom(8))
                    Text("Text", size: .normal)
                }
                .border(Color.cloudLightActive, width: .hairline)
            }
            .background(Separator(thickness: .hairline), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))

            Text("Icon color override", size: .small)
            HStack(alignment: .firstTextBaseline) {
                Icon(content: .grid, size: .xLarge)
                Icon(content: .symbol(.grid, color: nil))
                Icon(content: .symbol(.grid, color: .redNormal), size: .text(.small))
                Text("Text", size: .small, color: nil)
            }
            .foregroundColor(.blueDark)
            .background(Separator(thickness: .hairline), alignment: .init(horizontal: .center, vertical: .firstTextBaseline))
        }
    }

    static var alignments: some View {
        VStack(spacing: .medium) {
            HStack(spacing: .medium) {
                HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
                    Icon(.grid)
                    Text(multilineText)
                }
                HStack(alignment: .lastTextBaseline, spacing: .xSmall) {
                    Icon(.grid)
                    Text(multilineText)
                }
            }
            Label("Multiline\nlong\nLabel", icon: .grid, style: .text())
        }
    }

    static var baseline: some View {
        VStack(alignment: .leading, spacing: .large) {
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text("Standalone")

                Group {
                    Icon(sfSymbol: sfSymbol, size: .small, baselineOffset: 0)
                    Icon(sfSymbol: sfSymbol, size: .small, baselineOffset: .xxxSmall)
                    Icon(sfSymbol: sfSymbol, size: .small, baselineOffset: -.xxxSmall)

                    Icon(.flightReturn, size: .small, baselineOffset: 0)
                    Icon(.flightReturn, size: .small, baselineOffset: .xxxSmall)
                    Icon(.flightReturn, size: .small, baselineOffset: -.xxxSmall)

                    Icon(countryCode: "us", size: .small, baselineOffset: 0)
                    Icon(countryCode: "us", size: .small, baselineOffset: .xxxSmall)
                    Icon(countryCode: "us", size: .small, baselineOffset: -.xxxSmall)
                }
                .border(Color.cloudLightActive, width: .hairline)
            }

            Text("Concatenated")
                + Icon(sfSymbol: sfSymbol, size: .small, baselineOffset: 0)
                + Icon(sfSymbol: sfSymbol, size: .small, baselineOffset: .xxxSmall)
                + Icon(sfSymbol: sfSymbol, size: .small, baselineOffset: -.xxxSmall)
                + Icon(.flightReturn, size: .small, baselineOffset: 0)
                + Icon(.flightReturn, size: .small, baselineOffset: .xxxSmall)
                + Icon(.flightReturn, size: .small, baselineOffset: -.xxxSmall)
        }
    }

    static var snapshot: some View {
        VStack(spacing: .medium) {
            IconPreviews.snapshotSizes
            Separator()
            IconPreviews.storybookMix
        }
        .padding(.medium)
    }
}

struct IconDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")
            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .padding(.medium)
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        IconPreviews.snapshotSizes
        IconPreviews.storybookMix
    }
}
