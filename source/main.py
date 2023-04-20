#!/usr/bin/env python3
# coding: utf-8

from pathlib import Path

from lib import *
from svn_repository import *

from PySide6.QtCore import QSettings, QObject, Slot
from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine, QmlElement, QmlSingleton
from PySide6.QtQuickControls2 import QQuickStyle

APP_DIR = Path(__file__).parent
QML_IMPORT_NAME = "RbtGui"
QML_IMPORT_MAJOR_VERSION = 1


def main():
    QSettings.setDefaultFormat(QSettings.IniFormat)
    QGuiApplication.setOrganizationName("rbt-gui")
    QGuiApplication.setApplicationName("rbt-gui")
    app = QGuiApplication(sys.argv)
    icon = QIcon(str(APP_DIR / "RbtGui/Icons/app_icon.svg"))
    app.setWindowIcon(icon)

    QQuickStyle.setStyle("Universal")
    engine = QQmlApplicationEngine()
    engine.addImportPath(APP_DIR)
    engine.loadFromModule("RbtGui", "Main")

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())


@QmlElement
@QmlSingleton
class Repository(QObject):
    def __init__(self, parent=None):
        super().__init__(parent=parent)

    @Slot(str, result=str)
    def getVcsType(self, path: str) -> str:
        if fs.isfile(fs.join(path, ".svn/format")):
            return "svn"
        elif fs.isfile(fs.join(path, ".git/config")):
            return "git"
        elif fs.isfile(fs.join(path, ".hg/requires")):
            return "hg"
        return None


if __name__ == '__main__':
    main()
