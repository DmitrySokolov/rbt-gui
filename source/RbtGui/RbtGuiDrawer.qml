pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import RbtGui

Drawer {
    id: _drawer

    required property MainWindow appWindow

    property real itemLeftPadding: 0
    property real itemTopPadding: 0

    Pane {
        anchors.fill: parent
        clip: true

        ColumnLayout {
            anchors.fill: parent

            ItemDelegate {
                id: _addProjectItem
                text: qsTr("Open source folder...")
                Layout.fillWidth: true
                onClicked: {
                    _drawer.close()
                    _drawer.appWindow.fileDialog.open()
                }
            }

            Label {
                text: qsTr("Known source folders")
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
                    required property string name
                    required property int index
                    text: RbtGuiFunctions.basename(name)
                    width: parent.width
                    leftPadding: _drawer.itemLeftPadding * 3
                    onClicked: {
                        _drawer.close()
                        RbtGuiData.openProject(RbtGuiData.projectList[index])
                    }
                }
            }  // ListView: _knownProjects

            ItemDelegate {
                text: qsTr("Settings...")
                Layout.fillWidth: true
                onClicked: _drawer.appWindow.activatePage("RbtGuiSettingsPage.qml")
            }

            ItemDelegate {
                text: qsTr("About...")
                Layout.fillWidth: true
                onClicked: _drawer.appWindow.activatePage("RbtGuiAboutPage.qml")
            }

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
        }

        Connections {
            target: _drawer.appWindow.appSettings
            function onProjectAdded(path) {
                _knownProjectsList.append({"name": path})
            }
            function onLoaded() {
                RbtGuiData.projectList.forEach(val => _knownProjectsList.append({"name": val}))
            }
        }

    }  // Pane
}  // Drawer
