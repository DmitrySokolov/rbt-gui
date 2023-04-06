pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import RbtGui

Popup {
    id: _popup
    modal: true
    closePolicy: Popup.CloseOnEscape

    anchors.centerIn: Overlay.overlay
    width: 500
    height: 250

    Overlay.modal: Rectangle {
        color: "#f0333333"
    }
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
    }

    property real mbSpacing: 8

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: _popup.mbSpacing
        spacing: _popup.mbSpacing

        Label {
            id: _title
            text: "Title"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            font.weight: Font.ExtraBold
            Layout.fillWidth: true
            Layout.bottomMargin: _popup.mbSpacing * 2
        }
        Label {
            id: _message
            text: "The text of the message."
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: _button_ok.height
            Layout.topMargin: _popup.mbSpacing
            spacing: _popup.mbSpacing * 2
            Item {
                Layout.fillWidth: true
            }
            Button {
                id: _button_ok
                text: "OK"
                onClicked: {
                    _popup.close()
                    if (_popup._callerID !== 0) { _popup.accepted(_popup._callerID) }
                }
            }
            Button {
                id: _button_cancel
                text: qsTr("Cancel")
                onClicked: {
                    _popup.close()
                    if (_popup._callerID !== 0) { _popup.rejected(_popup._callerID) }
                }
            }
            Item {
                Layout.fillWidth: true
            }
        }
    }

    Component.onCompleted: {
        const width_ = Math.max(_button_ok.height * 2, _button_ok.implicitWidth, _button_cancel.implicitWidth)
        _button_ok.Layout.preferredWidth = width_
        _button_cancel.Layout.preferredWidth = width_
    }

    signal accepted(questionID: int)
    signal rejected(questionID: int)

    property int _callerID: 0

    function showMessage(message, title, callerID, buttons) {
        var id_ = callerID || 0
        var buttons_ = id_ !== 0 ? (buttons || 2) : 1
        _title.text = title
        _message.text = message
        _button_cancel.visible = buttons_ >= 2
        _callerID = id_
        _popup.open()
    }
}
