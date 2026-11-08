pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui
import "../ui" as Ui

// Injected by the window when the page is loaded: the state every
// row reads, and the calls every control makes.
Ui.SectionBody {
  id: page
  property var app: null
  // "super+shift+r", "SUPER + SHIFT + R" and "Super Shift R" are one chord;
  // the helper canonicalises the same way before it compares.
  function canonicalKeys(text) {
    return String(text).toUpperCase().replace(/\+/g, " ").trim().split(/\s+/).filter(function(part) {
      return part !== ""
    }).join(" + ")
  }

  // What the chord being typed would take over, if anything.
  function bindingFor(text) {
    var wanted = canonicalKeys(text)
    if (wanted === "") return null
    var items = app.bindings.items !== undefined ? app.bindings.items : []
    for (var i = 0; i < items.length; i++)
      if (String(items[i].canonical) === wanted) return items[i]
    return null
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("bindings.addABinding")
    note: Ui.Strings.t("bindings.keysAsHyprlandSpellsThem")

    Row {
      width: parent.width
      spacing: Style.space(8)

      TextField {
        id: keysField
        width: (parent.width - addBindingButton.width - Style.space(24)) * 0.3
        placeholderText: Ui.Strings.t("bindings.superShiftR")
        foreground: page.app.foreground
        accent: page.app.accent
      }

      TextField {
        id: bindingDescriptionField
        width: (parent.width - addBindingButton.width - Style.space(24)) * 0.25
        placeholderText: Ui.Strings.t("bindings.whatItDoes")
        foreground: page.app.foreground
        accent: page.app.accent
      }

      TextField {
        id: commandField
        width: (parent.width - addBindingButton.width - Style.space(24)) * 0.45
        placeholderText: Ui.Strings.t("bindings.commandToRun")
        foreground: page.app.foreground
        accent: page.app.accent
      }

      Button {
        id: addBindingButton
        text: Ui.Strings.t("common.add")
        bordered: true
        foreground: page.app.foreground
        accent: page.app.accent
        fontFamily: page.app.fontFamily
        anchors.verticalCenter: parent.verticalCenter
        onClicked: {
          if (keysField.text.trim() === "" || commandField.text.trim() === "") return
          page.app.run(["keys", "add", keysField.text.trim(),
                    bindingDescriptionField.text.trim(), commandField.text.trim()])
          keysField.text = ""
          bindingDescriptionField.text = ""
          commandField.text = ""
        }
      }
    }

    // Saying so before the button is pressed, rather than after the old
    // binding is gone.
    Text {
      textFormat: Text.PlainText
      readonly property var clash: page.bindingFor(keysField.text)

      width: parent.width
      visible: clash !== null
      wrapMode: Text.WordWrap
      text: clash
        ? (String(clash.description) !== ""
           ? Ui.Strings.t("bindings.clash").arg(page.canonicalKeys(keysField.text)).arg(String(clash.description))
           : Ui.Strings.t("bindings.clashUnnamed").arg(page.canonicalKeys(keysField.text)))
        : ""
      color: Ui.Palette.urgent
      font.family: Ui.Palette.fontFamily
      font.pixelSize: Style.font.caption
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("bindings.everyBinding")

    // This page had a search of its own before the window did. While the
    // window is searching, that one steps aside rather than filtering the
    // filtered — two boxes disagreeing about what is on screen is worse than
    // one box doing less.
    TextField {
      width: parent.width
      visible: !page.app.searching
      placeholderText: Ui.Strings.t("bindings.searchKeysOrActions")
      text: page.app.bindingFilter
      foreground: page.app.foreground
      accent: page.app.accent
      onTextChanged: page.app.bindingFilter = text
    }

    Text {
      textFormat: Text.PlainText
      width: parent.width
      visible: !page.app.searching
      text: page.app.visibleBindings.length + " of " + (page.app.bindings.items !== undefined ? page.app.bindings.items.length : 0)
      color: page.app.muted
      font.family: page.app.fontFamily
      font.pixelSize: Style.font.caption
    }

    Repeater {
      model: page.app.visibleBindings
      delegate: Ui.BindingRow {
        required property var modelData
        width: parent.width
        keys: modelData.keys
        description: modelData.description
        command: modelData.command
        source: modelData.source
        onRemoveRequested: page.app.run(["keys", "remove", modelData.keys])
        onDisableRequested: page.app.run(["keys", "disable", modelData.keys])
      }
    }
  }
}
