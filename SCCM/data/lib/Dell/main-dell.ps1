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
foreach ($dell_pc in $dell_pc_list)
{
    switch($dell_pc)
    {
        {$_ -match '^Internet\sof\sThings\s'}
        {
            $uid = "Dell::IoT::" + $dell_pc.Replace('Internet of Things ','').Replace(' ','_')
            $make = "IoT"
            $model = $dell_pc.Replace('Internet of Things ','')
        }
        {$_ -match '^Latitude\s'}
        {
            $uid = "Dell::Latitude::" + $dell_pc.Replace('Latitude ','').Replace(' ','_')
            $make = "Latitude"
            $model = $dell_pc.Replace('Latitude ','')
        }

        {$_ -match '^OptiPlex\s'}
        {
            $uid = "Dell::OptiPlex::" + $dell_pc.Replace('OptiPlex ','').Replace(' ','_')
            $make = "OptiPlex"
            $model = $dell_pc.Replace('OptiPlex ','')
        }

        {$_ -match '^Precision\s'}
        {
            $uid = "Dell::Precision::" + $dell_pc.Replace('Precision ','').Replace(' ','_')
            $make = "Precision"
            $model = $dell_pc.Replace('Precision ','')
        }

        {$_ -match '^Tablet\s'}
        {
            $uid = "Dell::Tablet::" + $dell_pc.Replace('Tablet ','').Replace(' ','_')
            $make = "Tablet"
            $model = $dell_pc.Replace('Tablet ','')
        }

        {$_ -match '^XPS Notebook\s'}
        {
            $uid = "Dell::XPSNotebook::" + $dell_pc.Replace('XPS Notebook ','').Replace(' ','_')
            $make = "XPS Notebook"
            $model = $dell_pc.Replace('XPS Notebook ','')
        }
    }

    $payload = @{
        id = 0
        uuid = [System.Guid]::NewGuid().ToString()
        uid = $uid
        originalEquipmentManufacturer = "Dell"
        make = $make
        model = $model
        productionYear = 2022
        cpuArch = @("x64")
        windowsOS = @("Windows 10","Windows 11")
    }

    $json = $payload | ConvertTo-Json

    Invoke-RestMethod -Uri https://engine.api.dev.optechx-data.com/v1/DriversCore -Method Post -Headers @{accept="application/json"}
}




