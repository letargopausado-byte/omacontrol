import QtQuick
import "../ui" as Ui

// Injected by the window when the page is loaded: the state every
// row reads, and the calls every control makes.
Ui.SectionBody {
  id: page
  property var app: null
  Ui.SettingGroup {
    title: Ui.Strings.t("tmux.keys")

    Ui.TextRow {
      label: Ui.Strings.t("tmux.prefix")
      description: Ui.Strings.t("tmux.tmuxSpellingCSpaceC")
      placeholder: "C-b"
      value: String(page.app.tmuxValue("prefix", "C-b"))
      onCommitted: function(next) { page.app.setTmux("prefix", next) }
      changed: page.app.isChanged("tmux:prefix")
      onResetRequested: page.app.resetSetting("tmux:prefix")
    }

    Ui.PickerRow {
      label: Ui.Strings.t("tmux.copyModeKeys")
      value: String(page.app.tmuxValue("mode-keys", "emacs"))
      options: [
        { value: "vi", label: Ui.Strings.t("tmux.vi") },
        { value: "emacs", label: Ui.Strings.t("tmux.emacs") }
      ]
      onPicked: function(next) { page.app.setTmux("mode-keys", next) }
      changed: page.app.isChanged("tmux:mode-keys")
      onResetRequested: page.app.resetSetting("tmux:mode-keys")
    }

    Ui.ActionRow {
      label: Ui.Strings.t("tmux.everyShortcut")
      description: Ui.Strings.t("tmux.theFullListAsTmux")
      buttonText: Ui.Strings.t("tmux.show")
      onTriggered: page.app.run(["menu", "run", "learn.tmux-keybindings"])
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("tmux.statusBar")

    Ui.PickerRow {
      label: Ui.Strings.t("tmux.position")
      value: String(page.app.tmuxValue("status-position", "bottom"))
      options: [
        { value: "top", label: Ui.Strings.t("common.top") },
        { value: "bottom", label: Ui.Strings.t("common.bottom") }
      ]
      onPicked: function(next) { page.app.setTmux("status-position", next) }
      changed: page.app.isChanged("tmux:status-position")
      onResetRequested: page.app.resetSetting("tmux:status-position")
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("tmux.windowsAndPanes")

    Ui.NumberRow {
      label: Ui.Strings.t("tmux.firstWindowNumber")
      value: Number(page.app.tmuxValue("base-index", 0))
      from: 0
      to: 1
      onCommitted: function(next) { page.app.setTmux("base-index", next) }
      changed: page.app.isChanged("tmux:base-index")
      onResetRequested: page.app.resetSetting("tmux:base-index")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("tmux.firstPaneNumber")
      value: Number(page.app.tmuxValue("pane-base-index", 0))
      from: 0
      to: 1
      onCommitted: function(next) { page.app.setTmux("pane-base-index", next) }
      changed: page.app.isChanged("tmux:pane-base-index")
      onResetRequested: page.app.resetSetting("tmux:pane-base-index")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("tmux.renumberWhenOneCloses")
      checked: page.app.tmuxValue("renumber-windows", false) === true
      onRequested: function(next) { page.app.setTmux("renumber-windows", next ? "true" : "false") }
      changed: page.app.isChanged("tmux:renumber-windows")
      onResetRequested: page.app.resetSetting("tmux:renumber-windows")
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("tmux.behaviour")

    Ui.SwitchRow {
      label: Ui.Strings.t("tmux.mouse")
      description: Ui.Strings.t("tmux.clickToFocusAPane")
      checked: page.app.tmuxValue("mouse", false) === true
      onRequested: function(next) { page.app.setTmux("mouse", next ? "true" : "false") }
      changed: page.app.isChanged("tmux:mouse")
      onResetRequested: page.app.resetSetting("tmux:mouse")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("tmux.scrollback")
      suffix: Ui.Strings.t("common.lines")
      value: Number(page.app.tmuxValue("history-limit", 2000))
      from: 1000
      to: 100000
      step: 1000
      onCommitted: function(next) { page.app.setTmux("history-limit", next) }
      changed: page.app.isChanged("tmux:history-limit")
      onResetRequested: page.app.resetSetting("tmux:history-limit")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("tmux.escapeDelay")
      suffix: Ui.Strings.t("tmux.ms")
      description: Ui.Strings.t("tmux.lowValuesKeepEscSnappy")
      value: Number(page.app.tmuxValue("escape-time", 500))
      from: 0
      to: 500
      step: 10
      onCommitted: function(next) { page.app.setTmux("escape-time", next) }
      changed: page.app.isChanged("tmux:escape-time")
      onResetRequested: page.app.resetSetting("tmux:escape-time")
    }

    Ui.PickerRow {
      label: Ui.Strings.t("tmux.clipboard")
      description: Ui.Strings.t("tmux.whetherTmuxHandsCopiedText")
      value: String(page.app.tmuxValue("set-clipboard", "external"))
      options: [
        { value: "on", label: Ui.Strings.t("common.on") },
        { value: "external", label: Ui.Strings.t("tmux.externalOnly") },
        { value: "off", label: Ui.Strings.t("tmux.off") }
      ]
      onPicked: function(next) { page.app.setTmux("set-clipboard", next) }
      changed: page.app.isChanged("tmux:set-clipboard")
      onResetRequested: page.app.resetSetting("tmux:set-clipboard")
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("common.beyondTheseSettings")

    Ui.ActionRow {
      label: Ui.Strings.t("common.theRestOfTheConfig")
      description: Ui.Strings.t("tmux.openTmuxConfForBindings")
      buttonText: Ui.Strings.t("common.edit")
      onTriggered: page.app.editConfig("$HOME/.config/tmux/tmux.conf")
    }
  }
}
