pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import RbtGui

Pane {
    id: _root
    width: 600
    height: 400
    padding: 8

    property string title: qsTr("Settings")

    ColumnLayout {
        anchors.fill: parent

        Label {
            text: qsTr("UI language")
        }
        Item {
            Layout.fillHeight: true
        }
    }
}
