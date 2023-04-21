pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import RbtGui

ToolBar {
    id: _toolbar
    width: appWindow.width
    height: RbtGuiConst.tbButtonHeight

    Keys.forwardTo: [stackView]

    RowLayout {
        anchors.fill: parent
        spacing: RbtGuiConst.tbSpacing

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
                spacing: RbtGuiConst.tbSpacing

                component RbtGuiToolButton : ToolButton {
                    Layout.preferredHeight: _toolbar.height
                    Layout.preferredWidth: _toolbar.height
                    ToolTip.visible: hovered || pressed
                    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
                    Universal.accent: "#FFA0A0A0"
                    icon.color: "transparent"
                    icon.width: RbtGuiConst.tbIconWidth
                    icon.height: RbtGuiConst.tbIconHeight
                    display: AbstractButton.IconOnly
                    opacity: parent.enabled ? 1.0 : 0.5
                }

                RbtGuiToolButton {
                    ToolTip.text: qsTr("Menu")

                    id: _tbMenuBtn
                    text: stackView.depth > 1 ? "\u25C0" : "\u2261"
                    font.pixelSize: Qt.application.font.pixelSize * 1.6
                    display: AbstractButton.TextOnly
                    opacity: 1.0

                    onClicked: {
                        if (stackView.depth > 1) {
                            appWindow.activatePreviousPage()
                        } else {
                            drawer.open()
                        }
                    }
                }

                Loader {
                    id: _loader
                }

                Component {
                    id: _repositoryButtons
                    Item {
                        width: _repositoryButtonsRow.implicitWidth
                        height: _repositoryButtonsRow.implicitHeight
                        ButtonGroup {
                            buttons: _repositoryButtonsRow.children
                        }
                        RowLayout {
                            id: _repositoryButtonsRow
                            spacing: RbtGuiConst.tbSpacing
                            enabled: stackView.depth < 2

                            RbtGuiToolButton {
                                id: _repositoryPageBtn
                                ToolTip.text: qsTr("Repository poperties")
                                icon.source: "Icons/repo_props.svg"
                                checkable: true
                                checked: true
                                onClicked: appWindow.activatePage("RbtGuiRepositoryPage.qml", /*clearStack=*/true)
                            }
                            RbtGuiToolButton {
                                ToolTip.text: qsTr("Add review")
                                icon.source: "Icons/review_add.svg"
                                checkable: true
                                onClicked: appWindow.activatePage("RbtGuiReviewAddPage.qml", /*clearStack=*/true)
                            }
                            RbtGuiToolButton {
                                ToolTip.text: qsTr("Update review")
                                icon.source: "Icons/review_update.svg"
                                checkable: true
                                onClicked: appWindow.activatePage("RbtGuiReviewUpdatePage.qml", /*clearStack=*/true)
                            }
                            RbtGuiToolButton {
                                ToolTip.text: qsTr("Close review")
                                icon.source: "Icons/review_close.svg"
                                checkable: true
                                onClicked: appWindow.activatePage("RbtGuiReviewClosePage.qml", /*clearStack=*/true)
                            }
                        }
                        Connections {
                            target: appWindow
                            function onProjectOpened(projectFolder) {
                                _repositoryPageBtn.checked = true
                            }
                        }
                    }
                }  // Component: _repositoryButtons
            }  // RowLayout: _tbRow
        }  // Flickable

        Flickable {
            id: _title
            Layout.fillWidth: true
            Layout.minimumWidth: _toolbar.height *2
            Layout.minimumHeight: _toolbar.height
            Layout.preferredHeight: _toolbar.height
            Layout.maximumHeight: _toolbar.height
            Layout.rightMargin: RbtGuiConst.tbSpacing *2
            contentWidth: _label.width
            contentHeight: _toolbar.height
            contentX: contentWidth - width
            clip: true

            Label {
                id: _label
                text: stackView.currentItem ? stackView.currentItem.title : ""
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

    Connections {
        target: appWindow
        function onProjectOpened(projectFolder) {
            _loader.sourceComponent = _repositoryButtons
        }
    }

}  // ToolBar
