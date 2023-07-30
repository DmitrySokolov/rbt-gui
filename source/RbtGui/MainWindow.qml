pragma ComponentBehavior: Bound

import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import RbtGui

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

    property var    projectList: []
    property string projectFolder: ""
    property var    repository

    signal projectOpened(string projectFolder)

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
            const i = appWindow.projectList.indexOf(path)
            if (i >= 0) { appWindow.projectList.splice(i, 1) }
            appWindow.projectList.unshift(path)
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
        onClosed: appWindow.resetFocus()
    }

    StackView {
        id: stackView
        anchors.fill: parent

        Component.onCompleted: appWindow.activatePage("RbtGuiStartPage.qml")

        focus: true
        Keys.onBackPressed: {
            if (stackView.depth > 1) {
                appWindow.activatePreviousPage()
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
                    /*callerID*/1)
        }
        Connections {
            target: messageDialog
            function onAccepted(callerID) {
                if (callerID !== 1) { return }
                Qt.exit(0)
            }
        }
    }

    FileDialog {
        id: fileDialog
        nameFilters: [
            "Review Board RC file (.reviewboardrc)"
        ]
        onAccepted: {
            const projectFolder = RbtGuiFunctions.urlToLocalPath(fileDialog.currentFolder)
            appSettings.app_opendlg_folder = projectFolder
            appSettings.addProject(projectFolder)
            appWindow.openProject(projectFolder)
        }
        onRejected: {
            appSettings.app_opendlg_folder = RbtGuiFunctions.urlToLocalPath(fileDialog.currentFolder)
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
            fileDialog.currentFolder = RbtGuiFunctions.localPathToUrl(
                    appSettings.app_opendlg_folder,
                    RbtGuiFunctions.PathIsDir)
        }
    }

    function resetFocus() {
        stackView.focus = true  // to catch 'backPressed' event
    }

    function activatePage(name, clearStack) {
        if (clearStack) { stackView.clear() }
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

    function openProject(projectFolder) {
        console.info(`opening: '${projectFolder}'`)
        appWindow.projectFolder = projectFolder
        const t = Repository.getVcsType(projectFolder)
        if (t === "svn") {
            appWindow.repository = SvnRepository
        }
        appWindow.activatePage("RbtGuiRepositoryPage.qml", /*clearStack=*/true)
        appWindow.projectOpened(projectFolder)
    }

}  // ApplicationWindow
