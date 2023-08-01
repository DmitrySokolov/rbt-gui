pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import RbtGui

ToolBar {
    id: _toolbar

    required property MainWindow appWindow

    width: appWindow.width
    height: RbtGuiData.tbButtonHeight

    Keys.forwardTo: [appWindow.stackView]

    RowLayout {
        anchors.fill: parent
        spacing: RbtGuiData.tbSpacing

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
                spacing: RbtGuiData.tbSpacing

                component RbtGuiToolButton : ToolButton {
                    Layout.preferredHeight: _toolbar.height
                    Layout.preferredWidth: _toolbar.height
                    ToolTip.visible: hovered || pressed
                    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
                    Universal.accent: "#FFA0A0A0"
                    icon.color: "transparent"
                    icon.width: RbtGuiData.tbIconWidth
                    icon.height: RbtGuiData.tbIconHeight
                    display: AbstractButton.IconOnly
                    opacity: parent.enabled ? 1.0 : 0.5
                }

                RbtGuiToolButton {
                    ToolTip.text: qsTr("Menu")

                    id: _tbMenuBtn
                    text: _toolbar.appWindow.stackView.depth > 1 ? "\u25C0" : "\u2261"
                    font.pixelSize: Qt.application.font.pixelSize * 1.6
                    display: AbstractButton.TextOnly
                    opacity: 1.0

                    onClicked: {
                        if (_toolbar.appWindow.stackView.depth > 1) {
                            _toolbar.appWindow.activatePreviousPage()
                        } else {
                            _toolbar.appWindow.openDrawer()
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
                            spacing: RbtGuiData.tbSpacing
                            enabled: _toolbar.appWindow.stackView.depth < 2

                            RbtGuiToolButton {
                                id: _repositoryPageBtn
                                ToolTip.text: qsTr("Repository poperties")
                                icon.source: "Icons/repo_props.svg"
                                checkable: true
                                checked: true
                                onClicked: _toolbar.appWindow.activatePage("RbtGuiRepositoryPage.qml", /*clearStack=*/true)
                            }
                            RbtGuiToolButton {
                                ToolTip.text: qsTr("Add review")
                                icon.source: "Icons/review_add.svg"
                                checkable: true
                                onClicked: _toolbar.appWindow.activatePage("RbtGuiReviewAddPage.qml", /*clearStack=*/true)
                            }
                            RbtGuiToolButton {
                                ToolTip.text: qsTr("Update review")
                                icon.source: "Icons/review_update.svg"
                                checkable: true
                                onClicked: _toolbar.appWindow.activatePage("RbtGuiReviewUpdatePage.qml", /*clearStack=*/true)
                            }
                            RbtGuiToolButton {
                                ToolTip.text: qsTr("Close review")
                                icon.source: "Icons/review_close.svg"
                                checkable: true
                                onClicked: _toolbar.appWindow.activatePage("RbtGuiReviewClosePage.qml", /*clearStack=*/true)
                            }
                        }
                        Connections {
                            target: RbtGuiData
                            function onProjectOpened(path) {
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
            Layout.rightMargin: RbtGuiData.tbSpacing *2
            contentWidth: _label.width
            contentHeight: _toolbar.height
            contentX: contentWidth - width
            clip: true

            Label {
                id: _label
                text: _toolbar.appWindow.getActivePageTitle()
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
        target: RbtGuiData
        function onProjectOpened(path) {
            _loader.sourceComponent = _repositoryButtons
        }
    }

}  // ToolBar
