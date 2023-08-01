pragma ComponentBehavior: Bound

import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import RbtGui

ApplicationWindow {
    id: _appWindow
    width: 800
    height: 600
    visible: true
    visibility: Window.AutomaticVisibility
    title: "Review Board Tools GUI"

    required property ToolBar toolbar
    required property Drawer drawer

    SystemPalette {
        id: sysPalette
        colorGroup: SystemPalette.Active

        property bool isDarkTheme: sysPalette.light.hsvValue < sysPalette.dark.hsvValue
    }

    Settings {
        id: _appSettings
        property alias  app_x: _appWindow.x
        property alias  app_y: _appWindow.y
        property alias  app_width: _appWindow.width
        property alias  app_height: _appWindow.height
        property int    app_visibility: 1

        property string app_language: ""

        property int    app_project_count: 0
        property string app_project_list: ""

        property string app_opendlg_folder: ""

        function addProject(path) {
            const i = RbtGuiData.projectList.indexOf(path)
            if (i >= 0) { RbtGuiData.projectList.splice(i, 1) }
            RbtGuiData.projectList.unshift(path)
            _appSettings.app_project_list = RbtGuiData.projectList.join("\n")
            _appSettings.app_project_count = RbtGuiData.projectList.length
            _appSettings.sync()
            console.info(`AppSettings.projectAdded: '${path}'`)
            _appSettings.projectAdded(path)
        }

        signal projectAdded(string path)
        signal loaded()
    }
    property alias appSettings: _appSettings

    StackView {
        id: _stackView
        anchors.fill: parent

        Component.onCompleted: _appWindow.activatePage("RbtGuiStartPage.qml")

        focus: true
        Keys.onBackPressed: {
            if (_stackView.depth > 1) {
                _appWindow.activatePreviousPage()
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
    property alias stackView: _stackView

    FileDialog {
        id: _fileDialog
        nameFilters: [
            "Review Board RC file (.reviewboardrc)"
        ]
        onAccepted: {
            const projectFolder = RbtGuiFunctions.urlToLocalPath(_fileDialog.currentFolder)
            _appSettings.app_opendlg_folder = projectFolder
            _appSettings.addProject(projectFolder)
            RbtGuiData.openProject(projectFolder)
        }
        onRejected: {
            _appSettings.app_opendlg_folder = RbtGuiFunctions.urlToLocalPath(_fileDialog.currentFolder)
        }
    }
    property alias fileDialog: _fileDialog

    RbtGuiMessageDialog {
        id: messageDialog
    }

    onVisibilityChanged: {
        if (_appWindow.visible) {
            _appSettings.app_visibility = _appWindow.visibility
        }
    }

    Component.onCompleted: {
        _appWindow.visibility = _appSettings.app_visibility

        if (_appSettings.app_language === "") {
            _appSettings.app_language = Qt.locale().name
        }

        const list_ = _appSettings.app_project_list ?? ""
        RbtGuiData.projectList = list_.split("\n").filter(s => s.length)

        if (_appSettings.app_opendlg_folder.length > 0) {
            _fileDialog.currentFolder = RbtGuiFunctions.localPathToUrl(
                    _appSettings.app_opendlg_folder,
                    RbtGuiFunctions.PathIsDir)
        }
        _appSettings.loaded()
    }

    Connections {
        target: RbtGuiData
        function onProjectOpened(path) {
            _appWindow.activatePage("RbtGuiRepositoryPage.qml", /*clearStack=*/true)
        }
    }

    function resetFocus() {
        _stackView.focus = true  // to catch 'backPressed' event
    }

    function activatePage(name, clearStack) {
        if (clearStack) { _stackView.clear() }
        if (_stackView.currentItem && _stackView.currentItem.objectName === name) { return }
        closeDrawer()
        _stackView.push(name, {appWindow: _appWindow})
        _stackView.currentItem.objectName = name
        _stackView.currentItem.width = Qt.binding(() => _stackView.width)
        _stackView.currentItem.height = Qt.binding(() => _stackView.height)
        resetFocus()
    }

    function activatePreviousPage() {
        _stackView.pop()
        resetFocus()
    }

    function getActivePageTitle() {
        return _stackView.currentItem ? _stackView.currentItem.title : ""
    }

    function closeDrawer() {
        drawer.close()
    }

    function openDrawer() {
        drawer.open()
    }

}  // ApplicationWindow
