$firefox_msi = 'https://download-installer.cdn.mozilla.net/pub/firefox/releases/108.0.1/win64/en-US/Firefox%20Setup%20108.0.1.msi'

Invoke-WebRequest -Uri $firefox_msi -OutFile ~/Downloads/firefox.msi -UseBasicParsing -DisableKeepAlive

Set-Location ~/Downloads/

Start-Process -FilePath msiexec -ArgumentList "/i","./firefox.msi","/qn" -Wait

Write-Output "Firefox installed"