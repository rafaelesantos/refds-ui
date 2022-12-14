import SwiftUI

public struct FormFieldMessage: View {

    let message: MessageType
    let spacing: CGFloat

    public var body: some View {
        if message.isEmpty == false {
            HStack(alignment: .firstTextBaseline, spacing: spacing) {
                Icon(message.icon, size: .small, color: message.color)
                    .accessibility(.fieldMessageIcon)
                Text(message.description, color: .custom(message.uiColor))
                    .accessibility(.fieldMessage)
                    .alignmentGuide(.firstTextBaseline) { _ in
                        Text.Size.small.value * 1.1
                    }
            }
            .transition(.opacity.animation(.easeOut(duration: 0.2)))
        }
    }

    public init(_ message: MessageType, spacing: CGFloat = .xxSmall) {
        self.message = message
        self.spacing = spacing
    }
}

// MARK: - Previews
struct FormFieldMessagePreviews: PreviewProvider {
    
    static var previews: some View {
        PreviewWrapper {
            FormFieldMessage(.normal("Form Field Message", icon: .informationCircle))
            FormFieldMessage(.help("Help Message"))
            FormFieldMessage(.error("Form Field Message", icon: .alertCircle))
        }
        .previewLayout(.sizeThatFits)
    }
}
