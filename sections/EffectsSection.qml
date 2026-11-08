import QtQuick
import "../ui" as Ui

// Injected by the window when the page is loaded: the state every
// row reads, and the calls every control makes.
//
// The three things Hyprland draws around and behind windows. Each has a master
// switch, and the settings under it stay visible but inert while it is off —
// they are what the switch turns on, so hiding them would hide the point.
Ui.SectionBody {
  id: page
  property var app: null

  readonly property bool blurOn: app.hyprValue("blur", false) === true
  readonly property bool shadowOn: app.hyprValue("shadow", false) === true
  readonly property bool glowOn: app.hyprValue("glow", false) === true

  Ui.SettingGroup {
    title: Ui.Strings.t("effects.blur")
    note: Ui.Strings.t("effects.blursWhateverIsBehindTranslucent")

    // "Enabled", not the effect's own name: the heading above has already
    // said which effect this is, and a row repeating it read as a second,
    // different Blur.
    Ui.SwitchRow {
      label: Ui.Strings.t("common.enabled")
      checked: page.blurOn
      onRequested: function(next) { page.app.setHypr("blur", next ? "true" : "false") }
      changed: page.app.isChanged("blur")
      onResetRequested: page.app.resetSetting("blur")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("common.size")
      description: Ui.Strings.t("effects.blurRadius")
      enabled: page.blurOn
      value: page.app.hyprValue("blur-size", 8)
      from: 1
      to: 20
      onCommitted: function(next) { page.app.setHypr("blur-size", next) }
      changed: page.app.isChanged("blur-size")
      onResetRequested: page.app.resetSetting("blur-size")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("effects.passes")
      description: Ui.Strings.t("effects.morePassesIsSmootherAnd")
      enabled: page.blurOn
      value: page.app.hyprValue("blur-passes", 1)
      from: 1
      to: 5
      onCommitted: function(next) { page.app.setHypr("blur-passes", next) }
      changed: page.app.isChanged("blur-passes")
      onResetRequested: page.app.resetSetting("blur-passes")
    }

    Ui.FactorRow {
      label: Ui.Strings.t("effects.noise")
      description: Ui.Strings.t("effects.grainMixedIntoTheBlur")
      enabled: page.blurOn
      minimum: 0
      maximum: 0.2
      value: page.app.hyprValue("blur-noise", 0.02)
      onCommitted: function(next) { page.app.setHypr("blur-noise", next) }
      changed: page.app.isChanged("blur-noise")
      onResetRequested: page.app.resetSetting("blur-noise")
    }

    Ui.FactorRow {
      label: Ui.Strings.t("effects.contrast")
      enabled: page.blurOn
      minimum: 0
      maximum: 2
      value: page.app.hyprValue("blur-contrast", 1)
      onCommitted: function(next) { page.app.setHypr("blur-contrast", next) }
      changed: page.app.isChanged("blur-contrast")
      onResetRequested: page.app.resetSetting("blur-contrast")
    }

    Ui.FactorRow {
      label: Ui.Strings.t("effects.brightness")
      enabled: page.blurOn
      minimum: 0
      maximum: 2
      value: page.app.hyprValue("blur-brightness", 1)
      onCommitted: function(next) { page.app.setHypr("blur-brightness", next) }
      changed: page.app.isChanged("blur-brightness")
      onResetRequested: page.app.resetSetting("blur-brightness")
    }

    Ui.PercentRow {
      label: Ui.Strings.t("effects.vibrancy")
      description: Ui.Strings.t("effects.saturationBoostForTheBlurred")
      enabled: page.blurOn
      value: page.app.hyprValue("blur-vibrancy", 0.17)
      onCommitted: function(next) { page.app.setHypr("blur-vibrancy", next) }
      changed: page.app.isChanged("blur-vibrancy")
      onResetRequested: page.app.resetSetting("blur-vibrancy")
    }

    Ui.PercentRow {
      label: Ui.Strings.t("effects.vibrancyDarkness")
      description: Ui.Strings.t("effects.howMuchVibrancyAppliesTo")
      enabled: page.blurOn
      value: page.app.hyprValue("blur-vibrancy-darkness", 0)
      onCommitted: function(next) { page.app.setHypr("blur-vibrancy-darkness", next) }
      changed: page.app.isChanged("blur-vibrancy-darkness")
      onResetRequested: page.app.resetSetting("blur-vibrancy-darkness")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("effects.xRay")
      description: Ui.Strings.t("effects.blursTheWallpaperInsteadOf")
      enabled: page.blurOn
      checked: page.app.hyprValue("blur-xray", false) === true
      onRequested: function(next) { page.app.setHypr("blur-xray", next ? "true" : "false") }
      changed: page.app.isChanged("blur-xray")
      onResetRequested: page.app.resetSetting("blur-xray")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("effects.specialWorkspace")
      description: Ui.Strings.t("effects.blursBehindSpecialWorkspaces")
      enabled: page.blurOn
      checked: page.app.hyprValue("blur-special", false) === true
      onRequested: function(next) { page.app.setHypr("blur-special", next ? "true" : "false") }
      changed: page.app.isChanged("blur-special")
      onResetRequested: page.app.resetSetting("blur-special")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("effects.popups")
      description: Ui.Strings.t("effects.blursBehindMenusAndTooltips")
      enabled: page.blurOn
      checked: page.app.hyprValue("blur-popups", false) === true
      onRequested: function(next) { page.app.setHypr("blur-popups", next ? "true" : "false") }
      changed: page.app.isChanged("blur-popups")
      onResetRequested: page.app.resetSetting("blur-popups")
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("effects.shadow")
    note: Ui.Strings.t("effects.dropShadowCastByWindows")

    // "Enabled", not the effect's own name: the heading above has already
    // said which effect this is, and a row repeating it read as a second,
    // different Blur.
    Ui.SwitchRow {
      label: Ui.Strings.t("common.enabled")
      checked: page.shadowOn
      onRequested: function(next) { page.app.setHypr("shadow", next ? "true" : "false") }
      changed: page.app.isChanged("shadow")
      onResetRequested: page.app.resetSetting("shadow")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("effects.range")
      description: Ui.Strings.t("effects.howFarTheShadowReaches")
      suffix: Ui.Strings.t("common.px")
      enabled: page.shadowOn
      value: page.app.hyprValue("shadow-range", 4)
      from: 0
      to: 50
      onCommitted: function(next) { page.app.setHypr("shadow-range", next) }
      changed: page.app.isChanged("shadow-range")
      onResetRequested: page.app.resetSetting("shadow-range")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("effects.falloff")
      description: Ui.Strings.t("effects.howSharplyTheShadowFades")
      enabled: page.shadowOn
      value: page.app.hyprValue("shadow-render-power", 3)
      from: 1
      to: 4
      onCommitted: function(next) { page.app.setHypr("shadow-render-power", next) }
      changed: page.app.isChanged("shadow-render-power")
      onResetRequested: page.app.resetSetting("shadow-render-power")
    }

    Ui.PercentRow {
      label: Ui.Strings.t("effects.scale")
      description: Ui.Strings.t("effects.sizeOfTheShadowRelative")
      enabled: page.shadowOn
      value: page.app.hyprValue("shadow-scale", 1)
      onCommitted: function(next) { page.app.setHypr("shadow-scale", next) }
      changed: page.app.isChanged("shadow-scale")
      onResetRequested: page.app.resetSetting("shadow-scale")
    }

    Ui.SwitchRow {
      label: Ui.Strings.t("effects.sharp")
      description: Ui.Strings.t("effects.hardEdgedShadowWithNo")
      enabled: page.shadowOn
      checked: page.app.hyprValue("shadow-sharp", false) === true
      onRequested: function(next) { page.app.setHypr("shadow-sharp", next ? "true" : "false") }
      changed: page.app.isChanged("shadow-sharp")
      onResetRequested: page.app.resetSetting("shadow-sharp")
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("effects.glow")
    note: Ui.Strings.t("effects.haloAroundTheFocusedWindow")

    // "Enabled", not the effect's own name: the heading above has already
    // said which effect this is, and a row repeating it read as a second,
    // different Blur.
    Ui.SwitchRow {
      label: Ui.Strings.t("common.enabled")
      checked: page.glowOn
      onRequested: function(next) { page.app.setHypr("glow", next ? "true" : "false") }
      changed: page.app.isChanged("glow")
      onResetRequested: page.app.resetSetting("glow")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("effects.range")
      description: Ui.Strings.t("effects.howFarTheGlowReaches")
      suffix: Ui.Strings.t("common.px")
      enabled: page.glowOn
      value: page.app.hyprValue("glow-range", 10)
      from: 0
      to: 50
      onCommitted: function(next) { page.app.setHypr("glow-range", next) }
      changed: page.app.isChanged("glow-range")
      onResetRequested: page.app.resetSetting("glow-range")
    }

    Ui.NumberRow {
      label: Ui.Strings.t("effects.falloff")
      description: Ui.Strings.t("effects.howSharplyTheGlowFades")
      enabled: page.glowOn
      value: page.app.hyprValue("glow-render-power", 3)
      from: 1
      to: 4
      onCommitted: function(next) { page.app.setHypr("glow-render-power", next) }
      changed: page.app.isChanged("glow-render-power")
      onResetRequested: page.app.resetSetting("glow-render-power")
    }
  }
}
