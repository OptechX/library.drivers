# variables
$downloads_dir = "${HOME}/Downloads"

# setup selenium
$url = 'https://www.nuget.org/api/v2/package/Selenium.WebDriver/3.141.0'
$d = ([System.Net.WebRequest]::CreateDefault($url)).GetResponse()
$g = $d.ResponseUri.OriginalString
$c = Split-Path -Path $d.ResponseUri.OriginalString -Leaf

Invoke-WebRequest -Uri $g -OutFile "${downloads_dir}\${c}" -UseBasicParsing -DisableKeepAlive

mkdir -p C:\Selenium
7z x $HOME/Downloads/$c -oC:\Selenium