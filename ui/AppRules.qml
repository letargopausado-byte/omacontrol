import QtQuick
import qs.Commons
import "." as Local

// Everything this desktop can be told about one application: where it opens,
// how it shows, whether it starts at login. It is a component rather than a
// page because two pages ask for it — the application's own page, and the
// workspace picker that sends you there — and a setting written in two places
// is a setting that disagrees with itself in one of them.
//
// Every row writes through `workspaces set <class>`, which creates the rule
// on the first write: there is nothing to add first.
SettingGroup {
  id: appRules
  property var app: null
  property var displays: []

  function workspaceOptions() {
    var out = [{ value: "", label: Local.Strings.t("ui.appRules.whereverItWasLastOpen") }]
    for (var i = 1; i <= 10; i++) out.push({ value: String(i), label: Local.Strings.t("common.workspaceN").arg(i) })
    out.push({ value: "special", label: Local.Strings.t("ui.appRules.scratchpad") })
    return out
  }

  // Displays are named by what they say about themselves, so a rule follows
  // the screen rather than the socket it happens to be in.
  function displayOptions(noneLabel) {
    return [{ value: "", label: noneLabel }].concat(displays.map(function(m) {
      return { value: String(m.name), label: String(m.label || m.name) }
    }))
  }

  property var modelData: ({})

  readonly property string cls: String(modelData.class)
  readonly property string name: String(modelData.name || modelData.class)
  readonly property bool ours: modelData.ours === true
  readonly property bool theirs: modelData.theirs === true
  readonly property bool onWorkspace: String(modelData.workspace || "") !== ""
  readonly property bool floating: modelData.shown === "floating"

  width: parent ? parent.width : 0
  title: name

  Local.PickerRow {
    label: Local.Strings.t("ui.appRules.opensOn")
    value: String(appRules.modelData.workspace || "")
    options: appRules.workspaceOptions()
    onPicked: function(next) { appRules.app.run(["workspaces", "set", appRules.cls, "workspace", next]) }
  }

  Local.SwitchRow {
    label: Local.Strings.t("ui.appRules.openInTheBackground")
    description: Local.Strings.t("ui.appRules.sendTheWindowToIts")
    visible: appRules.onWorkspace
    checked: appRules.modelData.silent === true
    onRequested: function(next) { appRules.app.run(["workspaces", "set", appRules.cls, "silent", next ? "true" : "false"]) }
  }

  Local.PickerRow {
    label: Local.Strings.t("ui.appRules.openOnDisplay")
    visible: appRules.displays.length > 1
    value: String(appRules.modelData.monitor || "")
    options: appRules.displayOptions(Local.Strings.t("ui.appRules.focusedDisplay"))
    onPicked: function(next) { appRules.app.run(["workspaces", "set", appRules.cls, "monitor", next]) }
  }

  // One choice, not two switches: a fullscreen window is neither tiled nor
  // floating in any way you can see, so offering both was offering a
  // combination with no meaning.
  Local.ChoiceRow {
    label: Local.Strings.t("ui.appRules.shownAs")
    description: Local.Strings.t("ui.appRules.floatingOpensAFreeWindow")
    options: [
      { value: "tiled", label: Local.Strings.t("ui.appRules.tiled") },
      { value: "floating", label: Local.Strings.t("ui.appRules.floating") },
      { value: "fullscreen", label: Local.Strings.t("ui.appRules.fullscreen") }
    ]
    value: String(appRules.modelData.shown || "tiled")
    onPicked: function(next) { appRules.app.run(["workspaces", "set", appRules.cls, "shown", next]) }
  }

  // What only a floating window can do sits under Floating, and goes away
  // with it — Hyprland ignores a pin on a tiled window rather than saying so.
  // A share of the screen rather than pixels, so one rule fits every
  // display. Empty hands the size back to the application.
  Local.TextRow {
    label: Local.Strings.t("common.width")
    description: Local.Strings.t("ui.appRules.percentOfTheScreenLeave")
    visible: appRules.floating
    value: Number(appRules.modelData.width) > 0 ? String(appRules.modelData.width) : ""
    placeholder: "e.g. 60"
    onCommitted: function(next) { appRules.app.run(["workspaces", "set", appRules.cls, "width", next.trim()]) }
  }

  Local.TextRow {
    label: Local.Strings.t("ui.appRules.height")
    description: Local.Strings.t("ui.appRules.percentOfTheScreen")
    visible: appRules.floating
    value: Number(appRules.modelData.height) > 0 ? String(appRules.modelData.height) : ""
    placeholder: "e.g. 60"
    onCommitted: function(next) { appRules.app.run(["workspaces", "set", appRules.cls, "height", next.trim()]) }
  }

  Local.SwitchRow {
    label: Local.Strings.t("ui.appRules.centred")
    description: Local.Strings.t("ui.appRules.opensInTheMiddleOf")
    visible: appRules.floating
    checked: appRules.modelData.center === true
    onRequested: function(next) { appRules.app.run(["workspaces", "set", appRules.cls, "center", next ? "true" : "false"]) }
  }

  Local.SwitchRow {
    label: Local.Strings.t("ui.appRules.pinned")
    description: Local.Strings.t("ui.appRules.staysOnScreenWhicheverWorkspace")
    visible: appRules.floating
    checked: appRules.modelData.pin === true
    onRequested: function(next) { appRules.app.run(["workspaces", "set", appRules.cls, "pin", next ? "true" : "false"]) }
  }

  // Only for an application with a desktop entry: that is what says how
  // to launch it. A bare window class has no command to start.
  Local.SwitchRow {
    label: Local.Strings.t("ui.appRules.startWhenYouLogIn")
    visible: String(appRules.modelData.desktop || "") !== ""
    checked: appRules.modelData.autostart === true
    onRequested: function(next) { appRules.app.run(["workspaces", "set", appRules.cls, "autostart", next ? String(appRules.modelData.desktop) : ""]) }
  }

  Local.SwitchRow {
    label: Local.Strings.t("ui.appRules.donTTakeFocusWhen")
    description: Local.Strings.t("ui.appRules.theWindowAppearsWithoutPulling")
    checked: appRules.modelData.noInitialFocus === true
    onRequested: function(next) { appRules.app.run(["workspaces", "set", appRules.cls, "no_initial_focus", next ? "true" : "false"]) }
  }

  Local.SwitchRow {
    label: Local.Strings.t("ui.appRules.keepTheScreenAwake")
    description: Local.Strings.t("ui.appRules.noDimmingOrLockingWhile")
    checked: appRules.modelData.idleInhibit === true
    onRequested: function(next) { appRules.app.run(["workspaces", "set", appRules.cls, "idle_inhibit", next ? "true" : "false"]) }
  }

  Local.SwitchRow {
    label: Local.Strings.t("ui.appRules.hideFromScreenSharing")
    description: Local.Strings.t("ui.appRules.showsAsABlackRectangle")
    checked: appRules.modelData.noScreenShare === true
    onRequested: function(next) { appRules.app.run(["workspaces", "set", appRules.cls, "no_screen_share", next ? "true" : "false"]) }
  }
}
