import SwiftUI

public struct TabBarItemModel: Identifiable {
    public var id: UUID = UUID()
    public var name: String
    public var icon: Icon.Symbol
    public var color: Color
    public var selection: Int
    
    public init(name: String, icon: Icon.Symbol, color: Color, selection: Int) {
        self.name = name
        self.icon = icon
        self.color = color
        self.selection = selection
    }
}

public struct TabBar: View {
    @Environment(\.colorScheme) var colorScheme
    @State var color: Color = .whiteDarker
    @State var selectedX: CGFloat = 0
    @State var x: [CGFloat] = [0, 0, 0, 0]
    
    public var tab: TabBarItemModel?
    public var tabs: [TabBarItemModel] = []
    private var completion: ((Int) -> Void)?
    
    @State private var selectedIndex: Int = 0 {
        didSet { completion?(selectedIndex) }
    }
    
    public init(tab: TabBarItemModel, tabs: [TabBarItemModel], selectedIndex: Int, completion: @escaping (Int) -> Void) {
        self.tab = tab
        self.tabs = tabs
        self.selectedIndex = selectedIndex
        self.completion = completion
    }
    
    public var body: some View {
        GeometryReader { proxy in
            HStack {
                content
            }
            .padding(.bottom, 15)
            .frame(maxWidth: .infinity, maxHeight: 96)
            .background(Color.whiteDarker)
            .overlay(
                Rectangle()
                    .fill(color)
                    .frame(width: 44, height: 5)
                    .cornerRadius(3)
                    .frame(width: 88)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .offset(x: selectedX)
            )
            .backgroundStyle(cornerRadius: BorderRadius.large)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .edgesIgnoringSafeArea(.bottom)
            .shadow(color: colorScheme == .light ? .gray.opacity(0.5) : .clear, radius: .xxxSmall)
        }
        .onAppear {
            guard let tabColor = tabs.first?.color else { return }
            color = tabColor
        }
    }
    
    var content: some View {
        ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
            if index == 0 { Spacer() }
            SwiftUI.Button(action: {
                selectedIndex = index
                withAnimation(.spring()) {
                    selectedX = x[index]
                    color = tab.color
                }
            }, label: {
                VStack(spacing: .xxSmall) {
                    Icon(tab.icon, size: .custom(29), color: selectedIndex == index ? tab.color.opacity(0.6) : nil)
                    Text(tab.name)
                        .frame(width: 88)
                        .lineLimit(1)
                }
                .overlay(
                    GeometryReader { proxy in
                        let offset = proxy.frame(in: .global).minX
                        Color.clear
                            .preference(key: TabPreferenceKey.self, value: offset)
                            .onPreferenceChange(TabPreferenceKey.self) { value in
                                x[index] = value
                                if selectedIndex == tab.selection {
                                    selectedX = x[index]
                                }
                            }
                    }
                )
            })
            .frame(width: 44)
            .foregroundColor(selectedIndex == tab.selection ? .primary : .secondary)
            .opacity(selectedIndex == tab.selection ? 1 : 0.6)
            
            Spacer()
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    @State static var helperIndex: Int = 0
    static var previews: some View {
        TabBar(
            tab: TabBarItemModel(name: "Products", icon: .shopping, color: .greenNormal, selection: 0),
            tabs: [
                TabBarItemModel(name: "Products", icon: .shopping, color: .greenNormal, selection: 0),
                TabBarItemModel(name: "Cart", icon: .baggageSet, color: .orangeNormal, selection: 1)
            ],
            selectedIndex: helperIndex
        ) { _ in }
    }
}

struct TabPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct BackgroundStyle: ViewModifier {
    var cornerRadius: CGFloat = 20
    var opacity: Double = 0.6
    var isLiteMode = true
    
    func body(content: Content) -> some View {
        content
            .backgroundColor(opacity: opacity)
            .cornerRadius(cornerRadius)
            .shadow(color: Color("Shadow").opacity(isLiteMode ? 0 : 0.3), radius: 20, x: 0, y: 10)
            .modifier(OutlineOverlay(cornerRadius: cornerRadius))
    }
}

extension View {
    func backgroundStyle(cornerRadius: CGFloat = 20, opacity: Double = 0.6) -> some View {
        self.modifier(BackgroundStyle(cornerRadius: cornerRadius, opacity: opacity))
    }
}

extension View {
    func backgroundColor(opacity: Double = 0.6) -> some View {
        self.modifier(BackgroundColor(opacity: opacity))
    }
}


struct BackgroundColor: ViewModifier {
    var opacity: Double = 0.6
    var cornerRadius: CGFloat = 20
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Color("Background")
                    .opacity(colorScheme == .dark ? opacity : 0)
                    .mask(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    .blendMode(.overlay)
                    .allowsHitTesting(false)
            )
    }
}

struct OutlineOverlay: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    var cornerRadius: CGFloat = 20
    
    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    .linearGradient(
                        colors: [
                            .white.opacity(colorScheme == .dark ? 0.6 : 0.3),
                            .black.opacity(colorScheme == .dark ? 0.3 : 0.1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom)
                )
                .blendMode(.overlay)
        )
    }
}
