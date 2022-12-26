#$firefox_msi = 'https://download-installer.cdn.mozilla.net/pub/firefox/releases/108.0.1/win64/en-US/Firefox%20Setup%20108.0.1.msi'
$google_msi = 'https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi'

Invoke-WebRequest -Uri $google_msi -OutFile ~/Downloads/install.msi -UseBasicParsing -DisableKeepAlive

Set-Location ~/Downloads/

Start-Process -FilePath msiexec -ArgumentList "/i","./install.msi","/qn" -Wait

Write-Output "MSI installed"