# variables
$c = $PSScriptRoot

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

# re-sort the pc list
$sorted_pclist = $pclist | Sort-Object
[System.String[]]$ignore_list = Get-Content -Path "${c}/ignore_list.txt"
$pc_list = $sorted_pclist | Where-Object -FilterScript {$_ -notin $ignore_list}


# iterate through each item, update the API
foreach ($pc in $pc_list)
{
    $make = $pc.Split(' ')[1]
    $model = $pc.Replace("HP ${make} ","")

    $uid = "HP::${make}::${model}".Replace(' ','_')
    
    $payload = @{
        id = 0
        uuid = [System.Guid]::NewGuid().ToString()
        uid = $uid
        originalEquipmentManufacturer = "HP"
        make = $make
        model = $model
        productionYear = 2022
        cpuArch = @("x64")
        windowsOS = @("Windows 10","Windows 11")
    }

    $json = $payload | ConvertTo-Json

    # create dummy request for exisiting UID first
    $req = Invoke-WebRequest -Uri "https://engine.api.dev.optechx-data.com/v1/DriversCore/uid/${uid}" -Method GET -SkipHttpErrorCheck

    switch ($req.StatusCode)
    {
        404 {
            try
            {
                Invoke-RestMethod -Uri "https://engine.api.dev.optechx-data.com/v1/DriversCore" -Method Post -UseBasicParsing -Body $json -ContentType "application/json" -ErrorAction Stop
            }
            catch
            {
                Write-Error "Error: $($_.Exception)"
                $Body
                $json
            }
        }
        200 {
            # record exists, no action required
            Write-Output "Record exists"
        }
        Default {
            "other reason for failure"
            $json
        }
    }        
    
    Start-Sleep -Seconds 2
}