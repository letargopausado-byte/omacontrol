import QtQuick
import "../ui" as Ui

// Injected by the window when the page is loaded: the state every
// row reads, and the calls every control makes.
Ui.SectionBody {
  id: page
  property var app: null
  Ui.SettingGroup {
    title: Ui.Strings.t("nvim.theGutter")

    Ui.SwitchRow {
      label: Ui.Strings.t("nvim.lineNumbers")
      checked: page.app.nvimValue("number", true) === true
      onRequested: function(next) { page.app.setNvim("number", next ? "true" : "false") }
      changed: page.app.isChanged("nvim:number")
      onResetRequested: page.app.resetSetting("nvim:number")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("nvim.relativeLineNumbers")
      checked: page.app.nvimValue("relativenumber", true) === true
      onRequested: function(next) { page.app.setNvim("relativenumber", next ? "true" : "false") }
      changed: page.app.isChanged("nvim:relativenumber")
      onResetRequested: page.app.resetSetting("nvim:relativenumber")
    }

    Ui.PickerRow {
      label: Ui.Strings.t("nvim.signColumn")
      description: Ui.Strings.t("nvim.whereGitMarksAndDiagnostics")
      value: String(page.app.nvimValue("signcolumn", "yes"))
      options: [
        { value: "yes", label: Ui.Strings.t("nvim.always") },
        { value: "auto", label: Ui.Strings.t("nvim.onlyWhenNeeded") },
        { value: "no", label: Ui.Strings.t("nvim.never") }
      ]
      onPicked: function(next) { page.app.setNvim("signcolumn", next) }
      changed: page.app.isChanged("nvim:signcolumn")
      onResetRequested: page.app.resetSetting("nvim:signcolumn")
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("nvim.theText")

    Ui.SwitchRow {
      label: Ui.Strings.t("nvim.wrapLongLines")
      checked: page.app.nvimValue("wrap", false) === true
      onRequested: function(next) { page.app.setNvim("wrap", next ? "true" : "false") }
      changed: page.app.isChanged("nvim:wrap")
      onResetRequested: page.app.resetSetting("nvim:wrap")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("nvim.highlightTheCurrentLine")
      checked: page.app.nvimValue("cursorline", true) === true
      onRequested: function(next) { page.app.setNvim("cursorline", next ? "true" : "false") }
      changed: page.app.isChanged("nvim:cursorline")
      onResetRequested: page.app.resetSetting("nvim:cursorline")
    }

    Ui.TextRow {
      label: Ui.Strings.t("nvim.columnGuide")
      description: Ui.Strings.t("nvim.aColumnNumberOrEmpty")
      placeholder: "100"
      value: String(page.app.nvimValue("colorcolumn", ""))
      onCommitted: function(next) { page.app.setNvim("colorcolumn", next) }
      changed: page.app.isChanged("nvim:colorcolumn")
      onResetRequested: page.app.resetSetting("nvim:colorcolumn")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("nvim.keepVisibleAboveAndBelow")
      suffix: Ui.Strings.t("common.lines")
      value: Number(page.app.nvimValue("scrolloff", 4))
      from: 0
      to: 20
      onCommitted: function(next) { page.app.setNvim("scrolloff", next) }
      changed: page.app.isChanged("nvim:scrolloff")
      onResetRequested: page.app.resetSetting("nvim:scrolloff")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("nvim.spellChecking")
      checked: page.app.nvimValue("spell", false) === true
      onRequested: function(next) { page.app.setNvim("spell", next ? "true" : "false") }
      changed: page.app.isChanged("nvim:spell")
      onResetRequested: page.app.resetSetting("nvim:spell")
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("nvim.indentation")

    Ui.SwitchRow {
      label: Ui.Strings.t("nvim.spacesInsteadOfTabs")
      checked: page.app.nvimValue("expandtab", true) === true
      onRequested: function(next) { page.app.setNvim("expandtab", next ? "true" : "false") }
      changed: page.app.isChanged("nvim:expandtab")
      onResetRequested: page.app.resetSetting("nvim:expandtab")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("nvim.indentWidth")
      suffix: Ui.Strings.t("nvim.spaces")
      value: Number(page.app.nvimValue("shiftwidth", 2))
      from: 1
      to: 8
      onCommitted: function(next) { page.app.setNvim("shiftwidth", next) }
      changed: page.app.isChanged("nvim:shiftwidth")
      onResetRequested: page.app.resetSetting("nvim:shiftwidth")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("nvim.tabWidth")
      suffix: Ui.Strings.t("nvim.spaces")
      value: Number(page.app.nvimValue("tabstop", 2))
      from: 1
      to: 8
      onCommitted: function(next) { page.app.setNvim("tabstop", next) }
      changed: page.app.isChanged("nvim:tabstop")
      onResetRequested: page.app.resetSetting("nvim:tabstop")
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("common.beyondTheseSettings")
    note: Ui.Strings.t("nvim.changesHereApplyTheNext")

    Ui.ActionRow {
      label: Ui.Strings.t("common.theRestOfTheConfig")
      description: Ui.Strings.t("nvim.openOptionsLuaForAnything")
      buttonText: Ui.Strings.t("common.edit")
      onTriggered: page.app.editConfig("$HOME/.config/nvim/lua/config/options.lua")
    }
  }
}
