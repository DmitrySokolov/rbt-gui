try {
    Push-Location $PSScriptRoot

    if (Test-Path .\__venv__) {
        . .\__venv__\Scripts\Activate.ps1
    } else {
        py -3 -m venv __venv__
        . .\__venv__\Scripts\Activate.ps1
        pip install -r .\requirements.txt
    }
}
finally {
    Pop-Location
}
