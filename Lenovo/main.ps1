# variables
$c = $PSScriptRoot
$lenovo_catalog_xml = "https://download.lenovo.com/cdrt/td/catalogv2.xml"
$catalogXMLFile = "${c}/$(Split-Path -Path $lenovo_catalog_xml -Leaf)"


# get the Lenovo xml file
Invoke-WebRequest -Uri $lenovo_catalog_xml -UseBasicParsing -DisableKeepAlive -OutFile $catalogXMLFile


# show me all the files
tree

# read the exported XML file to variable
#[xml]$catalogXMLDoc = Get-Content $catalogXMLFile

#$catalogXMLDoc



Write-Output "Path is: $catalogXMLFile"
Test-Path -Path $catalogXMLFile
"Is it true above?"

