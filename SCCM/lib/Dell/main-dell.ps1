# [xml]$XmlDocument = Get-Content -Path $PSScriptRoot/DellSDPCatalogPC.xml
# $XmlDocument.SystemsManagementCatalog.SoftwareDistributionPackage


[System.String[]]$json_list = Get-ChildItem -Path $PSScriptRoot/V3 -Filter *.json | 
    Where-Object -FilterScript {$_.Name -notlike "update_categories.json"} | 
    Select-Object -ExpandProperty FullName

$pclist = @()

foreach ($json in $json_list)
{
    $pclist += Get-Content -Path $json | ConvertFrom-Json | Select-Object -ExpandProperty DisplayName
}

$sorted_pclist = $pclist | Sort-Object
[System.String[]]$ignore_list = Get-Content -Path /Users/danijel-rpc/Projects/repasscloud/optechx.drivers/SCCM/dell_ignore_list.txt
$sorted_pclist | Where-Object -FilterScript {$_ -notin $ignore_list}
