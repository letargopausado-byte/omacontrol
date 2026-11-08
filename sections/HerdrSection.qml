import QtQuick
import "../ui" as Ui

// Injected by the window when the page is loaded: the state every
// row reads, and the calls every control makes.
Ui.SectionBody {
  id: page
  property var app: null
  Ui.SettingGroup {
    title: Ui.Strings.t("herdr.appearance")

    Ui.PickerRow {
      label: Ui.Strings.t("herdr.theme")
      value: String(page.app.herdrValue("theme.name", "catppuccin"))
      options: [
        { value: "terminal", label: Ui.Strings.t("herdr.terminalPalette") },
        { value: "catppuccin", label: Ui.Strings.t("herdr.catppuccin") },
        { value: "tokyo-night", label: Ui.Strings.t("herdr.tokyoNight") },
        { value: "dracula", label: Ui.Strings.t("herdr.dracula") },
        { value: "nord", label: Ui.Strings.t("herdr.nord") },
        { value: "gruvbox", label: Ui.Strings.t("herdr.gruvbox") },
        { value: "one-dark", label: Ui.Strings.t("herdr.oneDark") },
        { value: "solarized", label: Ui.Strings.t("herdr.solarized") },
        { value: "kanagawa", label: Ui.Strings.t("herdr.kanagawa") },
        { value: "rose-pine", label: Ui.Strings.t("herdr.rosPine") },
        { value: "vesper", label: Ui.Strings.t("herdr.vesper") }
      ]
      onPicked: function(next) { page.app.setHerdr("theme.name", next) }
      changed: page.app.isChanged("herdr:theme.name")
      onResetRequested: page.app.resetSetting("herdr:theme.name")
    }

    Ui.TextRow {
      label: Ui.Strings.t("herdr.accent")
      description: Ui.Strings.t("herdr.aColourNameRrggbbOr")
      placeholder: Ui.Strings.t("herdr.cyan")
      value: String(page.app.herdrValue("ui.accent", "cyan"))
      onCommitted: function(next) { page.app.setHerdr("ui.accent", next) }
      changed: page.app.isChanged("herdr:ui.accent")
      onResetRequested: page.app.resetSetting("herdr:ui.accent")
    }

    Ui.PickerRow {
      label: Ui.Strings.t("herdr.tabBar")
      value: String(page.app.herdrValue("ui.tab_bar_position", "top"))
      options: [
        { value: "top", label: Ui.Strings.t("common.top") },
        { value: "bottom", label: Ui.Strings.t("common.bottom") }
      ]
      onPicked: function(next) { page.app.setHerdr("ui.tab_bar_position", next) }
      changed: page.app.isChanged("herdr:ui.tab_bar_position")
      onResetRequested: page.app.resetSetting("herdr:ui.tab_bar_position")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("herdr.hideTheTabBarWith")
      checked: page.app.herdrValue("ui.hide_tab_bar_when_single_tab", false) === true
      onRequested: function(next) { page.app.setHerdr("ui.hide_tab_bar_when_single_tab", next ? "true" : "false") }
      changed: page.app.isChanged("herdr:ui.hide_tab_bar_when_single_tab")
      onResetRequested: page.app.resetSetting("herdr:ui.hide_tab_bar_when_single_tab")
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("herdr.panes")

    Ui.SwitchRow {
      label: Ui.Strings.t("herdr.borders")
      checked: page.app.herdrValue("ui.pane_borders", true) === true
      onRequested: function(next) { page.app.setHerdr("ui.pane_borders", next ? "true" : "false") }
      changed: page.app.isChanged("herdr:ui.pane_borders")
      onResetRequested: page.app.resetSetting("herdr:ui.pane_borders")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("herdr.outerBorder")
      description: Ui.Strings.t("herdr.offGivesTmuxStyleSplitters")
      checked: page.app.herdrValue("ui.pane_outer_borders", true) === true
      onRequested: function(next) { page.app.setHerdr("ui.pane_outer_borders", next ? "true" : "false") }
      changed: page.app.isChanged("herdr:ui.pane_outer_borders")
      onResetRequested: page.app.resetSetting("herdr:ui.pane_outer_borders")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("herdr.gapsBetweenPanes")
      checked: page.app.herdrValue("ui.pane_gaps", true) === true
      onRequested: function(next) { page.app.setHerdr("ui.pane_gaps", next ? "true" : "false") }
      changed: page.app.isChanged("herdr:ui.pane_gaps")
      onResetRequested: page.app.resetSetting("herdr:ui.pane_gaps")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("herdr.scrollbars")
      checked: page.app.herdrValue("ui.pane_scrollbars", true) === true
      onRequested: function(next) { page.app.setHerdr("ui.pane_scrollbars", next ? "true" : "false") }
      changed: page.app.isChanged("herdr:ui.pane_scrollbars")
      onResetRequested: page.app.resetSetting("herdr:ui.pane_scrollbars")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("herdr.agentLabelsOnBorders")
      description: Ui.Strings.t("herdr.shownWhenAPaneHas")
      checked: page.app.herdrValue("ui.show_agent_labels_on_pane_borders", false) === true
      onRequested: function(next) { page.app.setHerdr("ui.show_agent_labels_on_pane_borders", next ? "true" : "false") }
      changed: page.app.isChanged("herdr:ui.show_agent_labels_on_pane_borders")
      onResetRequested: page.app.resetSetting("herdr:ui.show_agent_labels_on_pane_borders")
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("herdr.sidebar")

    Ui.NumberRow {
      label: Ui.Strings.t("common.width")
      suffix: Ui.Strings.t("herdr.columns")
      value: Number(page.app.herdrValue("ui.sidebar_width", 26))
      from: 12
      to: 60
      onCommitted: function(next) { page.app.setHerdr("ui.sidebar_width", next) }
      changed: page.app.isChanged("herdr:ui.sidebar_width")
      onResetRequested: page.app.resetSetting("herdr:ui.sidebar_width")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("herdr.startCollapsed")
      description: Ui.Strings.t("herdr.takesEffectTheNextTime")
      checked: page.app.herdrValue("ui.sidebar_start_collapsed", false) === true
      onRequested: function(next) { page.app.setHerdr("ui.sidebar_start_collapsed", next ? "true" : "false") }
      changed: page.app.isChanged("herdr:ui.sidebar_start_collapsed")
      onResetRequested: page.app.resetSetting("herdr:ui.sidebar_start_collapsed")
    }

    Ui.PickerRow {
      label: Ui.Strings.t("herdr.whenCollapsed")
      value: String(page.app.herdrValue("ui.sidebar_collapsed_mode", "compact"))
      options: [
        { value: "compact", label: Ui.Strings.t("herdr.keepTheStatusRail") },
        { value: "hidden", label: Ui.Strings.t("herdr.hideItCompletely") }
      ]
      onPicked: function(next) { page.app.setHerdr("ui.sidebar_collapsed_mode", next) }
      changed: page.app.isChanged("herdr:ui.sidebar_collapsed_mode")
      onResetRequested: page.app.resetSetting("herdr:ui.sidebar_collapsed_mode")
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("herdr.behaviour")

    Ui.PickerRow {
      label: Ui.Strings.t("herdr.newPanesOpenIn")
      value: String(page.app.herdrValue("terminal.new_cwd", "follow"))
      options: [
        { value: "follow", label: Ui.Strings.t("herdr.theFolderYouWereIn") },
        { value: "home", label: Ui.Strings.t("herdr.yourHomeFolder") },
        { value: "current", label: Ui.Strings.t("herdr.herdrSOwnFolder") }
      ]
      onPicked: function(next) { page.app.setHerdr("terminal.new_cwd", next) }
      changed: page.app.isChanged("herdr:terminal.new_cwd")
      onResetRequested: page.app.resetSetting("herdr:terminal.new_cwd")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("herdr.captureTheMouse")
      description: Ui.Strings.t("herdr.offLetsTheTerminalHandle")
      checked: page.app.herdrValue("ui.mouse_capture", true) === true
      onRequested: function(next) { page.app.setHerdr("ui.mouse_capture", next ? "true" : "false") }
      changed: page.app.isChanged("herdr:ui.mouse_capture")
      onResetRequested: page.app.resetSetting("herdr:ui.mouse_capture")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("herdr.copyOnSelection")
      checked: page.app.herdrValue("ui.copy_on_select", true) === true
      onRequested: function(next) { page.app.setHerdr("ui.copy_on_select", next ? "true" : "false") }
      changed: page.app.isChanged("herdr:ui.copy_on_select")
      onResetRequested: page.app.resetSetting("herdr:ui.copy_on_select")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("herdr.scrollStep")
      suffix: Ui.Strings.t("common.lines")
      value: Number(page.app.herdrValue("ui.mouse_scroll_lines", 3))
      from: 1
      to: 10
      onCommitted: function(next) { page.app.setHerdr("ui.mouse_scroll_lines", next) }
      changed: page.app.isChanged("herdr:ui.mouse_scroll_lines")
      onResetRequested: page.app.resetSetting("herdr:ui.mouse_scroll_lines")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("herdr.confirmBeforeClosing")
      checked: page.app.herdrValue("ui.confirm_close", true) === true
      onRequested: function(next) { page.app.setHerdr("ui.confirm_close", next ? "true" : "false") }
      changed: page.app.isChanged("herdr:ui.confirm_close")
      onResetRequested: page.app.resetSetting("herdr:ui.confirm_close")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("herdr.askForATabName")
      checked: page.app.herdrValue("ui.prompt_new_tab_name", true) === true
      onRequested: function(next) { page.app.setHerdr("ui.prompt_new_tab_name", next ? "true" : "false") }
      changed: page.app.isChanged("herdr:ui.prompt_new_tab_name")
      onResetRequested: page.app.resetSetting("herdr:ui.prompt_new_tab_name")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("herdr.askForAWorkspaceName")
      checked: page.app.herdrValue("ui.prompt_new_workspace_name", false) === true
      onRequested: function(next) { page.app.setHerdr("ui.prompt_new_workspace_name", next ? "true" : "false") }
      changed: page.app.isChanged("herdr:ui.prompt_new_workspace_name")
      onResetRequested: page.app.resetSetting("herdr:ui.prompt_new_workspace_name")
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("herdr.notifications")

    Ui.PickerRow {
      label: Ui.Strings.t("herdr.popUps")
      value: String(page.app.herdrValue("ui.toast.delivery", "off"))
      options: [
        { value: "off", label: Ui.Strings.t("herdr.none") },
        { value: "herdr", label: Ui.Strings.t("herdr.insideHerdr") },
        { value: "terminal", label: Ui.Strings.t("herdr.throughTheTerminal") },
        { value: "system", label: Ui.Strings.t("herdr.desktopNotifications") }
      ]
      onPicked: function(next) { page.app.setHerdr("ui.toast.delivery", next) }
      changed: page.app.isChanged("herdr:ui.toast.delivery")
      onResetRequested: page.app.resetSetting("herdr:ui.toast.delivery")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("herdr.sounds")
      description: Ui.Strings.t("herdr.playedWhenAnAgentChanges")
      checked: page.app.herdrValue("ui.sound.enabled", true) === true
      onRequested: function(next) { page.app.setHerdr("ui.sound.enabled", next ? "true" : "false") }
      changed: page.app.isChanged("herdr:ui.sound.enabled")
      onResetRequested: page.app.resetSetting("herdr:ui.sound.enabled")
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("herdr.keys")

    Ui.TextRow {
      label: Ui.Strings.t("herdr.prefix")
      description: Ui.Strings.t("herdr.everyPrefixShortcutStartsWith")
      placeholder: Ui.Strings.t("herdr.ctrlB")
      value: String(page.app.herdrValue("keys.prefix", "ctrl+b"))
      onCommitted: function(next) { page.app.setHerdr("keys.prefix", next) }
      changed: page.app.isChanged("herdr:keys.prefix")
      onResetRequested: page.app.resetSetting("herdr:keys.prefix")
    }

    Ui.ActionRow {
      label: Ui.Strings.t("herdr.everyShortcut")
      description: Ui.Strings.t("herdr.theFullListAsHerdr")
      buttonText: Ui.Strings.t("herdr.show")
      onTriggered: page.app.run(["menu", "run", "learn.herdr-keybindings"])
    }

    Ui.ActionRow {
      label: Ui.Strings.t("common.theRestOfTheConfig")
      description: Ui.Strings.t("herdr.openConfigTomlForThe")
      buttonText: Ui.Strings.t("common.edit")
      onTriggered: page.app.editConfig("$HOME/.config/herdr/config.toml")
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("herdr.windowTitle")

    Ui.TextRow {
      label: Ui.Strings.t("herdr.title")
      description: Ui.Strings.t("herdr.tokensHostnameWorkspaceTabPane")
      placeholder: Ui.Strings.t("herdr.hostnameWorkspace")
      value: String(page.app.herdrValue("ui.window_title", ""))
      onCommitted: function(next) { page.app.setHerdr("ui.window_title", next) }
      changed: page.app.isChanged("herdr:ui.window_title")
      onResetRequested: page.app.resetSetting("herdr:ui.window_title")
    }
  }
}
