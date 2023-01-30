[System.String]$REPO_ROOT = Split-Path -Path $(Split-Path -Path $PSScriptRoot -Parent) -Parent
[System.String]$MANUFACTURER = "Dell"
<# Note: DELL DOES NOT SUPPORT x86 ANYMORE #>

#region Latitude
[System.String]$PC_MAKE = "Latitude"
[System.String[]]$CsvFiles = (Get-ChildItem -Path "${REPO_ROOT}/src/Dell/${PC_MAKE}/output" -Filter *.csv -Recurse | Select-Object -ExpandProperty FullName)

foreach ($csv in $CsvFiles)
{
    if ($csv -like "*win10*") { [System.String]$windowsOS = "Windows 10"}
    if ($csv -like "*win11*") { [System.String]$windowsOS = "Windows 11"}
    
    $PC_LIST = Import-Csv -Path $csv

    foreach ($pc in $PC_LIST)
    {
        # Make,Model,Updated
        [System.String]$pcMake = $pc.'Make'
        [System.String]$pcModel = $pc.'Model'
        [System.String]$pcUpdated = $pc.'Updated'

        # UID
        $pattern = '[^a-zA-Z_0-9:]'
        $uid = "${MANUFACTURER}::${pcMake}::${pcModel}" -replace ' ','_'
        $uid = $uid -replace $pattern, ''
        
        # UPDATED/PRODUCTION YEAR
        [System.String]$UpdatedYear = $pcUpdated.Split('/')[-1]

        # PAYLOAD
        $payload = [DriversCorePayload]::new()
        $payload.id = 0
        $payload.uuid = [System.Guid]::NewGuid().ToString()
        $payload.uid = $uid
        $payload.originalEquipmentManufacturer = $MANUFACTURER
        $payload.make = $pcMake
        $payload.model = $pcModel
        $payload.productionYear = [Int64]$UpdatedYear
        $payload.cpuArch = @("x64")
        $payload.windowsOS = @($windowsOS)

        # TRIGGER UPDATE
        # Update-ApiDriversCore -Payload $payload

        [System.String]$API_BASE_URI = 'https://engine.api.prod.optechx-data.com'
        $UID = $Payload.uid
        try {
            $API_RESPONSE = Invoke-WebRequest -Uri "${API_BASE_URI}/v1/DriversCore/uid/${UID}" -Method Get -UseBasicParsing -SkipHttpErrorCheck -ErrorAction Stop
    
            switch ($API_RESPONSE.StatusCode)
            {
                # 404 == object not found
                404 {
                    try {
                        $json = $Payload | ConvertTo-Json
                        Invoke-RestMethod -Uri "${API_BASE_URI}/v1/DriversCore" -Method Post -UseBasicParsing -Body $json -ContentType "application/json"
                    }
                    catch {
                        Write-Output "MAIN LOGIC 404 ERROR"
                        Write-Error $_.Exception
                        Write-Output "START DIAGNOSTIC DATA>>>"
                        Write-Output $json
                        Write-Output "<<<END DIAGNOSTIC DATA"
                    }
                }
                # 200 == object found
                200 {
                    Write-Output "200 == object found"
                    [DriversCorePayload]$MATCHED_DATA = $API_RESPONSE.Content | ConvertFrom-Json
    
                    [System.Boolean]$INVOKE_UPDATE = $false
    
                    # update CpuArch (if required)
                    [System.Collections.ArrayList]$tmpArrayList = $Payload.cpuArch
                    if ($MATCHED_DATA.cpuArch -notin $tmpArrayList)
                    {
                        Write-Output "cpuArch not matched"
                        $tmpArrayList.Add($MATCHED_DATA.cpuArch)
                        $Payload.cpuArch = $tmpArrayList.ToArray()
                        $INVOKE_UPDATE = $true
                    }
    
                    # update WindowsOS (if required)
                    [System.Collections.ArrayList]$tmpArrayList = $Payload.windowsOS
                    if ($MATCHED_DATA.windowsOS -notin $tmpArrayList)
                    {
                        Write-Output "windowsOS not matched"
                        $tmpArrayList.Add($MATCHED_DATA.windowsOS)
                        $Payload.windowsOS = $tmpArrayList.ToArray()
                        $INVOKE_UPDATE = $true
                    }
    
                    # update entry date
                    if ([int]$Payload.productionYear -gt [int]$MATCHED_DATA.productionYear)
                    {
                        Write-Output "productionYear not matched"
                        $INVOKE_UPDATE = $true
                    }
    
                    if ($INVOKE_UPDATE)
                    {
                        # retain existing values required
                        $Payload.id = $MATCHED_DATA.id
                        $Payload.uuid = $MATCHED_DATA.uuid
    
                        # create JSON object
                        $json = $Payload | ConvertTo-Json

                        Write-Output "Object to update:"
                        $json
    
                        # update API endpoint with new data
                        try {
                            Write-Output "Update URI: ${API_BASE_URI}/v1/DriversCore/$($PAYLOAD.id)"
                            Invoke-RestMethod -Uri "${API_BASE_URI}/v1/DriversCore/$($PAYLOAD.id)" -Method Put -UseBasicParsing -Body $json -Headers @{"Content-Type"="application/json"} -ErrorAction Stop
                        } catch {
                            Write-Output "match in matched_data error 2"
                            "${API_BASE_URI}/v1/DriversCore/$($json.id)"
                            $json
                        }
                    }
                }
                Default {
                    $resp_code = $API_RESPONSE.StatusCode
                    Write-Output "Unknown error: ${resp_code}"
                }
            }
        }
        catch {
            <#Do this if a terminating exception happens#>
            Write-Output "TERMINATING RESPONSE RECEIVED"
            Write-Error $_.Exception
            Write-Output "START DIAGNOSTIC DATA>>>"
            Write-Output $UID
            Write-Output "<<<END DIAGNOSTIC DATA"
        }
    }
}
#endregion