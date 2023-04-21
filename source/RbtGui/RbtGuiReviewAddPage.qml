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

    property string title: RbtGuiFunctions.basename(appWindow.projectFolder) + " - " + qsTr("Add review")
    property bool _initialized: false

    StackView.onActivated: {
        _root.openProject(appWindow.projectFolder)
    }

    SplitView {
        id: _splitView
        anchors.fill: parent
        anchors.margins: 0
        spacing: 5

        ColumnLayout {
            SplitView.preferredWidth: _splitView.width * 0.6
            SplitView.minimumWidth: _splitView.width * 0.25

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.rightMargin: 8

                Label {
                    text: qsTr("Modified files")
                }

                ListView {
                    id: _flist
                    clip: true
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    model: ListModel {
                        ListElement {
                            file_checked: false
                            file_name: "<empty>"
                        }
                    }

                    delegate: Item {
                        id: _d
                        width: _flist.width
                        height: _file_name.height * 1.5

                        required property bool file_checked
                        required property string file_name
                        RowLayout {
                            CheckBox {
                                checked: _d.file_checked
                            }
                            Label {
                                id: _file_name
                                text: _d.file_name
                                Layout.fillWidth: true
                            }
                        }
                    }
                }  // ListView: _flist
            }
        }  // ColumnLayout

        ColumnLayout {
            SplitView.fillWidth: true
            SplitView.minimumWidth: _splitView.width * 0.25

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: 8

                Label {
                    text: qsTr("Bugs closed")
                    Layout.fillWidth: true
                }
                TextField {
                    id: _bugsClosed
                    text: ""
                    Layout.fillWidth: true
                }

                RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout {
                        Layout.fillWidth: true
                        Label {
                            text: qsTr("Review summary")
                            Layout.fillWidth: true
                        }
                        TextField {
                            id: _summary
                            text: ""
                            Layout.fillWidth: true
                        }
                    }
                    Button {
                        Layout.preferredWidth: RbtGuiConst.tbButtonWidth
                        Layout.preferredHeight: RbtGuiConst.tbButtonHeight
                        Layout.alignment: Qt.AlignBottom
                        ToolTip.visible: hovered || pressed
                        ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
                        ToolTip.text: qsTr("Fetch summary using bug ID")
                        icon.source: "Icons/bugz_fetch.svg"
                        icon.color: "transparent"
                        icon.width: RbtGuiConst.tbIconWidth
                        icon.height: RbtGuiConst.tbIconHeight
                        display: AbstractButton.IconOnly
                    }
                }

                Label {
                    text: qsTr("Review description")
                    Layout.fillWidth: true
                    Layout.topMargin: 5
                }
                ScrollView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: _summary.height * 3
                    TextArea {
                        id: _description
                        text: ""
                    }
                }

                Label {
                    text: qsTr("Testing done")
                    Layout.fillWidth: true
                    Layout.topMargin: 5
                }
                ScrollView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: _summary.height * 3
                    TextArea {
                        id: _testingDone
                        text: ""
                    }
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillHeight: true
                    Layout.topMargin: 5
                    Button {
                        text: qsTr("View diff")
                        Layout.preferredWidth: 120
                    }
                    Button {
                        text: qsTr("Post review")
                        Layout.preferredWidth: 120
                    }
                    Item {
                        Layout.fillHeight: true
                    }
                }
            }  // ColumnLayout
        }  // ColumnLayout
    }  // SplitView: _splitView

    function openProject(projectFolder) {
        if (_root._initialized) { return }
        _flist.model = appWindow.repository
        _flist.model.getModifiedFiles(projectFolder)
        _root._initialized = true
    }
}
