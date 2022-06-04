import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "RbtGuiFunctions.js" as RbtGui

Drawer {
    id: _drawer

    property real itemLeftPadding: 0
    property real itemTopPadding: 0

    Pane {
        anchors.fill: parent
        clip: true

        ColumnLayout {
            anchors.fill: parent

            ItemDelegate {
                id: _addProjectItem
                text: qsTr("Add project...")
                Layout.fillWidth: true
                onClicked: {
                    _drawer.close()
                    fileDialog.open()
                }
            }

            Label {
                text: qsTr("Known projects")
                Layout.fillWidth: true
                leftPadding: _drawer.itemLeftPadding
            }

            ListView {
                id: _knownProjects
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: contentHeight
                Layout.maximumHeight: _addProjectItem.height * Math.min(5, _knownProjects.count)
                clip: true

                ScrollIndicator.vertical: ScrollIndicator {
                    active: true
                }

                model: ListModel {
                    id: _knownProjectsList
                }

                delegate: ItemDelegate {
                    text: RbtGui.basename(name)
                    width: parent.width
                    leftPadding: _drawer.itemLeftPadding * 3
                    //onClicked: {
                    //    _drawer.close()
                    //    openProjectSettings(projectList[index])
                    //}
                }
            }  // ListView: _knownProjects

            //ItemDelegate {
            //    text: qsTr("About...")
            //    Layout.fillWidth: true
            //    onClicked: activatePage("RbtGuiPageAbout.qml")
            //}

            ItemDelegate {
                text: qsTr("Exit")
                Layout.fillWidth: true
                onClicked: Qt.exit(0)
            }

            Item {
                Layout.fillHeight: true
            }

        }  // ColumnLayout

        Component.onCompleted: {
            _drawer.itemLeftPadding = _addProjectItem.leftPadding
            _drawer.itemTopPadding = _addProjectItem.topPadding
            projectList.forEach(val => _knownProjectsList.append({"name": val}))
        }

        Connections {
            target: appSettings
            function onProjectAdded(path) {
                _knownProjectsList.append({"name": path})
            }
        }

    }  // Pane
}  // Drawer
