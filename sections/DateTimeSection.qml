import QtQuick
import "../ui" as Ui

// Injected by the window when the page is loaded: the state every
// row reads, and the calls every control makes.
Ui.SectionBody {
  id: page
  property var app: null
  Ui.SettingGroup {
    title: Ui.Strings.t("dateTime.clock")

    Ui.ActionRow {
      label: Ui.Strings.t("dateTime.timezone")
      description: page.app.datetime.timezone ? String(page.app.datetime.timezone) : Ui.Strings.t("dateTime.unknown")
      buttonText: Ui.Strings.t("dateTime.change")
      onTriggered: page.app.run(["menu", "run", "update.timezone"])
    }

    Ui.ActionRow {
      label: Ui.Strings.t("dateTime.systemTime")
      description: (page.app.datetime.now ? String(page.app.datetime.now) : "")
        + (page.app.datetime.ntp === true
           ? (page.app.datetime.synchronized === true ? " · " + Ui.Strings.t("dateTime.synchronized") : " · " + Ui.Strings.t("dateTime.syncing"))
           : " · " + Ui.Strings.t("dateTime.autoSyncOff"))
      buttonText: Ui.Strings.t("dateTime.resync")
      onTriggered: page.app.run(["menu", "run", "update.time"])
    }
  }
}
