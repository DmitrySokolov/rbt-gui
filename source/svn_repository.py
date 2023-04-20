#!/usr/bin/env python3
# coding: utf-8

from lib import *

from subprocess import PIPE, Popen
from threading  import Thread

from PySide6.QtCore import Qt, Slot, QAbstractListModel, QModelIndex
from PySide6.QtQml import QmlElement, QmlSingleton


QML_IMPORT_NAME = "RbtGui"
QML_IMPORT_MAJOR_VERSION = 1


@dc.dataclass
class SvnItem:
    file_name: str
    file_checked: bool
    modified_flag: str
    modified_prop_flag: str
    locked_flag: bool
    history_addition_flag: bool
    switched_flag: bool
    locked_type_flag: str
    tree_conflict_flag: bool


@QmlElement
@QmlSingleton
class SvnRepository(QAbstractListModel):
    FILE_CHECKED = Qt.UserRole + 1
    FILE_NAME = Qt.UserRole + 2

    def __init__(self, parent=None):
        super().__init__(parent=parent)
        self.root_dir = None
        self.raw_data = []
        self.roles = {
            SvnRepository.FILE_CHECKED: b"file_checked",
            SvnRepository.FILE_NAME: b"file_name",
        }

    @Slot(str)
    def getModifiedFiles(self, path: str) -> None:
        print(f"checking modified files in '{path}'")
        self.root_dir = path
        self.beginRemoveRows(QModelIndex(), 0, self.rowCount()-1)
        self.raw_data.clear()
        self.endRemoveRows()
        line_regex = re.compile(r'^(.)(.)(.)(.)(.)(.)(.) ([^\r\n]+)')

        def _read(stream):
            for line in iter(stream.readline, ""):
                #print(f"--{line}")
                if m := line_regex.match(line):
                    self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
                    self.raw_data.append(SvnItem(
                        file_name=m[8],
                        file_checked=False,
                        modified_flag=m[1],
                        modified_prop_flag=m[2],
                        locked_flag=(m[3] == "L"),
                        history_addition_flag=(m[4] == "+"),
                        switched_flag=(m[5] == "S"),
                        locked_type_flag=m[6],
                        tree_conflict_flag=(m[7] == "C")
                    ))
                    self.endInsertRows()
            stream.close()

        p = Popen(['svn', 'diff', '--summarize'], stdout=PIPE, bufsize=1, text=True, cwd=self.root_dir)
        t = Thread(target=_read, args=[p.stdout])
        t.daemon = True  # thread dies with the program
        t.start()

    def roleNames(self):
        return self.roles

    def rowCount(self, parentIndex=QModelIndex()) -> int:
        return len(self.raw_data)

    def data(self, index, role):
        ri = index.row()
        #print(f"--data, row={ri}, role={role-Qt.UserRole}")
        if 0 <= ri < self.rowCount() and index.isValid():
            item = self.raw_data[ri]
            match role:
                case SvnRepository.FILE_CHECKED:
                    return item.file_checked
                case SvnRepository.FILE_NAME:
                    return item.file_name
        return None
