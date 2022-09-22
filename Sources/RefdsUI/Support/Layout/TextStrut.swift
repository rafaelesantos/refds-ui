import SwiftUI

public struct TextStrut: View {
    
    let textSize: Text.Size
    
    public var body: some View {
        Text("I", size: textSize, color: .custom(.clear))
            .accessibility(hidden: true)
            .accessibility(removeTraits: .isStaticText)
            .frame(width: 0)
    }

    public init(_ textSize: Text.Size) {
        self.textSize = textSize
    }
}

// MARK: - Previews
struct TextStrutPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            HStack(spacing: .xxxSmall) {
                TextStrut(.large)
                    .padding(.horizontal, 1)
                    .overlay(Color.redNormal)
                    .padding(.vertical, .xSmall)
                    .background(Color.redLight)
                Text("Text", size: .large)
            }
            .padding(.xxSmall)

            HStack(spacing: .xxxSmall) {
                TextStrut(.large)
                    .padding(.horizontal, 1)
                    .overlay(Color.redNormal)
                    .padding(.vertical, .xSmall)
                    .background(Color.redLight)
                Icon(.grid, size: .text(.large))
            }
            .padding(.xxSmall)

            HStack(spacing: .xxxSmall) {
                Icon(.grid, size: .text(.large))
                TextStrut(.large)
                    .padding(.horizontal, 1)
                    .overlay(Color.redNormal)
                    .padding(.vertical, .xSmall)
                    .background(Color.redLight)
                Text("Text", size: .large)
            }
            .padding(.xxSmall)
        }
        .previewLayout(.sizeThatFits)
    }
}
