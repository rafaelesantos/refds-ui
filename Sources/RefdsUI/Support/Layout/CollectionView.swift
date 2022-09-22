import SwiftUI

struct SizePreferenceKeyData: Equatable {
    var size: CGSize
    var id: AnyHashable
}

struct SizesPreferenceKey: PreferenceKey {
    typealias Value = [SizePreferenceKeyData]

    static var defaultValue: [SizePreferenceKeyData] = []

    static func reduce(value: inout [SizePreferenceKeyData], nextValue: () -> [SizePreferenceKeyData]) {
        value.append(contentsOf: nextValue())
    }
}

struct PropagatesSize<ID: Hashable, V: View>: View {
    var id: ID
    var content: V

    var body: some View {
        content
            .fixedSize()
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: SizesPreferenceKey.self,
                        value: [SizePreferenceKeyData(size: proxy.size, id: AnyHashable(self.id))]
                    )
                }
            )
    }
}

struct FlowLayout {
    let spacing: UIOffset
    let containerSize: CGSize

    init(containerSize: CGSize, spacing: UIOffset = UIOffset(horizontal: 10, vertical: 10)) {
        self.spacing = spacing
        self.containerSize = containerSize
        self.width = containerSize.width
    }

    var currentX: CGFloat = 0
    var currentY: CGFloat = 0
    var lineHeight: CGFloat = 0
    var width: CGFloat

    mutating func add(element size: CGSize) -> CGRect {
        if currentX + size.width > containerSize.width {
            currentX = 0
            width = max(width, size.width)
            currentY += lineHeight + spacing.vertical
        }
        defer {
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing.horizontal
        }
        return CGRect(origin: CGPoint(x: currentX, y: currentY), size: size)
    }

    var size: CGSize {
        CGSize(width: width, height: currentY + lineHeight)
    }
}

struct OverallHeightPreference: PreferenceKey {
    static var defaultValue: CGFloat = 10
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CollectionView<Data, Content>:
View where Data: RandomAccessCollection, Data.Index: Hashable, Data.Element: Identifiable, Content: View {

    @State private var sizes: [SizePreferenceKeyData] = []
    @State private var height: CGFloat = 10

    var data: Data
    var spacing: UIOffset
    var content: (Data.Index) -> Content

    func layout(size: CGSize) -> (items: [AnyHashable: CGSize], size: CGSize) {
        var flowLayout = FlowLayout(containerSize: size, spacing: spacing)
        var result: [AnyHashable: CGSize] = [:]
        for size in sizes {
            let rect = flowLayout.add(element: size.size)
            result[size.id] = CGSize(width: rect.origin.x, height: rect.origin.y)
        }
        return (result, flowLayout.size)
    }

    func withLayout(_ laidout: (items: [AnyHashable: CGSize], size: CGSize)) -> some View {
        ZStack(alignment: .topLeading) {
            ForEach(data.indices, id: \.self) { index in
                PropagatesSize(id: data[index].id, content: content(index))
                    .offset(laidout.items[AnyHashable(data[index].id)] ?? .zero)
            }
            .preference(key: OverallHeightPreference.self, value: laidout.size.height)
        }
        .onPreferenceChange(SizesPreferenceKey.self, perform: {
            sizes = $0
        })
        .onPreferenceChange(OverallHeightPreference.self, perform: { value in
            height = value
        })
    }

    var body: some View {
        if #available(iOS 14.0, *) {
            GeometryReader { proxy in
                withLayout(layout(size: proxy.size))
            }
            .frame(height: height)
        } else {
        
            GeometryReader { proxy in
                withLayout(layout(size: proxy.size))
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .topLeading)
            }
            .frame(height: height)
        }
    }
}
