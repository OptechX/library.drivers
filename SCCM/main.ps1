# variables
$c = $PSScriptRoot
$microsoft_catalogs_url = "https://go.microsoft.com/fwlink/?linkid=874591"
$download_page = ([System.Net.WebRequest]::CreateDefault($microsoft_catalogs_url)).GetResponse()
$microsoft_cabfile = Split-Path -Path $download_page.ResponseUri.OriginalString -Leaf
$cab_file = "${c}/data/${microsoft_cabfile}"
$xml_file = "${c}/data/$($microsoft_cabfile.Replace('.cab','.xml'))"

# get the Microsoft cab file
Invoke-WebRequest -Uri $download_page.ResponseUri.OriginalString -OutFile $cab_file -UseBasicParsing -DisableKeepAlive


# extract cab file
# expand the cab file locally
cabextract $cab_file --directory "SCCM/data"


[xml]$catalogXMLPayload = Get-Content -Path $xml_file

foreach ($payload in $catalogXMLPayload.Catalogs.Catalog)
{
    $publisher = $payload.LocalizedProperties.Publisher
    $cabfile = $payload.DownloadUrl

    New-Item -ItemType Directory -Name $publisher -Force -Confirm:$false
    Invoke-WebRequest -Uri $cabfile -OutFile "./$publisher/" -UseBasicParsing -DisableKeepAlive
}

# $catalogXMLFile = "${c}/data/$(Split-Path -Path $lenovo_catalog_xml -Leaf)"


# # get the Lenovo xml file
# Invoke-WebRequest -Uri $lenovo_catalog_xml -UseBasicParsing -DisableKeepAlive -OutFile $catalogXMLFile


# # show me all the files
tree

# # read the exported XML file to variable
# #[xml]$catalogXMLDoc = Get-Content $catalogXMLFile

# #$catalogXMLDoc



# Write-Output "Path is: $catalogXMLFile"
# Test-Path -Path $catalogXMLFile
# "Is it true above?"



# $download_page = ([System.Net.WebRequest]::CreateDefault()).GetResponse()
# Split-Path -Path $download_page.ResponseUri.OriginalString -Leaf


# Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=874591" -UseBasicParsing -DisableKeepAlive