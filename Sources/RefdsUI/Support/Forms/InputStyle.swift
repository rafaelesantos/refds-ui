import SwiftUI

struct InputStyle: ButtonStyle {

    var prefix: Icon.Content = .none
    var suffix: Icon.Content = .none
    var state: InputState = .default
    var message: MessageType = .none
    var isEditing = false

    func makeBody(configuration: Configuration) -> some View {
        InputContent(
            prefix: prefix,
            suffix: suffix,
            state: state,
            message: message,
            isPressed: configuration.isPressed,
            isEditing: isEditing
        ) {
            configuration.label
        }
    }

}
