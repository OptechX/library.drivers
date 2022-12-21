# variables
$c = $PSScriptRoot
$catalogXMLFile = "${c}/DriverPackCatalog.xml"



[xml]$x = Get-Content -Path $catalogXMLFile

$packs = $x.DriverPackManifest.DriverPackage

foreach ($pack in $packs)
{
    #$pack
}


[xml]$catalogXMLDoc = Get-Content $catalogXMLFile

$catalogXMLDoc.DriverPackManifest.DriverPackage | Select-Object @{Expression={$_.SupportedSystems.Brand.key};Label="LOBKey";},  @{Expression={$_.SupportedSystems.Brand.prefix};Label="LOBPrefix";}, @{Expression={$_.SupportedSystems.Brand.Model.systemID};Label="SystemID";}, @{Expression={$_.SupportedSystems.Brand.Model.name};Label="SystemName";} –unique