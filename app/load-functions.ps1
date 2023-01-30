class DriversCorePayload {
    [int16]$id = 0
    [System.Guid]$uuid = [System.Guid]::NewGuid().ToString()
    [System.String]$uid
    [System.String]$originalEquipmentManufacturer
    [System.String]$make
    [System.String]$model
    [System.Int64]$productionYear
    [System.String[]]$cpuArch
    [System.String[]]$windowsOS
}

function Update-ApiDriversCore {
    [CmdletBinding()]
    param (
        [DriversCorePayload]$Payload,
        [System.String]$API_BASE_URI = 'https://engine.api.prod.optechx-data.com'
    )
    
    $UID = $Payload.uid

    # find if object exists
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
                $MATCHED_DATA = $API_RESPONSE.Content | ConvertFrom-Json

                [System.Boolean]$INVOKE_UPDATE = $false

                # update CpuArch (if required)
                [System.Collections.ArrayList]$tmpArrayList = $Payload.cpuArch
                if ($MATCHED_DATA.cpuArch -notin $tmpArrayList)
                {
                    $tmpArrayList.Add($MATCHED_DATA.cpuArch)
                    $Payload.cpuArch = $tmpArrayList.ToArray()
                    $INVOKE_UPDATE = $true
                }

                # update WindowsOS (if required)
                [System.Collections.ArrayList]$tmpArrayList = $Payload.windowsOS
                if ($MATCHED_DATA.windowsOS -notin $tmpArrayList)
                {
                    $tmpArrayList.Add($MATCHED_DATA.windowsOS)
                    $Payload.windowsOS = $tmpArrayList.ToArray()
                    $INVOKE_UPDATE = $true
                }

                # update entry date
                if ([int]$Payload.productionYear -gt [int]$MATCHED_DATA.productionYear)
                {
                    $INVOKE_UPDATE = $true
                }

                if ($INVOKE_UPDATE)
                {
                    # retain existing values required
                    $Payload.id = $MATCHED_DATA.$id
                    $Payload.uuid = $MATCHED_DATA.uuid

                    # create JSON object
                    $json = $Payload | ConvertTo-Json

                    # update API endpoint with new data
                    try {
                        Invoke-RestMethod -Uri "${API_BASE_URI}/v1/DriversCore/$($json.id)" -Method Put -UseBasicParsing -Body $json -ContentType "application/json" -ErrorAction Stop
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