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

    required property MainWindow appWindow

    property string title: RbtGuiFunctions.basename(RbtGuiData.projectFolder) + " - " + qsTr("Update review")

    ColumnLayout {
        anchors.fill: parent

        Label {
            text: qsTr("Update review")
        }
        Item {
            Layout.fillHeight: true
        }
    }
}
