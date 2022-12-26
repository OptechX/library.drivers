# variables
$c = $PSScriptRoot
# $pc_catalog = "${c}/*.xml"

# read data to memory
# [xml]$XmlDocument = Get-Content -Path $pc_catalog
# $XmlDocument.SystemsManagementCatalog.SoftwareDistributionPackage

# load each pc object json file
[System.String[]]$json_list = Get-ChildItem -Path $PSScriptRoot/V3 -Filter *.json | `
    Where-Object -FilterScript {$_.Name -notlike "update_categories.json"} | `
    Select-Object -ExpandProperty FullName

# create blank array
$pclist = @()

# iterate through objects and add to the array
foreach ($json in $json_list)
{
    $pclist += Get-Content -Path $json | `
        ConvertFrom-Json | `
        Select-Object -ExpandProperty DisplayName
}

# resort list
$sorted_pclist = $pclist | Sort-Object
[System.String[]]$ignore_list = Get-Content -Path "${c}/lenovo_ignore_list.txt"
$lenovo_pc_list = $sorted_pclist | Where-Object -FilterScript {$_ -notin $ignore_list}

# show list
foreach ($pc in $lenovo_pc_list)
{
    $valid = $false

    switch($pc)
    {
        {$_ -match '^ThinkCentre\sThinkCentre\s'}
        {
            $uid = "Lenovo::ThinkCentre::" + $pc.Replace('ThinkCentre ThinkCentre ','').Replace(' ','_')
            $make = "ThinkCentre"
            $model = $pc.Replace('ThinkCentre ThinkCentre ','')
            $valid = $true
        }

        {$_ -match '^ThinkCentre\s'}
        {
            $uid = "Lenovo::ThinkCentre::" + $pc.Replace('ThinkCentre ','').Replace(' ','_')
            $make = "ThinkCentre"
            $model = $pc.Replace('ThinkCentre ','')
            $valid = $true
        }

        {$_ -match '^ThinkPad\sX1\s'}
        {
            $uid = "Lenovo::ThinkPadX1::" + $pc.Replace('ThinkPad X1 ','').Replace(' ','_')
            $make = "ThinkPad X1"
            $model = $pc.Replace('ThinkPad X1 ','')
            $valid = $true
        }

        {$_ -match '^ThinkPad\sYoga\s'}
        {
            $uid = "Lenovo::ThinkPadYoga::" + $pc.Replace('ThinkPad Yoga ','').Replace(' ','_')
            $make = "ThinkPad Yoga"
            $model = $pc.Replace('ThinkPad Yoga ','')
            $valid = $true
        }

        {$_ -match '^ThinkPad\s'}
        {
            $uid = "Lenovo::ThinkPad::" + $pc.Replace('ThinkPad ','').Replace(' ','_')
            $make = "ThinkPad"
            $model = $pc.Replace('ThinkPad ','')
            $valid = $true
        }

        {$_ -match '^ThinkStation\s'}
        {
            $uid = "Lenovo::ThinkStation::" + $pc.Replace('ThinkStation ','').Replace(' ','_')
            $make = "ThinkStation"
            $model = $pc.Replace('ThinkStation ','')
            $valid = $true
        }
    }

    if ($valid)
    {
        $payload = @{
            id = 0
            uuid = [System.Guid]::NewGuid().ToString()
            uid = $uid
            originalEquipmentManufacturer = "Lenovo"
            make = $make
            model = $model
            productionYear = 2022
            cpuArch = @("x64")
            windowsOS = @("Windows 10","Windows 11")
        }

        $json = $payload | ConvertTo-Json

        $json
        
        try
        {
            Invoke-RestMethod -Uri "https://engine.api.dev.optechx-data.com/v1/DriversCore" -Method Post -UseBasicParsing -Body $json -ContentType "application/json" -ErrorAction Stop
            Start-Sleep -Milliseconds 50
        }
        catch
        {
            Write-Error "Error: $($_.Exception)"
            $Body
        }
    }
    else
    {
        $pc
    }
}