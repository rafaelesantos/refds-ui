import Foundation

public protocol CardItemDataSource {
    var cardItem: CardItemViewModel { get }
}

public struct CardItemViewModel: Codable {
    var title: String?
    var description: String?
    var badges: [String]?
    var tags: [String]?
    var style: CardItemStyle
}

public enum CardItemStyle: Int, Codable {
    case productBasicInfo
}
