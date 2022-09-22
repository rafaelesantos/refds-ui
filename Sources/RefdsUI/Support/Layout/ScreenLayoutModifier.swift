import SwiftUI

public enum ScreenLayoutPadding {
    case `default`
    case compact
    case custom(horizontal: CGFloat = .medium, top: CGFloat = .medium, bottom: CGFloat = .medium)

    public func horizontal(horizontalSizeClass: UserInterfaceSizeClass?) -> CGFloat {
        switch self {
            case .default:                      return `default`(horizontalSizeClass: horizontalSizeClass)
            case .compact:                      return .medium
            case .custom(let horizontal, _, _): return horizontal
        }
    }

    public func top(horizontalSizeClass: UserInterfaceSizeClass?) -> CGFloat {
        switch self {
            case .default:                      return `default`(horizontalSizeClass: horizontalSizeClass)
            case .compact:                      return .medium
            case .custom(_, let top, _):        return top
        }
    }

    public func bottom(horizontalSizeClass: UserInterfaceSizeClass?) -> CGFloat {
        switch self {
            case .default:                      return `default`(horizontalSizeClass: horizontalSizeClass)
            case .compact:                      return .medium
            case .custom(_, _, let bottom):     return bottom
        }
    }

    public func `default`(horizontalSizeClass: UserInterfaceSizeClass?) -> CGFloat {
        horizontalSizeClass == .regular
            ? .xxLarge
            : .medium
    }
}

struct ScreenLayoutModifier: ViewModifier {

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    let edges: Edge.Set
    let padding: ScreenLayoutPadding
    let maxContentWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .environment(\.screenLayoutPadding, padding)
            .padding(.top, edges.contains(.top) ? padding.top(horizontalSizeClass: horizontalSizeClass) : 0)
            .padding(.leading, edges.contains(.leading) ? padding.horizontal(horizontalSizeClass: horizontalSizeClass) : 0)
            .padding(.trailing, edges.contains(.trailing) ? padding.horizontal(horizontalSizeClass: horizontalSizeClass) : 0)
            .padding(.bottom, edges.contains(.bottom) ? padding.bottom(horizontalSizeClass: horizontalSizeClass) : 0)
            .frame(maxWidth: maxContentWidth)
            .frame(maxWidth: .infinity)
    }
}

public extension View {
    func screenLayout(
        _ edges: Edge.Set = .all,
        padding: ScreenLayoutPadding = .default,
        maxContentWidth: CGFloat = Layout.readableMaxWidth
    ) -> some View {
        modifier(
            ScreenLayoutModifier(
                edges: edges,
                padding: padding,
                maxContentWidth: maxContentWidth
            )
        )
    }
}

// MARK: - Previews
struct ScreenLayoutModifierPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            Group {
                fullDefault
                fullCompact
                fullCustom
                horizontal
                horizontalAndBottom
                noPaddingCustomWidth
                snapshot
            }
            .previewLayout(.sizeThatFits)

            ScrollView {
                snapshot
            }
        }
    }

    static var fullDefault: some View {
        Color.white
            .screenLayout()
            .background(Color.greenLight)
            .previewDisplayName("Full Default")
    }

    static var fullCompact: some View {
        Color.white
            .screenLayout(padding: .compact)
            .background(Color.greenLight)
            .previewDisplayName("Full Compact")
    }

    static var fullCustom: some View {
        Color.white
            .screenLayout(padding: .custom(horizontal: .xxSmall, top: .xxxLarge, bottom: .medium))
            .background(Color.greenLight)
            .previewDisplayName("Full Custom")
    }

    static var horizontal: some View {
        Color.white
            .screenLayout(.horizontal)
            .background(Color.greenLight)
            .previewDisplayName("Horizontal")
    }

    static var horizontalAndBottom: some View {
        Color.white
            .screenLayout([.horizontal, .bottom])
            .background(Color.greenLight)
            .previewDisplayName("Horizontal and Bottom")
    }

    static var noPaddingCustomWidth: some View {
        Color.white
            .screenLayout([], maxContentWidth: 200)
            .background(Color.greenLight)
            .previewDisplayName("No padding")
    }

    static var snapshot: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Alert(AlertPreviews.title, description: AlertPreviews.description, icon: .grid, buttons: AlertPreviews.primaryAndSecondaryConfiguration) {
                Illustration(.accommodation)
                    .padding(.horizontal, .xxLarge)
            }

            Text(TextPreviews.multilineFormattedText)

            Illustration(.accommodation)
                .padding(.horizontal, .xxLarge)

            Button("Button", icon: .grid)

            Card("Card title", description: "Card description", icon: .grid, action: .buttonLink("ButtonLink")) {
                TileGroup {
                    Tile("Tile 1")
                    Tile("Tile 2")
                }
                Tile("Tile 3")
                contentPlaceholder
            }

            TileGroup {
                Tile(TilePreviews.title, description: TilePreviews.description, icon: .grid)
                Tile(TilePreviews.title, description: TilePreviews.description, icon: .grid)
            }

            Tile(TilePreviews.title, description: TilePreviews.description, icon: .grid)

            Card("Card", contentLayout: .fill) {
                ListChoice(ListChoicePreviews.title, value: ListChoicePreviews.value)
                ListChoice(ListChoicePreviews.title, description: ListChoicePreviews.description)
            }
        }
        .screenLayout()
        .background(Color.screen)
    }
}
