#!/usr/bin/env python3
# coding: utf-8

from lib import *

from PySide6.QtCore import QObject, Slot
from PySide6.QtQml import QmlElement, QmlSingleton


QML_IMPORT_NAME = "RbtGui"
QML_IMPORT_MAJOR_VERSION = 1


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
