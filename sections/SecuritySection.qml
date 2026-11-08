import QtQuick
import qs.Commons
import qs.Ui
import "../ui" as Ui

// Injected by the window when the page is loaded: the state every
// row reads, and the calls every control makes.
//
// What can reach this machine, and how you sign in to it. Nothing here is
// written by this window. The firewall is read, never changed: that takes
// root, and Omarchy has no command of its own to hand it to. The ways of
// signing in are Omarchy's own setup and remove scripts, which edit PAM and
// ask for a password in a terminal of their own.
//
// The table exists for one question nothing else on the desktop answers: is
// anything still behind the ports that were opened? A rule outlives the
// program it was opened for, and a port open to the network with nothing
// listening is a door left unlocked for whatever listens there next. Omarchy's
// own SSH removal closes `limit 22/tcp` and nothing else, so a port 22 opened
// any other way is exactly the rule that stays behind.
Ui.SectionBody {
  id: page
  property var app: null

  readonly property var security: app.security
  readonly property var rules: security.rules !== undefined ? security.rules : []
  readonly property var signIn: security.signIn !== undefined ? security.signIn : ({})
  readonly property bool polled: security.installed !== undefined
  readonly property bool firewallOn: security.enabled === true
  readonly property bool letsAllIn: security.incoming === "ACCEPT"
  readonly property string otherFirewall: security.otherFirewall !== undefined ? security.otherFirewall : ""
  readonly property bool showsRules: security.installed === true && (firewallOn || otherFirewall === "")

  function way(id) {
    return signIn[id] !== undefined ? signIn[id]
      : ({ available: false, active: false, canSetup: false, canRemove: false })
  }

  // The menu entry the button runs, and whether there is one to run.
  function entryFor(id) { return (way(id).active ? "remove" : "setup") + ".security." + id }
  function canRun(id) { return way(id).active ? way(id).canRemove === true : way(id).canSetup === true }

  // A program that bound the port opens and closes it as it starts and stops,
  // and setting up a way in finishes in a terminal this page cannot watch.
  Timer {
    interval: 5000
    running: page.app.shown
    repeat: true
    triggeredOnStart: true
    onTriggered: page.app.pollSecurity()
  }

  // The name a reader knows a port by. Only the ones an Omarchy machine
  // opens or is likely to: anything else is a number the reader opened
  // themselves and already has a name for.
  readonly property var portNames: ({
    "22": "SSH",
    "53": "DNS",
    "80": Ui.Strings.t("security.web"),
    "443": Ui.Strings.t("security.web"),
    "53317": "LocalSend"
  })

  function protocols(list) {
    if (list.indexOf("any") !== -1 || list.length > 1) return "TCP + UDP"
    return list.length === 1 ? String(list[0]).toUpperCase() : ""
  }

  function listeningText(rule) {
    if (rule.container === true) return Ui.Strings.t("security.containerAt").arg(rule.to)
    if (rule.by.length > 0) return rule.by.join(", ")
    if (rule.otherUser === true) return Ui.Strings.t("security.anotherUser")
    if (rule.unnamed === true) return Ui.Strings.t("security.systemService")
    if (rule.localOnly === true) return Ui.Strings.t("security.onlyThisMachine")
    return Ui.Strings.t("security.nothing")
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("security.firewall")
    visible: !searchEmpty && page.polled

    // What the rules below sit on top of. A firewall that is off, or one
    // whose default lets everything in, makes the list of open ports
    // meaningless, so that is said here rather than under the table.
    Ui.ReadingRow {
      label: Ui.Strings.t("security.incomingConnections")
      description: {
        if (!page.firewallOn && page.otherFirewall !== "") return Ui.Strings.t("security.rulesNeedPassword")
        if (!page.firewallOn) return Ui.Strings.t("security.everyoneCanReach")
        var parts = []
        if (page.letsAllIn) parts.push(Ui.Strings.t("security.letsAllIn"))
        if (page.security.dockerOpen === true)
          parts.push(Ui.Strings.t("security.dockerOpen"))
        return parts.join(" ")
      }
      value: !page.firewallOn && page.otherFirewall !== "" ? Ui.Strings.t("security.managedBy").arg(page.otherFirewall)
        : page.security.installed !== true ? Ui.Strings.t("security.allNoFirewall")
        : !page.firewallOn ? Ui.Strings.t("security.allFirewallOff")
        : page.letsAllIn ? Ui.Strings.t("security.all") : ""
    }

    Ui.DataTable {
      visible: page.showsRules
      columns: [
        { title: Ui.Strings.t("security.port"), weight: 1 },
        { title: Ui.Strings.t("security.for"), weight: 1.4 },
        { title: Ui.Strings.t("security.protocol"), weight: 1 },
        { title: Ui.Strings.t("security.allowedFrom"), weight: 1.6 },
        { title: Ui.Strings.t("security.listening"), weight: 1.4 }
      ]
      emptyNote: page.security.rulesReadable === false
        ? Ui.Strings.t("security.rulesUnreadable") : Ui.Strings.t("security.noPorts")
      rows: {
        var out = []
        for (var i = 0; i < page.rules.length; i++) {
          var r = page.rules[i]
          var from = r.from === "any" ? Ui.Strings.t("security.anywhere") : String(r.from)
          if (r.interface !== "") from = r.from === "any" ? Ui.Strings.t("security.overInterface").arg(r.interface) : Ui.Strings.t("security.fromOverInterface").arg(from).arg(r.interface)
          // Rate-limited: six attempts in thirty seconds from one address and
          // the rest are dropped, which is what keeps a password-guesser off.
          if (r.action === "limit") from = Ui.Strings.t("security.rateLimited").arg(from)
          out.push({ cells: [
            { text: r.port === "any" ? Ui.Strings.t("security.all")
                : String(r.port).replace(/:/g, "\u2013").replace(/,/g, ", "), strong: true },
            { text: r.container === true ? Ui.Strings.t("security.container")
                : r.app !== "" ? String(r.app)
                : (page.portNames[r.port] !== undefined ? page.portNames[r.port] : ""),
              tag: String(r.comment || "") },
            { text: page.protocols(r.protos) },
            { text: from },
            { text: page.listeningText(r) }
          ] })
        }
        return out
      }
    }
  }

  Ui.SettingGroup {
    title: Ui.Strings.t("security.signingIn")
    visible: !searchEmpty && page.polled

    // Only where there is a reader: the setup cannot do anything without
    // one, and a row offering it on a desktop is a row that can only fail.
    Ui.ActionRow {
      label: Ui.Strings.t("security.fingerprint")
      visible: !searchHidden && (page.way("fingerprint").available || page.way("fingerprint").active)
        && (page.way("fingerprint").canSetup || page.way("fingerprint").canRemove)
      description: page.way("fingerprint").active
        ? Ui.Strings.t("security.fingerprintOn")
        : Ui.Strings.t("security.fingerprintOff")
      buttonText: page.way("fingerprint").active ? Ui.Strings.t("security.removeEllipsis") : Ui.Strings.t("security.setUpEllipsis")
      actionEnabled: page.canRun("fingerprint")
      onTriggered: { page.app.run(["menu", "run", page.entryFor("fingerprint")]); page.app.hide() }
    }

    Ui.ActionRow {
      label: Ui.Strings.t("security.fido2SecurityKey")
      visible: !searchHidden && (page.way("fido2").canSetup || page.way("fido2").canRemove)
      description: page.way("fido2").active
        ? Ui.Strings.t("security.fido2On")
        : Ui.Strings.t("security.fido2Off")
      buttonText: page.way("fido2").active ? Ui.Strings.t("security.removeEllipsis") : Ui.Strings.t("security.setUpEllipsis")
      actionEnabled: page.canRun("fido2")
      onTriggered: { page.app.run(["menu", "run", page.entryFor("fido2")]); page.app.hide() }
    }

    // Whether it takes a password is the half that matters: a server that
    // takes keys only cannot be guessed into. When a config file in the way
    // could not be read, the page says the server is on and stops there.
    Ui.ActionRow {
      label: Ui.Strings.t("security.sshServer")
      visible: !searchHidden && (page.way("sshd").canSetup || page.way("sshd").canRemove || page.way("sshd").active)
      description: !page.way("sshd").active
        ? Ui.Strings.t("security.sshOff")
        : page.way("sshd").passwords === false ? Ui.Strings.t("security.sshKeysOnly")
        : page.way("sshd").passwords === true ? Ui.Strings.t("security.sshPasswords")
        : Ui.Strings.t("security.sshOn")
      buttonText: page.way("sshd").active ? Ui.Strings.t("security.turnOffEllipsis") : Ui.Strings.t("security.setUpEllipsis")
      actionEnabled: page.canRun("sshd")
      onTriggered: { page.app.run(["menu", "run", page.entryFor("sshd")]); page.app.hide() }
    }
  }
}
