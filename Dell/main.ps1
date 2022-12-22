# variables
$c = $PSScriptRoot
$dell_cab_file = "https://downloads.dell.com/catalog/DriverPackCatalog.cab"
$cab_file = "${c}/$(Split-Path -Path $dell_cab_file -Leaf)"
$catalogXMLFile = "${c}/DriverPackCatalog.xml"

# get the dell driver CAB file
Invoke-WebRequest -Uri $dell_cab_file -UseBasicParsing -DisableKeepAlive -OutFile $cab_file

# expand the cab file locally
cabextract $cab_file --directory Dell

# show me all the files
tree

# read the exported XML file to variable
[xml]$catalogXMLDoc = Get-Content $catalogXMLFile

$catalogXMLDoc.DriverPackManifest.DriverPackage | Select-Object @{
    Expression={$_.SupportedSystems.Brand.key};
        Label="LOBKey";},
    @{Expression={$_.SupportedSystems.Brand.prefix};
        Label="LOBPrefix";},
    @{Expression={$_.SupportedSystems.Brand.Model.systemID};
        Label="SystemID";},
    @{Expression={$_.SupportedSystems.Brand.Model.name};
        Label="SystemName";} –unique