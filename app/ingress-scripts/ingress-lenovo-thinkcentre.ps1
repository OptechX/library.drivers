[System.String]$REPO_ROOT = Split-Path -Path $(Split-Path -Path $PSScriptRoot -Parent) -Parent
[System.String]$MANUFACTURER = "Lenovo"
[System.String]$API_MAKE = "ThinkCentre"
<# Note: Lenovo HAS LIMITED SUPPORT FOR x86 #>

#region Latitude
# [System.String]$PC_MAKE = ""
[System.String]$FILENAME_FILTER = "ThinkCentre"
[System.String[]]$CsvFiles = (Get-ChildItem -Path "${REPO_ROOT}/app/data/${MANUFACTURER}/*${FILENAME_FILTER}*" -Filter *.csv -Recurse | Select-Object -ExpandProperty FullName)

foreach ($csv in $CsvFiles)
{
    # if ($csv -like "*win10*") { [System.String]$windowsOS = "Windows 10"}
    # if ($csv -like "*win11*") { [System.String]$windowsOS = "Windows 11"}
    
    $PC_LIST = Import-Csv -Path $csv

    foreach ($pc in $PC_LIST)
    {
        # Make,Model,Updated
        [System.String]$pcMake = $API_MAKE
        [System.String]$pcModel = $pc.'Model'
        [System.String]$pcUpdated = (Get-Date).ToString('yyyy')

        # UID
        $pattern = '[^a-zA-Z_0-9:]'
        $UID = "${MANUFACTURER}::${pcMake}::${pcModel}" -replace ' ','_'
        $UID = $UID -replace $pattern, ''
        
        # UPDATED/PRODUCTION YEAR
        [System.String]$UpdatedYear = $pcUpdated

        Write-Output "About to run test on: ${UID}"

        # CONFIG WINDOWS OS
        if ($pc.'Win7' -like 'Yes')
        {
            $windowsOS = @("Windows 7")

            # PAYLOAD
            $Payload = [DriversCorePayload]::new()
            $Payload.id = 0
            $Payload.uuid = [System.Guid]::NewGuid().ToString()
            $Payload.uid = $UID
            $Payload.originalEquipmentManufacturer = $MANUFACTURER
            $Payload.make = $pcMake
            $Payload.model = $pcModel
            $Payload.productionYear = [Int64]$UpdatedYear
            $Payload.cpuArch = @("x64")
            $Payload.windowsOS = @($windowsOS)
            
            # TRIGGER UPDATE
            Update-ApiDriversCore -Payload $Payload

            Start-Sleep -Milliseconds 50
        }
        if ($pc.'Win8.1' -like 'Yes')
        {
            $windowsOS = @("Windows 8.1")
            
            # PAYLOAD
            $Payload = [DriversCorePayload]::new()
            $Payload.id = 0
            $Payload.uuid = [System.Guid]::NewGuid().ToString()
            $Payload.uid = $UID
            $Payload.originalEquipmentManufacturer = $MANUFACTURER
            $Payload.make = $pcMake
            $Payload.model = $pcModel
            $Payload.productionYear = [Int64]$UpdatedYear
            $Payload.cpuArch = @("x64")
            $Payload.windowsOS = @($windowsOS)
            
            # TRIGGER UPDATE
            Update-ApiDriversCore -Payload $Payload

            Start-Sleep -Milliseconds 50
        }
        if ($pc.'Win10' -like 'Yes')
        {
            $windowsOS = @("Windows 10")
            
            # PAYLOAD
            $Payload = [DriversCorePayload]::new()
            $Payload.id = 0
            $Payload.uuid = [System.Guid]::NewGuid().ToString()
            $Payload.uid = $UID
            $Payload.originalEquipmentManufacturer = $MANUFACTURER
            $Payload.make = $pcMake
            $Payload.model = $pcModel
            $Payload.productionYear = [Int64]$UpdatedYear
            $Payload.cpuArch = @("x64")
            $Payload.windowsOS = @($windowsOS)
            
            # TRIGGER UPDATE
            Update-ApiDriversCore -Payload $Payload

            Start-Sleep -Milliseconds 50
        }
        if ($pc.'Win11' -like 'Yes')
        {
            $windowsOS = @("Windows 11")
            
            # PAYLOAD
            $Payload = [DriversCorePayload]::new()
            $Payload.id = 0
            $Payload.uuid = [System.Guid]::NewGuid().ToString()
            $Payload.uid = $UID
            $Payload.originalEquipmentManufacturer = $MANUFACTURER
            $Payload.make = $pcMake
            $Payload.model = $pcModel
            $Payload.productionYear = [Int64]$UpdatedYear
            $Payload.cpuArch = @("x64")
            $Payload.windowsOS = @($windowsOS)
            
            # TRIGGER UPDATE
            Update-ApiDriversCore -Payload $Payload

            Start-Sleep -Milliseconds 50
        }
    }
}
#endregion