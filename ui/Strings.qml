pragma Singleton

import QtQuick
import qs.Commons as Commons

// One catalog for the whole window, so a page, a row and the gear all follow
// the language picked under Setup > Language the same way the shell does.
// A string missing from the reader's language falls back to its base
// language (es-MX to es), then to English, one string at a time.
Commons.Translations {
  directory: Qt.resolvedUrl("../i18n")
}
