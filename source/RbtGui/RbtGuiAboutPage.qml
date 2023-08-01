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

    property string title: qsTr("About")

    Label {
        anchors.centerIn: parent
        text: qsTr("Review Board tools GUI")
    }
}
