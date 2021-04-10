"""
This module contains classes from the main app used by Pyto.
This module is only for internal or plugin use.
"""

try:
    from rubicon.objc import *
except ValueError:

    def ObjCClass(class_name):
        return None


NSBundle = ObjCClass("NSBundle")

ignored_threads_on_crash = []

def __isMainApp__():
    if NSBundle is None:
        return False
    return (
        NSBundle.mainBundle.bundleURL.lastPathComponent == "Pyto.app"
        or NSBundle.mainBundle.bundleURL.lastPathComponent == "Pyto Mac.app"
    )


def __is_appex__():
    if NSBundle is None:
        return False
    return NSBundle.mainBundle.bundleURL.pathExtension == "appex"


def __Class__(name):
    try:
        if __isMainApp__():
            return ObjCClass("Pyto." + name)
        elif __is_appex__():
            try:
                return ObjCClass("TodayExtension." + name)
            except NameError:
                return ObjCClass("WidgetExtension." + name)
        else:
            return ObjCClass("PytoCore." + name)
    except:
        return None


PyMainThread = __Class__("PyMainThread")
PyThread = __Class__("PyThread")

PyInputHelper = __Class__("PyInputHelper")
PyOutputHelper = __Class__("PyOutputHelper")
PySharingHelper = __Class__("PySharingHelper")
PyLocationHelper = __Class__("PyLocationHelper")
FilePicker = __Class__("PyFilePicker")
PyAlert = __Class__("PyAlert")
Python = __Class__("Python")
ConsoleViewController = __Class__("ConsoleViewController")
PyMusicHelper = __Class__("PyMusicHelper")
PyPhotosHelper = __Class__("PyPhotosHelper")
PyMultipeerHelper = __Class__("PyMultipeerHelper")
PyMotionHelper = __Class__("PyMotionHelper")
PyTurtle = __Class__("PyTurtle")
PySpeech = __Class__("PySpeech")

if __isMainApp__():
    QuickLookHelper = __Class__("QuickLookHelper")
    PySelector = __Class__("PySelector")
    SelectorTarget = __Class__("_Selector")
    REPLViewController = __Class__("REPLViewController")
    PipViewController = __Class__("PipViewController")
    ReviewHelper = __Class__("ReviewHelper")
    EditorViewController = __Class__("EditorViewController")
    EditorSplitViewController = __Class__("EditorSplitViewController")
    DocumentBrowserViewController = __Class__("DocumentBrowserViewController")
    ModulesTableViewController = __Class__("ModulesTableViewController")
    PyCallbackHelper = __Class__("PyCallbackHelper")
    PytoUIPreviewViewController = __Class__("PytoUIPreviewViewController")
else:
    QuickLookHelper = None
    PySelector = None
    SelectorTarget = None
    REPLViewController = None
    PipViewController = None
    ReviewHelper = None
    EditorViewController = None
    EditorSplitViewController = None
    DocumentBrowserViewController = None
    ModulesTableViewController = None
    PyCallbackHelper = None
    PytoUIPreviewViewController = None

all = [
    "PyMainThread",
    "PyThread",
    "PyInputHelper",
    "PyOutputHelper",
    "PySharingHelper",
    "PySelector",
    "SelectorTarget",
    "FilePicker",
    "PyAlert",
    "Python",
    "ConsoleViewController",
    "ReviewHelper",
    "EditorViewController",
    "EditorSplitViewController",
    "REPLViewController",
    "QuickLookHelper",
    "PyCallbackHelper",
    "PyMusicHelper",
    "PyMultipeerHelper",
    "PyMotionHelper",
    "PyTurtle",
    "PySpeech",
]
