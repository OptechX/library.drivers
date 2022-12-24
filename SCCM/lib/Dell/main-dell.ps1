# variables
$c = $PSScriptRoot
$pc_catalog = "${c}/DellSDPCatalogPC.xml"

# read data to memory
[xml]$XmlDocument = Get-Content -Path $pc_catalog
$XmlDocument.SystemsManagementCatalog.SoftwareDistributionPackage

# load each pc object json file
[System.String[]]$json_list = Get-ChildItem -Path $PSScriptRoot/V3 -Filter *.json | `
    Where-Object -FilterScript {$_.Name -notlike "update_categories.json"} | `
    Select-Object -ExpandProperty FullName

# create blank array
$pclist = @()

# iterate through objects and add to the array
foreach ($json in $json_list)
{
    $pclist += Get-Content -Path $json | ConvertFrom-Json | Select-Object -ExpandProperty DisplayName
}

# resort list
$sorted_pclist = $pclist | Sort-Object
[System.String[]]$ignore_list = Get-Content -Path "${c}/dell_ignore_list.txt"
$dell_pc_list = $sorted_pclist | Where-Object -FilterScript {$_ -notin $ignore_list}

# show list
$dell_pc_list
