import SwiftUI

public struct CardItem: View {
    private var viewModel: CardItemViewModel
    private var completion: ((CardItemViewModel) -> Void)?
    
    public init(viewModel: CardItemViewModel, completion: ((CardItemViewModel) -> Void)? = nil) {
        self.viewModel = viewModel
        self.completion = completion
    }
    
    public var body: some View {
        Tile {
            VStack(alignment: .leading, spacing: .small) {
                if let title = viewModel.title, !title.isEmpty {
                    self.title(title)
                }
                
                if let badges = viewModel.badges, !badges.isEmpty {
                    self.badges(badges)
                }
                
                if let tags = viewModel.tags, !tags.isEmpty {
                    self.tags(tags)
                }
                
                if let description = viewModel.description, !description.isEmpty {
                    self.description(description)
                }
            }
            .padding([.top, .leading, .trailing, .bottom], .medium)
        }
    }
    
    public func applyPadding() -> some View {
        self.padding([.leading, .trailing], .medium)
            .padding([.top, .bottom], .small)
    }
    
    private func title(_ title: String) -> some View {
        Heading(title, style: .title4)
    }
    
    private func badges(_ badges: [String]) -> some View {
        HorizontalScroll(itemWidth: .intrinsic, horizontalPadding: .medium) {
            ForEach(badges, id: \.self) { badge in
                Badge(badge, style: .custom(labelColor: .blueNormal, outlineColor: .blueLight, backgroundColor: .blueLight))
            }
        }
        .padding([.leading, .trailing], -.medium)
    }
    
    private func tags(_ tags: [String]) -> some View {
        HorizontalScroll(itemWidth: .intrinsic, horizontalPadding: .medium) {
            ForEach(tags, id: \.self) { tag in
                Tag(tag)
            }
        }
        .padding([.leading, .trailing], -.medium)
    }
    
    private func description(_ description: String) -> some View {
        Text(description, lineLimit: 3)
    }
}

struct CardItem_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            CardItem(viewModel: .init(title: "Any Title", description: "Any description here, because is just to test", badges: ["any-badge", "any-other"], style: .productBasicInfo))
                .applyPadding()
            
            CardItem(viewModel: .init(title: "Any Title", description: "Any description here, because is just to test", tags: ["any-tag", "any-tag"], style: .productBasicInfo))
                .applyPadding()
        }
    }
}
