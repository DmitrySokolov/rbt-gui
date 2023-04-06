function urlToLocalPath(fileUrl)
{
    const u = fileUrl.toString()
    return decodeURIComponent(
        u.startsWith("file:///")
        ? u.substring(u.length >= 9 && u.charAt(9) === ":" ? 8 : 7)
        : (u.length >= 2 && u.charAt(1) === ":" ? u.replace(/\\/g, "/") : u)
    )
}


const PathIsDir = true
const PathIsFile = false

function localPathToUrl(path, pathIsDir)
{
    const p = path.toString()
    return p.startsWith("file:///")
        ? path
        : ("file://" + (p.charAt(0) === '/' ? "" : "/") + p + (pathIsDir ? "/" : ""))
}


function basename(path)
{
    let index = path.lastIndexOf("/")
    if (index < 0) { index = path.lastIndexOf("\\") }
    if (index < 0) { index = 0 } else { index += 1 }
    return path.substr(index)
}


function dirname(path)
{
    return path.substring(0, path.lastIndexOf("/"))
}
