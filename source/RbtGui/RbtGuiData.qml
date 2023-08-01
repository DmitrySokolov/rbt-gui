pragma Singleton

import QtQuick

QtObject {
    id: _data

    readonly property real  tbIconWidth: 32
    readonly property real  tbIconHeight: 32
    readonly property real  tbIconMargins: 4
    readonly property real  tbButtonWidth: tbIconHeight + tbIconMargins * 2
    readonly property real  tbButtonHeight: tbButtonWidth
    readonly property real  tbSpacing: 4

    property var    projectList: []
    property string projectFolder: ""
    property var    repository

    signal projectOpened(string projectFolder)

    function openProject(projectFolder) {
        console.info(`opening: '${projectFolder}'`)
        _data.projectFolder = projectFolder
        const t = Repository.getVcsType(projectFolder)
        if (t === "svn") {
            _data.repository = SvnRepository
        }
        _data.projectOpened(projectFolder)
    }
}
