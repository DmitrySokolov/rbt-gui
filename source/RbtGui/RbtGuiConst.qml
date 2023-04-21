pragma Singleton

import QtQuick

QtObject {
    readonly property real  tbIconWidth: 32
    readonly property real  tbIconHeight: 32
    readonly property real  tbIconMargins: 4
    readonly property real  tbButtonWidth: tbIconHeight + tbIconMargins * 2
    readonly property real  tbButtonHeight: tbButtonWidth
    readonly property real  tbSpacing: 4
}
