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
    $pclist += Get-Content -Path $json | ConvertFrom-Json | Select-Object -ExpandProperty DisplayName
}

# re-sort the pc list
$sorted_pclist = $pclist | Sort-Object
[System.String[]]$ignore_list = Get-Content -Path "${c}/ignore_list.txt"
$pc_list = $sorted_pclist | `
    Where-Object -FilterScript {$_ -notin $ignore_list} | `
    Where-Object -FilterScript {$_ -notlike "Internet*"} | `
    Where-Object -FilterScript {$_ -notlike "Tablet*"} | `
    Where-Object -FilterScript {$_ -notlike "Latitude 1*"} | `
    Where-Object -FilterScript {$_ -notlike "Latitude 2*"} | `
    Where-Object -FilterScript {$_ -notlike "Latitude 3*"} | `
    Where-Object -FilterScript {$_ -notlike "Latitude 4*"} | `
    Where-Object -FilterScript {$_ -notlike "Latitude 5*"} | `
    Where-Object -FilterScript {$_ -notlike "Latitude 6*"}

# iterate through each item, update the API
foreach ($pc in $pc_list)
{
    $make = $pc.Split(' ')[0]
    $model = $pc.Replace("${make} ","")

    $pattern = '[^a-zA-Z_0-9:]'
    $uid = "Dell::${make}::${model}" -replace ' ','_'
    $uid = $uid -replace $pattern, ''

    $payload = @{
        id = 0
        uuid = [System.Guid]::NewGuid().ToString()
        uid = $uid
        originalEquipmentManufacturer = "Dell"
        make = $make
        model = $model
        productionYear = $((Get-Date).ToString('yyyy'))
        cpuArch = @("x64")
        windowsOS = @("Windows 10","Windows 11")
    }

    $json = $payload | ConvertTo-Json

    # create dummy request for exisiting UID first
    $req = Invoke-WebRequest -Uri "${Env:API_PROD_URI}/v1/DriversCore/uid/${uid}" -Method GET -SkipHttpErrorCheck

    switch ($req.StatusCode)
    {
        404 {
            try {
                Invoke-RestMethod -Uri "${Env:API_PROD_URI}/v1/DriversCore" -Method Post -UseBasicParsing -Body $json -ContentType "application/json" -ErrorAction Stop
                $json
            }
            catch {
                Write-Error "Error: $($_.Exception)"
                $json
            }
        }
        200 {
            # record exists, update existing record
            try {
                Invoke-RestMethod -Uri "${Env:API_PROD_URI}/v1/DriversCore/${uid}" -Method Update -UseBasicParsing -Body $json -ContentType "application/json" -ErrorAction Stop
            }
            catch {
                Write-Error "Error: $($_.Exception)"
                $json
            }
        }
        Default {
            Write-Output "Other reason for failure"
            $json
        }
    }
    
    # sleep on loop
    Start-Sleep -Seconds 1
}