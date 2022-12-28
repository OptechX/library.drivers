# variables
$downloads_dir = "${HOME}\Downloads"

# setup selenium
$url = 'https://www.nuget.org/api/v2/package/Selenium.WebDriver/3.141.0'
$d = ([System.Net.WebRequest]::CreateDefault($url)).GetResponse()
$g = $d.ResponseUri.OriginalString
$c = Split-Path -Path $d.ResponseUri.OriginalString -Leaf

Invoke-WebRequest -Uri $g -OutFile "${downloads_dir}\${c}" -UseBasicParsing -DisableKeepAlive

New-Item -ItemType Directory -Path C:\ -Name Selenium -Force -Confirm:$false
7z x "${downloads_dir}\${c}" -oC:\Selenium

# # download firefox driver
# $url = 'https://github.com/mozilla/geckodriver/releases/download/v0.32.0/geckodriver-v0.32.0-win32.zip'
# Invoke-WebRequest -Uri $url -OutFile "${downloads_dir}\geckodriver-v0.32.0-win32.zip"
# 7z x "${downloads_dir}\geckodriver-v0.32.0-win32.zip" -oC:\Selenium
# Move-Item -Path C:\Selenium\geckodriver.exe -Destination C:\Selenium\lib\net45\geckodriver.exe

# # initialise Selenium driver
# $PathToFolder = 'C:\Selenium\lib\net45'
# [System.Reflection.Assembly]::LoadFrom("{0}\WebDriver.dll" -f $PathToFolder)
# if ($env:Path -notcontains ";$PathToFolder" ) {
#     $env:Path += ";$PathToFolder"
# }

# # function into memory
# Function Start-FirefoxBrowser{
#     Param(
#         $SiteURL
#     )
#     # Create Firefox options object
#     $firefoxoptions = new-object OpenQA.Selenium.Firefox.FirefoxOptions
#     # $firefoxoptions.Profile = "$workingPath\FireFoxProfile"
#     $firefoxoptions.BrowserExecutableLocation = "C:\Program Files\Mozilla Firefox\firefox.exe"
 
#     # Start Firefox and navigate to URL
#     $firefoxdriver = New-Object OpenQA.Selenium.Firefox.FirefoxDriver($firefoxoptions)
#     $FirefoxDriver.Navigate().GoToURL($siteURL)
#     Return $FirefoxDriver
# }


# $objFirefoxDriver = Start-FirefoxBrowser -SiteURL 'https://www.microsoft.com/download/details.aspx?id=101315'


# $objFirefoxDriver.FindElementByXPath('/html/body/main/div/div/form/div/div[2]/div/div/div/div[2]/div/div/div/div/div[2]/div[3]/div/div/div/a').Click()
# $objFirefoxDriver.FindElementByXPath('/html/body/main/div/div/form/div/div[2]/div/div/div/div[2]/div/div/div/div/div[2]/div[3]/div/div/div/div/div/div[2]/div/div[2]/div/div[2]/div/div[1]/div/div/div/div/div[2]/div[1]/div[1]/div/div[1]/input').Click()
# $objFirefoxDriver.FindElementByXPath('//*[@id="5b70c241-07ba-40b9-c0c1-6aae74ab472b"]').Click()

# 1..30 | ForEach-Object {
#     $i = $_
#     Write-Output "Check number: ${i}"
#     Get-ChildItem -Path $downloads_dir
#     Start-Sleep -Seconds 3
# }