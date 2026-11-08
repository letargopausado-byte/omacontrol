import QtQuick
import "../ui" as Ui

// Injected by the window when the page is loaded: the state every
// row reads, and the calls every control makes.
Ui.SectionBody {
  id: page
  property var app: null
  Ui.SettingGroup {
    title: Ui.Strings.t("defaults.applications")
    note: Ui.Strings.t("defaults.anAppYouHaveNot")

    Ui.PickerRow {
      label: Ui.Strings.t("defaults.browser")
      value: page.app.group("browser").current
      options: page.app.groupOptions("browser")
      onPicked: function(next) { page.app.run(["menu", "run", "setup.default.browser." + next]) }
    }

    Ui.PickerRow {
      label: Ui.Strings.t("defaults.terminal")
      value: page.app.group("terminal").current
      options: page.app.groupOptions("terminal")
      onPicked: function(next) { page.app.run(["menu", "run", "setup.default.terminal." + next]) }
    }

    Ui.PickerRow {
      label: Ui.Strings.t("defaults.editor")
      value: page.app.group("editor").current
      options: page.app.groupOptions("editor")
      onPicked: function(next) { page.app.run(["menu", "run", "setup.default.editor." + next]) }
    }

    Ui.PickerRow {
      label: Ui.Strings.t("defaults.codingAgent")
      value: page.app.agentsState.current !== undefined ? String(page.app.agentsState.current) : ""
      options: page.app.agentOptions()
      onPicked: function(next) { page.app.run(["agents", "run", next]) }
    }
  }
}
