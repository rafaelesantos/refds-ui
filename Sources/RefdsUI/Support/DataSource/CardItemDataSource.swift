import Foundation

public protocol CardItemDataSource {
    var cardItem: CardItemViewModel { get }
}

public struct CardItemViewModel: Codable {
    public var title: String?
    public var description: String?
    public var badges: [String]?
    public var tags: [String]?
    public var style: CardItemStyle
    
    public init(title: String? = nil, description: String? = nil, badges: [String]? = nil, tags: [String]? = nil, style: CardItemStyle) {
        self.title = title
        self.description = description
        self.badges = badges
        self.tags = tags
        self.style = style
    }
}

public enum CardItemStyle: Int, Codable {
    case productBasicInfo
}
