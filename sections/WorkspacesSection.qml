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

  readonly property var rules: app.workspaceRules
  readonly property var setups: app.workspaceSetups
  readonly property var displays: (app.monitors !== undefined ? app.monitors : []).filter(function(m) {
    return m.connected !== false
  })

  readonly property var unsetWorkspaces: {
    var out = []
    for (var i = 1; i <= 10; i++) {
      var id = String(i)
      if (!setups.some(function(s) { return String(s.id) === id })) out.push(id)
    }
    return out
  }

  // Displays are named by what they say about themselves, so a rule follows
  // the screen rather than the socket it happens to be in.
  function displayOptions(noneLabel) {
    return [{ value: "", label: noneLabel }].concat(displays.map(function(m) {
      return { value: String(m.name), label: String(m.label || m.name) }
    }))
  }

  // ---------------------------------------------------------- applications
  //
  // The rules themselves live on Applications, one page per application. They
  // were here first, and here they were a second place writing the same Lua:
  // a reader who had set Slack from one page found the other saying it too,
  // with no way to tell which was the one that counted. What is left is the
  // way in, since an application bound to a workspace is a thing people come
  // to this page looking for.
  Ui.SettingGroup {
    title: Ui.Strings.t("workspaces.applications")
    note: page.rules.length === 0
      ? Ui.Strings.t("workspaces.noRules")
      : Ui.Strings.tn("workspaces.rulesCount", page.rules.length).replace("%1", page.rules.length)

    Ui.ActionRow {
      label: Ui.Strings.t("workspaces.whereApplicationsOpen")
      description: Ui.Strings.t("workspaces.whichWorkspaceAnApplicationOpens")
      buttonText: Ui.Strings.t("workspaces.apps")
      onTriggered: page.app.pageId = "apps.list"
    }
  }

  // ------------------------------------------------------------ workspaces
  //
  // A rule for the place, not for what opens there — a different kind of
  // thing, so a line rather than only a heading marks where one ends.
  Rectangle {
    width: parent.width
    height: 1
    color: Ui.Palette.hairline
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("workspaces.workspaceSettings")
    note: page.unsetWorkspaces.length === 0 ? Ui.Strings.t("workspaces.allSetUp") : ""

    Ui.PickerRow {
      label: Ui.Strings.t("workspaces.setUpAWorkspace")
      visible: page.unsetWorkspaces.length > 0
      description: Ui.Strings.t("workspaces.itsDisplayNameLayoutAnd")
      value: ""
      options: [{ value: "", label: Ui.Strings.t("workspaces.pickAWorkspace") }].concat(page.unsetWorkspaces.map(function(id) {
        return { value: id, label: Ui.Strings.t("common.workspaceN").arg(id) }
      }))
      onPicked: function(next) { if (next !== "") page.app.run(["workspaces", "setup", "add", next]) }
    }
  }
  //
  // The place rather than what opens there. Only a workspace with something
  // set gets a group, so ten empty groups do not bury the applications above.
  Repeater {
    model: page.setups

    delegate: Ui.SettingGroup {
      id: setupGroup
      required property var modelData

      readonly property string id: String(modelData.id)
      readonly property bool ours: modelData.ours === true
      readonly property bool theirs: modelData.theirs === true

      width: parent.width
      title: Ui.Strings.t("common.workspaceN").arg(id)

      Ui.TextRow {
        label: Ui.Strings.t("common.name")
        description: Ui.Strings.t("workspaces.shownInTheBarInstead")
        value: String(setupGroup.modelData.name || "")
        placeholder: setupGroup.id
        onCommitted: function(next) { page.app.run(["workspaces", "setup", "set", setupGroup.id, "name", next]) }
      }

      Ui.PickerRow {
        label: Ui.Strings.t("workspaces.display")
        visible: page.displays.length > 1
        value: String(setupGroup.modelData.monitor || "")
        options: page.displayOptions(Ui.Strings.t("workspaces.anyDisplay"))
        onPicked: function(next) { page.app.run(["workspaces", "setup", "set", setupGroup.id, "monitor", next]) }
      }

      Ui.SwitchRow {
        label: Ui.Strings.t("workspaces.defaultOnItsDisplay")
        description: Ui.Strings.t("workspaces.theWorkspaceADisplayShows")
        visible: String(setupGroup.modelData.monitor || "") !== ""
        checked: setupGroup.modelData.default === true
        onRequested: function(next) { page.app.run(["workspaces", "setup", "set", setupGroup.id, "default", next ? "true" : "false"]) }
      }

      Ui.SwitchRow {
        label: Ui.Strings.t("workspaces.keepWhenEmpty")
        description: Ui.Strings.t("workspaces.staysInTheBarWith")
        checked: setupGroup.modelData.persistent === true
        onRequested: function(next) { page.app.run(["workspaces", "setup", "set", setupGroup.id, "persistent", next ? "true" : "false"]) }
      }

      Ui.ChoiceRow {
        label: Ui.Strings.t("common.layout")
        options: [
          { value: "", label: Ui.Strings.t("workspaces.default") },
          { value: "dwindle", label: Ui.Strings.t("workspaces.dwindle") },
          { value: "master", label: Ui.Strings.t("workspaces.master") },
          { value: "scrolling", label: Ui.Strings.t("workspaces.scrolling") }
        ]
        value: String(setupGroup.modelData.layout || "")
        onPicked: function(next) { page.app.run(["workspaces", "setup", "set", setupGroup.id, "layout", next]) }
      }

      Ui.SwitchRow {
        label: Ui.Strings.t("workspaces.borderlessNoGaps")
        description: Ui.Strings.t("workspaces.windowsEdgeToEdgeWith")
        checked: setupGroup.modelData.minimal === true
        onRequested: function(next) { page.app.run(["workspaces", "setup", "set", setupGroup.id, "minimal", next ? "true" : "false"]) }
      }

      Ui.ActionRow {
        buttonText: Ui.Strings.t("common.remove")
        onTriggered: page.app.run(["workspaces", "setup", "remove", setupGroup.id])
      }
    }
  }

}
