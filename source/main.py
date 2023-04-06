import sys
from pathlib import Path

from PySide6.QtCore import QSettings
from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuickControls2 import QQuickStyle

APP_DIR = Path(__file__).parent

if __name__ == '__main__':
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
