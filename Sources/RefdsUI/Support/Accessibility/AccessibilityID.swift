import SwiftUI

public enum AccessibilityID: String {
    case alertButtonPrimary             = "refdsUI.alert.button.primary"
    case alertButtonSecondary           = "refdsUI.alert.button.secondary"
    case alertTitle                     = "refdsUI.alert.title"
    case alertIcon                      = "refdsUI.alert.icon"
    case alertDescription               = "refdsUI.alert.description"
    case cardTitle                      = "refdsUI.card.title"
    case cardIcon                       = "refdsUI.card.icon"
    case cardDescription                = "refdsUI.card.description"
    case cardActionButtonLink           = "refdsUI.card.action.buttonLink"
    case checkboxTitle                  = "refdsUI.checkbox.title"
    case checkboxDescription            = "refdsUI.checkbox.description"
    case choiceTileTitle                = "refdsUI.choicetile.title"
    case choiceTileIcon                 = "refdsUI.choicetile.icon"
    case choiceTileDescription          = "refdsUI.choicetile.description"
    case choiceTileBadge                = "refdsUI.choicetile.badge"
    case dialogTitle                    = "refdsUI.dialog.title"
    case dialogDescription              = "refdsUI.dialog.description"
    case dialogButtonPrimary            = "refdsUI.dialog.button.primary"
    case dialogButtonSecondary          = "refdsUI.dialog.button.secondary"
    case dialogButtonTertiary           = "refdsUI.dialog.button.tertiary"
    case emptyStateTitle                = "refdsUI.emptystate.title"
    case emptyStateDescription          = "refdsUI.emptystate.description"
    case emptyStateButton               = "refdsUI.emptystate.button"
    case fieldLabel                     = "refdsUI.field.label"
    case fieldMessage                   = "refdsUI.field.message"
    case fieldMessageIcon               = "refdsUI.field.message.icon"
    case inputPrefix                    = "refdsUI.input.prefix"
    case inputSuffix                    = "refdsUI.input.suffix"
    case inputValue                     = "refdsUI.input.value"
    case inputFieldPasswordToggle       = "refdsUI.inputfield.password.toggle"
    case keyValueKey                    = "refdsUI.keyvalue.key"
    case keyValueValue                  = "refdsUI.keyvalue.value"
    case listChoiceTitle                = "refdsUI.listchoice.title"
    case listChoiceIcon                 = "refdsUI.listchoice.icon"
    case listChoiceDescription          = "refdsUI.listchoice.description"
    case listChoiceValue                = "refdsUI.listchoice.value"
    case passwordStrengthIndicator      = "refdsUI.passwordstrengthindicator"
    case radioTitle                     = "refdsUI.radio.title"
    case radioDescription               = "refdsUI.radio.description"
    case tileTitle                      = "refdsUI.tile.title"
    case tileIcon                       = "refdsUI.tile.icon"
    case tileDescription                = "refdsUI.tile.description"
    case tileDisclosureButtonLink       = "refdsUI.tile.disclosure.buttonlink"
    case tileDisclosureIcon             = "refdsUI.tile.disclosure.icon"
}

extension View {
    func accessibility(_ identifier: AccessibilityID) -> some View {
        self.accessibility(identifier: identifier.rawValue)
    }
}
