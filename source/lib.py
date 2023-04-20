#!/usr/bin/env python3
# coding: utf-8

import sys
import os
import os.path as fs
import re
import subprocess as sp
import dataclasses as dc

from subprocess import SubprocessError, CalledProcessError
from typing import NewType, TypeVar, Type, Any, Union, Optional, Generator, Iterable, Iterator, TextIO


ExitCode = NewType("ExitCode", int)
Encoding = TypeVar("Encoding")

IS_WINDOWS = re.search(r'(?i)win32', sys.platform) is not None
IS_CYGWIN = re.search(r'(?i)cygwin', sys.platform) is not None
IS_MSYS = re.search(r'(?i)msys', sys.platform) is not None
IS_MACOS = re.search(r'(?i)darwin', sys.platform) is not None


def static_vars(**kwargs):
    def _init_vars(func):
        for k in kwargs:
            setattr(func, k, kwargs[k])
        return func
    return _init_vars


def unique(*args: Union[str, Iterable[str]]) -> list[str]:
    def _args():
        for a in args:
            if isinstance(a, (tuple, list)):
                for i in a:
                    yield i
            else:
                yield a

    result = set()
    return [a for a in _args() if not (a in result or result.add(a))]


__all__ = [
    "sys", "os", "fs", "re", "sp", "SubprocessError", "CalledProcessError", "dc",
    "NewType", "TypeVar", "Type", "Any", "Union", "Optional", "Generator", "Iterable", "Iterator", "TextIO",
    "ExitCode", "Encoding", "IS_WINDOWS", "IS_CYGWIN", "IS_MSYS", "IS_MACOS",
    "static_vars", "unique",
]


if __name__ == "__main__":
    raise RuntimeError(
            "This file is not intended to be run as script.\n"
            "Use 'import ...' statements.")
