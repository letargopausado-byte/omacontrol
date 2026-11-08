pragma ComponentBehavior: Bound
import QtQuick
import "../ui" as Ui

// Injected by the window when the page is loaded: the state every
// row reads, and the calls every control makes.
Ui.SectionBody {
  id: page
  property var app: null

  readonly property var fonts: app.state.fonts !== undefined ? app.state.fonts : []
  readonly property string chosen: app.fontPending !== "" ? app.fontPending
    : (app.state.font !== undefined ? String(app.state.font) : "")

  Ui.SettingGroup {
    Ui.NumberRow {
      label: Ui.Strings.t("font.textSize")
      description: Ui.Strings.t("font.scalesTheShellGtkApps")
      suffix: Ui.Strings.t("common.px")
      value: page.app.state.textScale !== undefined ? Number(page.app.state.textScale) : 12
      from: 9
      to: 20
      onCommitted: function(next) { page.app.set("text-scale", next) }
      changed: page.app.isChanged("text-scale")
      onResetRequested: page.app.resetSetting("text-scale")
    }
  }

  // Every font set in itself. A list of fifty names tells you nothing about
  // the one thing a font is — a name in Helvetica and a name in Comic Sans
  // read identically when both are printed in the font you already have.
  //
  Ui.SettingGroup {
    title: Ui.Strings.t("font.font")
    visible: !searchEmpty

    Repeater {
      model: page.fonts

      delegate: Ui.SpecimenRow {
        required property var modelData
        width: parent.width
        family: String(modelData)
        current: String(modelData) === page.chosen
        onChose: page.app.setFont(String(modelData))
      }
    }
  }
}
