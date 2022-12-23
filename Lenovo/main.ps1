# variables
$c = $PSScriptRoot
$lenovo_catalog_xml = "https://download.lenovo.com/cdrt/td/catalogv2.xml"
$xml_file = "${c}/$(Split-Path -Path $lenovo_catalog_xml -Leaf)"
$catalogXMLFile = "${c}${xml_file}"


# get the Lenovo xml file
Invoke-WebRequest -Uri $lenovo_catalog_xml -UseBasicParsing -DisableKeepAlive -OutFile $xml_file


# show me all the files
tree

# read the exported XML file to variable
#[xml]$catalogXMLDoc = Get-Content $catalogXMLFile

#$catalogXMLDoc



Write-Output "Path is: $catalogXMLFile"
Test-Path -Path ./Lenovo/catalogv2.xml
"Is it true above?"
Test-Path -Path $catalogXMLFile
"Is it true above?"
