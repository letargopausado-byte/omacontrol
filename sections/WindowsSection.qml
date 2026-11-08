import QtQuick
import "../ui" as Ui

// Injected by the window when the page is loaded: the state every
// row reads, and the calls every control makes.
Ui.SectionBody {
  id: page
  property var app: null
  Ui.SettingGroup {
    title: Ui.Strings.t("windows.gapsAndBorders")

    Ui.NumberRow {
      label: Ui.Strings.t("windows.innerGaps")
      suffix: Ui.Strings.t("common.px")
      value: page.app.hyprValue("gaps-in", 0)
      from: 0
      to: 40
      onCommitted: function(next) { page.app.setHypr("gaps-in", next) }
      changed: page.app.isChanged("gaps-in")
      onResetRequested: page.app.resetSetting("gaps-in")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("windows.outerGaps")
      suffix: Ui.Strings.t("common.px")
      value: page.app.hyprValue("gaps-out", 0)
      from: 0
      to: 60
      onCommitted: function(next) { page.app.setHypr("gaps-out", next) }
      changed: page.app.isChanged("gaps-out")
      onResetRequested: page.app.resetSetting("gaps-out")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("windows.borderWidth")
      suffix: Ui.Strings.t("common.px")
      value: page.app.hyprValue("border-size", 0)
      from: 0
      to: 10
      onCommitted: function(next) { page.app.setHypr("border-size", next) }
      changed: page.app.isChanged("border-size")
      onResetRequested: page.app.resetSetting("border-size")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("windows.floatingGaps")
      description: Ui.Strings.t("windows.gapAroundFloatingWindows0")
      suffix: Ui.Strings.t("common.px")
      value: page.app.hyprValue("float-gaps", 0)
      from: 0
      to: 40
      onCommitted: function(next) { page.app.setHypr("float-gaps", next) }
      changed: page.app.isChanged("float-gaps")
      onResetRequested: page.app.resetSetting("float-gaps")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("windows.workspaceGaps")
      description: Ui.Strings.t("windows.extraSpaceBetweenWorkspacesWhile")
      suffix: Ui.Strings.t("common.px")
      value: page.app.hyprValue("gaps-workspaces", 0)
      from: 0
      to: 100
      onCommitted: function(next) { page.app.setHypr("gaps-workspaces", next) }
      changed: page.app.isChanged("gaps-workspaces")
      onResetRequested: page.app.resetSetting("gaps-workspaces")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("windows.borderInsideWindow")
      description: Ui.Strings.t("windows.countsTheBorderAsPart")
      checked: page.app.hyprValue("border-part-of-window", true) === true
      onRequested: function(next) { page.app.setHypr("border-part-of-window", next ? "true" : "false") }
      changed: page.app.isChanged("border-part-of-window")
      onResetRequested: page.app.resetSetting("border-part-of-window")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("windows.cornerRounding")
      suffix: Ui.Strings.t("common.px")
      value: page.app.hyprValue("rounding", 0)
      from: 0
      to: 30
      onCommitted: function(next) { page.app.setHypr("rounding", next) }
      changed: page.app.isChanged("rounding")
      onResetRequested: page.app.resetSetting("rounding")
    }

    Ui.FactorRow {
      label: Ui.Strings.t("windows.roundnessCurve")
      description: Ui.Strings.t("windows.20IsACircle")
      minimum: 1
      maximum: 10
      value: page.app.hyprValue("rounding-power", 2)
      onCommitted: function(next) { page.app.setHypr("rounding-power", next) }
      changed: page.app.isChanged("rounding-power")
      onResetRequested: page.app.resetSetting("rounding-power")
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("windows.snapping")

    // "Enabled": the heading has already said which setting this is.
    Ui.SwitchRow {
      label: Ui.Strings.t("common.enabled")
      description: Ui.Strings.t("windows.snapFloatingWindowsToEach")
      checked: page.app.hyprValue("snap", false) === true
      onRequested: function(next) { page.app.setHypr("snap", next ? "true" : "false") }
      changed: page.app.isChanged("snap")
      onResetRequested: page.app.resetSetting("snap")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("windows.snapDistance")
      description: Ui.Strings.t("windows.howCloseAFloatingWindow")
      suffix: Ui.Strings.t("common.px")
      enabled: page.app.hyprValue("snap", false) === true
      value: page.app.hyprValue("snap-window-gap", 10)
      from: 0
      to: 50
      onCommitted: function(next) { page.app.setHypr("snap-window-gap", next) }
      changed: page.app.isChanged("snap-window-gap")
      onResetRequested: page.app.resetSetting("snap-window-gap")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("windows.snapToEdges")
      description: Ui.Strings.t("windows.howCloseAFloatingWindow2")
      suffix: Ui.Strings.t("common.px")
      enabled: page.app.hyprValue("snap", false) === true
      value: page.app.hyprValue("snap-monitor-gap", 10)
      from: 0
      to: 50
      onCommitted: function(next) { page.app.setHypr("snap-monitor-gap", next) }
      changed: page.app.isChanged("snap-monitor-gap")
      onResetRequested: page.app.resetSetting("snap-monitor-gap")
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("windows.focusAndDepth")

    Ui.SwitchRow {
      label: Ui.Strings.t("windows.fullOpacity")
      description: Ui.Strings.t("windows.omarchyFadesEveryWindowTo")
      checked: page.app.hyprValue("opaque-windows", false) === true
      onRequested: function(next) { page.app.setHypr("opaque-windows", next ? "true" : "false") }
      changed: page.app.isChanged("opaque-windows")
      onResetRequested: page.app.resetSetting("opaque-windows")
    }

    Ui.PercentRow {
      label: Ui.Strings.t("windows.activeWindowOpacity")
      value: page.app.hyprValue("active-opacity", 1)
      onCommitted: function(next) { page.app.setHypr("active-opacity", next) }
      changed: page.app.isChanged("active-opacity")
      onResetRequested: page.app.resetSetting("active-opacity")
    }

    Ui.PercentRow {
      label: Ui.Strings.t("windows.inactiveWindowOpacity")
      value: page.app.hyprValue("inactive-opacity", 1)
      onCommitted: function(next) { page.app.setHypr("inactive-opacity", next) }
      changed: page.app.isChanged("inactive-opacity")
      onResetRequested: page.app.resetSetting("inactive-opacity")
    }

    Ui.PercentRow {
      label: Ui.Strings.t("windows.fullscreenOpacity")
      description: Ui.Strings.t("windows.opacityWhileAWindowIs")
      value: page.app.hyprValue("fullscreen-opacity", 1)
      onCommitted: function(next) { page.app.setHypr("fullscreen-opacity", next) }
      changed: page.app.isChanged("fullscreen-opacity")
      onResetRequested: page.app.resetSetting("fullscreen-opacity")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("windows.dimInactiveWindows")
      checked: page.app.hyprValue("dim-inactive", false) === true
      onRequested: function(next) { page.app.setHypr("dim-inactive", next ? "true" : "false") }
      changed: page.app.isChanged("dim-inactive")
      onResetRequested: page.app.resetSetting("dim-inactive")
    }

    Ui.PercentRow {
      label: Ui.Strings.t("windows.dimStrength")
      enabled: page.app.hyprValue("dim-inactive", false) === true
      value: page.app.hyprValue("dim-strength", 0.5)
      onCommitted: function(next) { page.app.setHypr("dim-strength", next) }
      changed: page.app.isChanged("dim-strength")
      onResetRequested: page.app.resetSetting("dim-strength")
    }

    Ui.PercentRow {
      label: Ui.Strings.t("windows.specialWorkspaceDim")
      description: Ui.Strings.t("windows.dimmingAppliedBehindASpecial")
      value: page.app.hyprValue("dim-special", 0.2)
      onCommitted: function(next) { page.app.setHypr("dim-special", next) }
      changed: page.app.isChanged("dim-special")
      onResetRequested: page.app.resetSetting("dim-special")
    }

    Ui.PercentRow {
      label: Ui.Strings.t("windows.dimAround")
      description: Ui.Strings.t("windows.dimmingBehindWindowsUsingThe")
      value: page.app.hyprValue("dim-around", 0.4)
      onCommitted: function(next) { page.app.setHypr("dim-around", next) }
      changed: page.app.isChanged("dim-around")
      onResetRequested: page.app.resetSetting("dim-around")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("windows.dimBehindModals")
      description: Ui.Strings.t("windows.darkensAWindowWhileOne")
      checked: page.app.hyprValue("dim-modal", true) === true
      onRequested: function(next) { page.app.setHypr("dim-modal", next ? "true" : "false") }
      changed: page.app.isChanged("dim-modal")
      onResetRequested: page.app.resetSetting("dim-modal")
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("windows.animations")

    Ui.SwitchRow {
      label: Ui.Strings.t("common.enabled")
      checked: page.app.hyprValue("animations", true) === true
      onRequested: function(next) { page.app.setHypr("animations", next ? "true" : "false") }
      changed: page.app.isChanged("animations")
      onResetRequested: page.app.resetSetting("animations")
    }

    Ui.FactorRow {
      label: Ui.Strings.t("windows.speed")
      description: Ui.Strings.t("windows.aMultiplierOverTheAnimation")
      enabled: page.app.hyprValue("animations", true) === true
      minimum: 0.25
      maximum: 3
      value: page.app.hyprValue("animation-speed", 1)
      onCommitted: function(next) { page.app.setHypr("animation-speed", next) }
      changed: page.app.isChanged("animation-speed")
      onResetRequested: page.app.resetSetting("animation-speed")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("windows.wrapWorkspaces")
      description: Ui.Strings.t("windows.slidesTheShortWayWhen")
      enabled: page.app.hyprValue("animations", true) === true
      checked: page.app.hyprValue("animations-wraparound", false) === true
      onRequested: function(next) { page.app.setHypr("animations-wraparound", next ? "true" : "false") }
      changed: page.app.isChanged("animations-wraparound")
      onResetRequested: page.app.resetSetting("animations-wraparound")
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("common.beyondTheseSettings")

    Ui.ActionRow {
      label: Ui.Strings.t("windows.windowRulesAndAnimations")
      description: Ui.Strings.t("windows.openLooknfeelLuaForAnything")
      buttonText: Ui.Strings.t("common.edit")
      onTriggered: page.app.run(["menu", "run", "style.hyprland"])
    }
  }
}
