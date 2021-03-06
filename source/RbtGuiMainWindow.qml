import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import Qt.labs.settings

import "RbtGuiFunctions.js" as RbtGui

ApplicationWindow {
    id: appWindow
    width: 800
    height: 600
    visible: true
    visibility: Window.AutomaticVisibility
    title: "Review Board Tools GUI"

    SystemPalette {
        id: sysPalette
        colorGroup: SystemPalette.Active

        property bool isDarkTheme: sysPalette.light.hsvValue < sysPalette.dark.hsvValue
    }

    property real  tbIconWidth: 32
    property real  tbIconHeight: 32
    property real  tbIconMargins: 4
    property real  tbSpacing: 4

    property var   projectList: []

    Settings {
        id: appSettings
        property alias  app_x: appWindow.x
        property alias  app_y: appWindow.y
        property alias  app_width: appWindow.width
        property alias  app_height: appWindow.height
        property int    app_visibility: 1

        property string app_language: ""

        property int    app_project_count: 0
        property string app_project_list: ""

        property string app_opendlg_folder: ""

        function addProject(path) {
            if (appWindow.projectList.indexOf(path) >= 0) { return }
            appWindow.projectList.push(path)
            appSettings.app_project_list = appWindow.projectList.join("\n")
            appSettings.app_project_count = appWindow.projectList.length
            appSettings.sync()
            console.info(`projectAdded: '${path}'`)
            projectAdded(path)
        }

        signal projectAdded(string path)
    }

    header: RbtGuiToolBar {
        id: toolbar
    }

    RbtGuiDrawer {
        id: drawer
        width: appWindow.width * 0.4
        height: appWindow.height
        onClosed: resetFocus()
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: pageMain

        focus: true
        Keys.onBackPressed: {
            if (stackView.depth > 1) {
                activatePreviousPage()
            } else {
                handleEscapePressed()
            }
        }
        Keys.onEscapePressed: {
            handleEscapePressed()
        }
        function handleEscapePressed() {
            messageDialog.showMessage(
                    qsTr("You are about to quit the application.\n\nQuit?"),
                    qsTr("Warning"),
                    /*cllerID*/1)
        }
        Connections {
            target: messageDialog
            function onAccepted(callerID) {
                if (callerID !== 1) { return }
                Qt.exit(0)
            }
        }
    }

    Component {
        id: pageMain
        Page {
            title: qsTr("Reviews")
            anchors.fill: parent
            Label {
                anchors.centerIn: parent
                text: "Test test test"
            }
        }
    }

    FileDialog {
        id: fileDialog
        nameFilters: [
            "Review Board RC file (.reviewboardrc)"
        ]
        onAccepted: {
            var projectFolder = RbtGui.urlToLocalPath(fileDialog.currentFolder)
            appSettings.app_opendlg_folder = projectFolder
            appSettings.addProject(projectFolder)
        }
        onRejected: {
            appSettings.app_opendlg_folder = RbtGui.urlToLocalPath(fileDialog.currentFolder)
        }
    }

    RbtGuiMessageDialog {
        id: messageDialog
    }

    onVisibilityChanged: {
        if (appWindow.visible) {
            appSettings.app_visibility = appWindow.visibility
        }
    }

    Component.onCompleted: {
        appWindow.visibility = appSettings.app_visibility

        if (appSettings.app_language === "") {
            appSettings.app_language = Qt.locale().name
        }

        const list_ = appSettings.app_project_list ?? ""
        appWindow.projectList = list_.split("\n").filter(s => s.length)

        if (appSettings.app_opendlg_folder.length > 0) {
            fileDialog.currentFolder = RbtGui.localPathToUrl(
                    appSettings.app_opendlg_folder,
                    RbtGui.PathIsDir)
        }
    }

    function resetFocus() {
        stackView.focus = true  // to catch 'backPressed' event
    }

    function activatePage(name) {
        if (stackView.currentItem && stackView.currentItem.objectName === name) { return }
        drawer.close()
        stackView.push(name)
        stackView.currentItem.objectName = name
        stackView.currentItem.width = Qt.binding(() => stackView.width)
        stackView.currentItem.height = Qt.binding(() => stackView.height)
        resetFocus()
    }

    function activatePreviousPage() {
        stackView.pop()
        resetFocus()
    }

    //function openProjectSettings(projectFolder) {
    //
    //}

}  // ApplicationWindow
