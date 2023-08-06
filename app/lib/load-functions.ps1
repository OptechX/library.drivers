class DriversCorePayload {
    [Int]$id = 0
    [System.String]$uid
    [System.String]$oem
    [System.String]$make
    [System.String]$model
    [System.DateTime]$lastUpdated
    [System.String[]]$supportedWinRelease
}

function Update-ApiDriversCore {
    [CmdletBinding()]
    param (
        [DriversCorePayload]$Payload,
        [System.String]$API_BASE_URI = $Env:API_BASE_URI
    )
    
    $UID = $Payload.uid

    # find if object exists
    try {
        $API_RESPONSE = Invoke-WebRequest -Uri "${API_BASE_URI}/api/DriverCore/uid/${UID}" -Method Get -UseBasicParsing -SkipHttpErrorCheck -ErrorAction Stop
        
        switch ($API_RESPONSE.StatusCode)
        {
            # 404 == object not found
            404 {
                try {
                    $json = $Payload | ConvertTo-Json
                    Invoke-RestMethod -Uri "${API_BASE_URI}/api/DriverCore" -Method Post -UseBasicParsing -Body $json -ContentType "application/json"
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
                
                # update supportedWinRelease (if required)
                [System.Collections.ArrayList]$tmpArrayList = [System.String[]]$MATCHED_DATA.supportedWinRelease
                if ($Payload.supportedWinRelease -notin $tmpArrayList)
                {
                    Write-Output "supportedWinRelease not matched"
                    $tmpArrayList.Add($Payload.supportedWinRelease)
                    $Payload.supportedWinRelease = $tmpArrayList.ToArray()
                    $INVOKE_UPDATE = $true
                }
                
                # update entry date
                if ([DateTime]$Payload.productionYear -gt [DateTime]$MATCHED_DATA.productionYear)
                {
                    Write-Output "productionYear not matched"
                    $INVOKE_UPDATE = $true
                }
                
                if ($INVOKE_UPDATE)
                {
                    # retain existing values required
                    $Payload.id = $MATCHED_DATA.id
                    
                    # create JSON object
                    $json = $Payload | ConvertTo-Json

                    Write-Output "Object to update:"
                    $json
                    
                    # update API endpoint with new data
                    try {
                        Write-Output "Update URI: ${API_BASE_URI}/api/DriverCore/$($Payload.id)"
                        Invoke-RestMethod -Uri "${API_BASE_URI}/api/DriverCore/$($Payload.id)" -Method Put -UseBasicParsing -Body $json -Headers @{"Content-Type"="application/json"} -ErrorAction Stop
                    } catch {
                        Write-Output "match in matched_data error 2"
                        "${API_BASE_URI}/api/DriverCore/$($json.id)"
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