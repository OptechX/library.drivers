#$firefox_msi = 'https://download-installer.cdn.mozilla.net/pub/firefox/releases/108.0.1/win64/en-US/Firefox%20Setup%20108.0.1.msi'
$google_msi = 'https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B738FCCCD-A83B-AE7C-D8DB-4EC2BF563FDC%7D%26lang%3Den%26browser%3D5%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dtrue%26ap%3Dx64-stable-statsdef_0%26brand%3DGCEW/dl/chrome/install/googlechromestandaloneenterprise64.msi'

Invoke-WebRequest -Uri $google_msi -OutFile ~/Downloads/install.msi -UseBasicParsing -DisableKeepAlive

Set-Location ~/Downloads/

Start-Process -FilePath msiexec -ArgumentList "/i","./install.msi","/qn" -Wait

Write-Output "MSI installed"