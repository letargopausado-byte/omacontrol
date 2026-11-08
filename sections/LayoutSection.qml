import QtQuick
import "../ui" as Ui

// Injected by the window when the page is loaded: the state every
// row reads, and the calls every control makes.
//
// The tiling engine, and the knobs belonging to whichever one is running.
// Showing all three engines' settings at once would mostly show settings that
// do nothing, so each group appears only when its engine is the active one.
Ui.SectionBody {
  id: page
  property var app: null

  readonly property string engine: String(app.hyprValue("layout", "dwindle"))

  Ui.SettingGroup {
    title: Ui.Strings.t("layout.engine")

    Ui.ChoiceRow {
      label: Ui.Strings.t("common.layout")
      description: Ui.Strings.t("layout.scrollingGivesYouNiriStyle")
      value: page.engine
      options: [
        { value: "dwindle", label: Ui.Strings.t("layout.dwindle") },
        { value: "master", label: Ui.Strings.t("layout.master") },
        { value: "scrolling", label: Ui.Strings.t("layout.scrolling") }
      ]
      onPicked: function(next) { page.app.setHypr("layout", next) }
      changed: page.app.isChanged("layout")
      onResetRequested: page.app.resetSetting("layout")
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("layout.dwindle")
    visible: !searchEmpty && page.engine === "dwindle"

    Ui.SwitchRow {
      label: Ui.Strings.t("layout.preserveSplit")
      description: Ui.Strings.t("layout.keepsTheSplitDirectionWhen")
      checked: page.app.hyprValue("dwindle-preserve-split", true) === true
      onRequested: function(next) { page.app.setHypr("dwindle-preserve-split", next ? "true" : "false") }
      changed: page.app.isChanged("dwindle-preserve-split")
      onResetRequested: page.app.resetSetting("dwindle-preserve-split")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("layout.smartSplit")
      description: Ui.Strings.t("layout.picksTheSplitDirectionFrom")
      checked: page.app.hyprValue("dwindle-smart-split", false) === true
      onRequested: function(next) { page.app.setHypr("dwindle-smart-split", next ? "true" : "false") }
      changed: page.app.isChanged("dwindle-smart-split")
      onResetRequested: page.app.resetSetting("dwindle-smart-split")
    }

    Ui.ChoiceRow {
      label: Ui.Strings.t("layout.splitSide")
      description: Ui.Strings.t("layout.whereANewWindowLands")
      value: String(page.app.hyprValue("dwindle-force-split", 0))
      options: [
        { value: "0", label: Ui.Strings.t("layout.cursor") },
        { value: "1", label: Ui.Strings.t("layout.before") },
        { value: "2", label: Ui.Strings.t("layout.after") }
      ]
      onPicked: function(next) { page.app.setHypr("dwindle-force-split", next) }
      changed: page.app.isChanged("dwindle-force-split")
      onResetRequested: page.app.resetSetting("dwindle-force-split")
    }

    Ui.FactorRow {
      label: Ui.Strings.t("layout.splitBias")
      description: Ui.Strings.t("layout.above10FavoursSplitting")
      minimum: 0.5
      maximum: 2
      value: page.app.hyprValue("dwindle-split-width-multiplier", 1)
      onCommitted: function(next) { page.app.setHypr("dwindle-split-width-multiplier", next) }
      changed: page.app.isChanged("dwindle-split-width-multiplier")
      onResetRequested: page.app.resetSetting("dwindle-split-width-multiplier")
    }

    Ui.FactorRow {
      label: Ui.Strings.t("layout.splitRatio")
      description: Ui.Strings.t("layout.sizeOfANewSplit")
      minimum: 0.5
      maximum: 1.5
      value: page.app.hyprValue("dwindle-default-split-ratio", 1)
      onCommitted: function(next) { page.app.setHypr("dwindle-default-split-ratio", next) }
      changed: page.app.isChanged("dwindle-default-split-ratio")
      onResetRequested: page.app.resetSetting("dwindle-default-split-ratio")
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("layout.master")
    visible: !searchEmpty && page.engine === "master"

    Ui.PercentRow {
      label: Ui.Strings.t("layout.masterSize")
      description: Ui.Strings.t("layout.fractionOfTheScreenThe")
      value: page.app.hyprValue("master-mfact", 0.55)
      onCommitted: function(next) { page.app.setHypr("master-mfact", next) }
      changed: page.app.isChanged("master-mfact")
      onResetRequested: page.app.resetSetting("master-mfact")
    }

    Ui.ChoiceRow {
      label: Ui.Strings.t("layout.masterSide")
      description: Ui.Strings.t("layout.whichEdgeTheMasterWindow")
      value: String(page.app.hyprValue("master-orientation", "left"))
      options: [
        { value: "left", label: Ui.Strings.t("layout.left") },
        { value: "right", label: Ui.Strings.t("layout.right") },
        { value: "top", label: Ui.Strings.t("common.top") },
        { value: "bottom", label: Ui.Strings.t("common.bottom") },
        { value: "center", label: Ui.Strings.t("layout.center") }
      ]
      onPicked: function(next) { page.app.setHypr("master-orientation", next) }
      changed: page.app.isChanged("master-orientation")
      onResetRequested: page.app.resetSetting("master-orientation")
    }

    Ui.ChoiceRow {
      label: Ui.Strings.t("layout.newWindows")
      description: Ui.Strings.t("layout.whereANewlyOpenedWindow")
      value: String(page.app.hyprValue("master-new-status", "master"))
      options: [
        { value: "master", label: Ui.Strings.t("layout.master") },
        { value: "slave", label: Ui.Strings.t("layout.slave") },
        { value: "inherit", label: Ui.Strings.t("layout.inherit") }
      ]
      onPicked: function(next) { page.app.setHypr("master-new-status", next) }
      changed: page.app.isChanged("master-new-status")
      onResetRequested: page.app.resetSetting("master-new-status")
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("layout.scrolling")
    visible: !searchEmpty && page.engine === "scrolling"

    Ui.PercentRow {
      label: Ui.Strings.t("layout.columnWidth")
      description: Ui.Strings.t("layout.fractionOfTheScreenOne")
      value: page.app.hyprValue("scrolling-column-width", 0.5)
      onCommitted: function(next) { page.app.setHypr("scrolling-column-width", next) }
      changed: page.app.isChanged("scrolling-column-width")
      onResetRequested: page.app.resetSetting("scrolling-column-width")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("layout.fillOnOneColumn")
      description: Ui.Strings.t("layout.letsALoneColumnUse")
      checked: page.app.hyprValue("scrolling-fullscreen-on-one-column", false) === true
      onRequested: function(next) { page.app.setHypr("scrolling-fullscreen-on-one-column", next ? "true" : "false") }
      changed: page.app.isChanged("scrolling-fullscreen-on-one-column")
      onResetRequested: page.app.resetSetting("scrolling-fullscreen-on-one-column")
    }
  }
}
