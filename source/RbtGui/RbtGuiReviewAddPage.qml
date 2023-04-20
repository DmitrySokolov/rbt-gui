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

    property string title: RbtGuiFunctions.basename(appWindow.projectFolder)
    property bool _initialized: false

    StackView.onActivated: {
        _root.openProject(appWindow.projectFolder)
    }

    ListView {
        id: _flist
        anchors.fill: parent
        clip: true

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
    }

    function openProject(projectFolder) {
        if (_root._initialized) { return }
        _flist.model = appWindow.repository
        _flist.model.getModifiedFiles(projectFolder)
        _root._initialized = true
    }
}
