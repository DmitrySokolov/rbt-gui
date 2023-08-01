if (-not (where.exe Activate.ps1 2>&1 | Out-Null)) { ./init.ps1 }
python .\source\main.py
