import QtQuick
import qs.Commons
import "../ui" as Ui

// Injected by the window when the page is loaded: the state every
// row reads, and the calls every control makes.
//
// What this machine is. Every line is a reading; the only thing the page
// writes is the release channel, and that goes through Omarchy's own command
// and its confirmation.
//
// It exists because the answers are otherwise scattered across four tools and
// because the moment anyone needs them — filing a bug — is the moment they
// least want to go looking. Hence "Copy as text": the whole page as one block,
// in the shape a bug report wants.
Ui.SectionBody {
  id: root
  property var app: null

  readonly property var about: app.about
  readonly property var gpus: about.gpus !== undefined ? about.gpus : []
  readonly property var waiting: about.waiting !== undefined ? about.waiting : ({})
  readonly property bool hasUptime: about.uptimeSeconds !== null && about.uptimeSeconds !== undefined

  function known(v) { return v !== null && v !== undefined && v !== "" }

  // Read once when the page opens. None of it changes while you look at it
  // except the uptime, and a page that re-read a hardware inventory every five
  // seconds to move one number would be absurd.
  Component.onCompleted: app.pollAbout()

  // The machine, named once. The SKU is what tells two of the same model
  // apart, and the version and uptime are the two facts anyone helping with a
  // problem asks for first.
  Ui.HeroCard {
    glyph: root.about.chassis === "laptop" ? "" : ""
    title: root.known(root.about.model) ? root.about.model : Ui.Strings.t("about.thisComputer")
    subtitle: {
      var parts = []
      if (root.known(root.about.sku)) parts.push(root.about.sku)
      if (root.known(root.about.version)) parts.push("Omarchy " + root.about.version)
      if (root.hasUptime) parts.push(Ui.Strings.t("about.upFor").arg(root.app.formatDuration(root.about.uptimeSeconds)))
      return parts.join(" · ")
    }

    Ui.Chip {
      text: Ui.Strings.t("about.copyAsText")
      onClicked: root.app.run(["about", "copy"])
    }
  }

  // Side by side while there is room for both: the two lists are read
  // together, and stacked they put the kernel a screen away from the CPU it
  // runs on.
  Grid {
    id: specs
    width: parent.width
    columns: width >= Style.space(620) ? 2 : 1
    columnSpacing: Style.space(16)
    rowSpacing: Style.space(18)
    readonly property real cell: columns === 2 ? (width - columnSpacing) / 2 : width

    Ui.SettingGroup {
      width: specs.cell
      title: Ui.Strings.t("about.hardware")
      framed: true
      rowSpacing: Style.space(10)

      Ui.SpecRow {
        label: Ui.Strings.t("about.model")
        value: (root.known(root.about.model) ? root.about.model : "")
          + (root.known(root.about.sku) ? " (" + root.about.sku + ")" : "")
      }

      Ui.Divider {}

      Ui.SpecRow {
        label: Ui.Strings.t("about.cpu")
        value: (root.known(root.about.cpu) ? root.about.cpu : "")
          + (root.known(root.about.cpuCores)
             ? " (" + Ui.Strings.t("about.coresThreads").arg(root.about.cpuCores).arg(root.about.cpuThreads) + ")" : "")
          + (root.about.cpuFrequency ? " @ " + (Number(root.about.cpuFrequency) / 1000).toFixed(2) + " GHz" : "")
      }

      // One line each: a laptop with switchable graphics has two, and calling
      // one of them "the" GPU is how a bug report ends up describing the
      // wrong one.
      Ui.Divider { visible: !searchHidden && root.gpus.length > 0 }

      Ui.SpecRow {
        visible: !searchHidden && root.gpus.length > 0
        label: Ui.Strings.t("about.gpu")
        value: root.gpus.join("\n")
      }

      Ui.Divider { visible: !searchHidden && root.known(root.about.memoryBytes) }

      Ui.SpecRow {
        visible: !searchHidden && root.known(root.about.memoryBytes)
        label: Ui.Strings.t("about.memory")
        value: root.app.formatBytes(root.about.memoryBytes)
      }

      Ui.Divider { visible: !searchHidden && root.about.disk !== undefined && root.known(root.about.disk.model) }

      Ui.SpecRow {
        visible: !searchHidden && root.about.disk !== undefined && root.known(root.about.disk.model)
        label: Ui.Strings.t("about.disk")
        value: root.about.disk !== undefined
          ? root.about.disk.model + (root.about.disk.size ? " · " + root.app.formatBytes(root.about.disk.size) : "")
          : ""
      }
    }

    Ui.SettingGroup {
      width: specs.cell
      title: Ui.Strings.t("about.software")
      framed: true
      rowSpacing: Style.space(10)

      // The channel rides with the version only when it is not stable: on
      // stable it says nothing a version number does not, on every machine.
      Ui.SpecRow {
        label: Ui.Strings.t("about.os")
        value: root.known(root.about.version) ? "Omarchy " + root.about.version : ""
        tag: root.known(root.about.channel) && root.about.channel !== "stable" ? Ui.Strings.t("about.channelTag").arg(root.about.channel) : ""
      }

      Ui.Divider {}

      Ui.SpecRow {
        label: Ui.Strings.t("about.kernel")
        value: root.known(root.about.kernel) ? root.about.kernel : ""
      }

      Ui.Divider {}

      Ui.SpecRow {
        label: Ui.Strings.t("about.compositor")
        value: root.known(root.about.compositor) ? root.about.compositor : ""
      }

      Ui.Divider { visible: !searchHidden && root.known(root.about.packages) }

      Ui.SpecRow {
        visible: !searchHidden && root.known(root.about.packages)
        label: Ui.Strings.t("about.packages")
        value: root.about.packages + " (pacman)"
      }

      Ui.Divider { visible: !searchHidden && root.hasUptime }

      Ui.SpecRow {
        visible: !searchHidden && root.hasUptime
        label: Ui.Strings.t("about.uptime")
        value: root.app.formatDuration(root.about.uptimeSeconds)
      }

      // Dated from the first line pacman ever wrote, which is the closest
      // thing an Arch install has to a birthday.
      Ui.Divider { visible: !searchHidden && root.known(root.about.osAgeDays) }

      Ui.SpecRow {
        visible: !searchHidden && root.known(root.about.osAgeDays)
        label: Ui.Strings.t("about.osAge")
        value: Ui.Strings.tn("about.days", Number(root.about.osAgeDays)).arg(root.about.osAgeDays)
      }
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("common.updates")
    framed: true
    rowSpacing: Style.space(10)

    Ui.ReadingRow {
      visible: !searchHidden && root.known(root.about.lastUpdate)
      label: Ui.Strings.t("about.lastUpdated")
      description: root.known(root.about.lastUpdate) ? root.about.lastUpdate : ""
      value: root.known(root.about.lastUpdateAt) ? root.app.formatWhen(root.about.lastUpdateAt) : ""
    }

    // From the Packages page's own last check, so the two pages give one
    // answer. Absent until something has checked: a count of zero from a
    // check that never happened would read as "up to date".
    Ui.Divider { visible: !searchHidden && root.known(root.about.lastUpdate) && Number(root.waiting.checkedAt || 0) > 0 }

    Ui.SettingRow {
      visible: !searchHidden && Number(root.waiting.checkedAt || 0) > 0
      label: Ui.Strings.t("about.waitingNow")
      navKeys: Number(root.waiting.count || 0) > 0 ? [{ key: "↵", label: Ui.Strings.t("about.openPackages") }] : []
      onNavActivate: if (Number(root.waiting.count || 0) > 0) root.app.pageId = "packages"

      Ui.Chip {
        anchors.right: parent.right
        visible: Number(root.waiting.count || 0) > 0
        text: Ui.Strings.tn("about.packagesWaiting", Number(root.waiting.count)).arg(root.waiting.count)
        onClicked: root.app.pageId = "packages"
      }

      Text {
        textFormat: Text.PlainText
        anchors.right: parent.right
        visible: Number(root.waiting.count || 0) === 0
        text: Ui.Strings.t("about.upToDate")
        color: Ui.Palette.muted
        font.family: Ui.Palette.fontFamily
        font.pixelSize: Style.font.body
      }
    }

    Ui.Divider { visible: !searchHidden && (root.known(root.about.lastUpdate) || Number(root.waiting.checkedAt || 0) > 0) }

    // Changing it changes what every future update pulls, so it goes to
    // Omarchy's own command and its confirmation rather than being applied
    // from here.
    Ui.PickerRow {
      label: Ui.Strings.t("about.releaseChannel")
      description: root.known(root.about.channel) && root.about.channel !== "stable"
        ? Ui.Strings.t("about.channelNote").arg(root.about.channel) : ""
      options: ["stable", "rc", "dev"]
      value: root.about.channel !== undefined ? root.about.channel : ""
      onPicked: function(next) {
        if (next === root.about.channel) return
        root.app.run(["about", "channel", next])
        root.app.hide()
      }
    }
  }
}
