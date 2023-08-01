pragma ComponentBehavior: Bound

import RbtGui

MainWindow {
    id: _mainWindow

    toolbar: _toolbar
    drawer: _drawer

    header: RbtGuiToolBar {
        id: _toolbar
        appWindow: _mainWindow
    }

    RbtGuiDrawer {
        id: _drawer
        appWindow: _mainWindow
        width: _mainWindow.width * 0.4
        height: _mainWindow.height
        onClosed: _mainWindow.resetFocus()
    }
}
