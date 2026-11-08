import QtQuick
import "../ui" as Ui

// Injected by the window when the page is loaded: the state every
// row reads, and the calls every control makes.
//
// The tab strip drawn on grouped windows. Its colours come from the theme.
Ui.SectionBody {
  id: page
  property var app: null

  readonly property bool barOn: app.hyprValue("groupbar", true) === true

  Ui.SettingGroup {
    title: Ui.Strings.t("groups.groupBar")

    Ui.SwitchRow {
      label: Ui.Strings.t("groups.groupBar")
      description: Ui.Strings.t("groups.showsTheTabStripOn")
      checked: page.barOn
      onRequested: function(next) { page.app.setHypr("groupbar", next ? "true" : "false") }
      changed: page.app.isChanged("groupbar")
      onResetRequested: page.app.resetSetting("groupbar")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("groups.height")
      suffix: Ui.Strings.t("common.px")
      enabled: page.barOn
      value: page.app.hyprValue("groupbar-height", 14)
      from: 0
      to: 40
      onCommitted: function(next) { page.app.setHypr("groupbar-height", next) }
      changed: page.app.isChanged("groupbar-height")
      onResetRequested: page.app.resetSetting("groupbar-height")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("groups.fontSize")
      suffix: Ui.Strings.t("common.px")
      enabled: page.barOn
      value: page.app.hyprValue("groupbar-font-size", 8)
      from: 6
      to: 24
      onCommitted: function(next) { page.app.setHypr("groupbar-font-size", next) }
      changed: page.app.isChanged("groupbar-font-size")
      onResetRequested: page.app.resetSetting("groupbar-font-size")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("groups.showTitles")
      description: Ui.Strings.t("groups.drawsWindowTitlesInThe")
      enabled: page.barOn
      checked: page.app.hyprValue("groupbar-render-titles", true) === true
      onRequested: function(next) { page.app.setHypr("groupbar-render-titles", next ? "true" : "false") }
      changed: page.app.isChanged("groupbar-render-titles")
      onResetRequested: page.app.resetSetting("groupbar-render-titles")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("groups.indicatorHeight")
      description: Ui.Strings.t("groups.thicknessOfTheActiveTab")
      suffix: Ui.Strings.t("common.px")
      enabled: page.barOn
      value: page.app.hyprValue("groupbar-indicator-height", 3)
      from: 0
      to: 12
      onCommitted: function(next) { page.app.setHypr("groupbar-indicator-height", next) }
      changed: page.app.isChanged("groupbar-indicator-height")
      onResetRequested: page.app.resetSetting("groupbar-indicator-height")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("groups.rounding")
      description: Ui.Strings.t("groups.cornerRadiusOfTheTabs")
      suffix: Ui.Strings.t("common.px")
      enabled: page.barOn
      value: page.app.hyprValue("groupbar-rounding", 1)
      from: 0
      to: 20
      onCommitted: function(next) { page.app.setHypr("groupbar-rounding", next) }
      changed: page.app.isChanged("groupbar-rounding")
      onResetRequested: page.app.resetSetting("groupbar-rounding")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("groups.gradients")
      description: Ui.Strings.t("groups.fadesTheTabBackgrounds")
      enabled: page.barOn
      checked: page.app.hyprValue("groupbar-gradients", false) === true
      onRequested: function(next) { page.app.setHypr("groupbar-gradients", next ? "true" : "false") }
      changed: page.app.isChanged("groupbar-gradients")
      onResetRequested: page.app.resetSetting("groupbar-gradients")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("groups.stacked")
      description: Ui.Strings.t("groups.laysTheTabsOutVertically")
      enabled: page.barOn
      checked: page.app.hyprValue("groupbar-stacked", false) === true
      onRequested: function(next) { page.app.setHypr("groupbar-stacked", next ? "true" : "false") }
      changed: page.app.isChanged("groupbar-stacked")
      onResetRequested: page.app.resetSetting("groupbar-stacked")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("groups.hideWhenAlone")
      description: Ui.Strings.t("groups.hidesTheStripWhenThe")
      enabled: page.barOn
      checked: page.app.hyprValue("groupbar-disable-when-only", false) === true
      onRequested: function(next) { page.app.setHypr("groupbar-disable-when-only", next ? "true" : "false") }
      changed: page.app.isChanged("groupbar-disable-when-only")
      onResetRequested: page.app.resetSetting("groupbar-disable-when-only")
    }
  }
}
