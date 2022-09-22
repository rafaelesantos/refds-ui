import SwiftUI

public struct Strut: View {
    
    let height: CGFloat?
    
    public var body: some View {
        Color.clear
            .frame(width: 0, height: height)
    }

    public init(_ height: CGFloat?) {
        self.height = height
    }
}

// MARK: - Previews
struct StrutPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            HStack(spacing: 0) {
                Strut(.xxLarge)
                Text("Content")
            }
            .background(Color.greenLight)

            HStack(spacing: 0) {
                Text("Content")
            }
            .frame(minHeight: .xxLarge)
            .background(Color.redLight)

        }
        .previewLayout(.sizeThatFits)
    }
}
