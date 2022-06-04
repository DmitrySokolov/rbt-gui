import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ToolBar {
    id: _toolbar
    width: appWindow.width
    height: tbIconHeight + tbIconMargins + tbIconMargins

    Keys.forwardTo: [stackView]

    RowLayout {
        anchors.fill: parent
        spacing: tbSpacing

        Flickable {
            Layout.fillWidth: true
            Layout.minimumWidth: _toolbar.height * 2
            Layout.preferredWidth: _tbRow.implicitWidth
            Layout.maximumWidth: _tbRow.implicitWidth
            Layout.minimumHeight: _toolbar.height
            Layout.preferredHeight: _toolbar.height
            Layout.maximumHeight: _toolbar.height
            contentWidth: _tbRow.implicitWidth
            contentHeight: _toolbar.height
            clip: true

            RowLayout {
                id: _tbRow
                spacing: tbSpacing

                ToolButton {
                    ToolTip.text: qsTr("Menu")
                    ToolTip.visible: hovered || pressed
                    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval

                    id: _tbMenuBtn
                    text: stackView.depth > 1 ? "\u25C0" : "\u2261"
                    font.pixelSize: Qt.application.font.pixelSize * 1.6
                    Layout.preferredHeight: _toolbar.height
                    Layout.preferredWidth: _toolbar.height
                    onClicked: {
                        if (stackView.depth > 1) {
                            activatePreviousPage()
                        } else {
                            drawer.open()
                        }
                    }
                }

            }  // RowLayout: _tbRow
        }  // Flickable

        Flickable {
            id: _title
            Layout.fillWidth: true
            Layout.minimumWidth: _toolbar.height *2
            Layout.minimumHeight: _toolbar.height
            Layout.preferredHeight: _toolbar.height
            Layout.maximumHeight: _toolbar.height
            Layout.rightMargin: tbSpacing + tbSpacing
            contentWidth: _label.width
            contentHeight: _toolbar.height
            contentX: contentWidth - width
            clip: true

            Label {
                id: _label
                text: stackView.currentItem.title
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                width: Math.max(implicitWidth, _title.width)
                height: _toolbar.height
            }
        }  // Flickable: _title

    }  // RowLayout

    Component.onCompleted: {
        _tbMenuBtn.ToolTip.toolTip.contentItem.wrapMode = Text.WordWrap
        _tbMenuBtn.ToolTip.toolTip.contentWidth = Qt.binding(() => Math.min(appWindow.width, _tbMenuBtn.ToolTip.toolTip.contentItem.implicitWidth))
        _tbMenuBtn.ToolTip.toolTip.y = Qt.binding(() => parent.y + parent.implicitHeight + 16)
    }

    //function _enableButton(btn, isEnabled) {
    //    btn.enabled = isEnabled
    //    btn.opacity = (isEnabled ? 1.0 : 0.5)
    //}
    //
    //function enableButtons(isEnabled) {
    //}

}  // ToolBar
