# variables
$c = $PSScriptRoot
$microsoft_catalog_url = "https://go.microsoft.com/fwlink/?linkid=874591"
$download_page = ([System.Net.WebRequest]::CreateDefault($microsoft_catalog_url)).GetResponse()
$microsoft_cabfile = Split-Path -Path $download_page.ResponseUri.OriginalString -Leaf
$catalog_cab_file = "${c}/data/${microsoft_cabfile}"

# get the Microsoft cab file
Invoke-WebRequest -Uri $download_page.ResponseUri.OriginalString -OutFile $microsoft_cabfile -UseBasicParsing -DisableKeepAlive


# $catalogXMLFile = "${c}/data/$(Split-Path -Path $lenovo_catalog_xml -Leaf)"


# # get the Lenovo xml file
# Invoke-WebRequest -Uri $lenovo_catalog_xml -UseBasicParsing -DisableKeepAlive -OutFile $catalogXMLFile


# # show me all the files
# tree

# # read the exported XML file to variable
# #[xml]$catalogXMLDoc = Get-Content $catalogXMLFile

# #$catalogXMLDoc



# Write-Output "Path is: $catalogXMLFile"
# Test-Path -Path $catalogXMLFile
# "Is it true above?"



# $download_page = ([System.Net.WebRequest]::CreateDefault()).GetResponse()
# Split-Path -Path $download_page.ResponseUri.OriginalString -Leaf


# Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=874591" -UseBasicParsing -DisableKeepAlive