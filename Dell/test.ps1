# variables
$c = $PSScriptRoot
$catalogXMLFile = "${c}/DriverPackCatalog.xml"


# read all xml data into variable x
[xml]$x = Get-Content -Path $catalogXMLFile

# assign intended data from x to packs
$packs = $x.DriverPackManifest.DriverPackage

# iterate of each pack
foreach ($pack in $packs)
{
    $pack
}

# read xml catalog
[xml]$catalogXMLDoc = Get-Content $catalogXMLFile

# print data to screen
$catalogXMLDoc.DriverPackManifest.DriverPackage | 
    Select-Object `
        @{Expression={$_.SupportedSystems.Brand.key};Label="LOBKey";},  `
        @{Expression={$_.SupportedSystems.Brand.prefix};Label="LOBPrefix";}, `
        @{Expression={$_.SupportedSystems.Brand.Model.systemID};Label="SystemID";}, `
        @{Expression={$_.SupportedSystems.Brand.Model.name};Label="SystemName";} -Unique