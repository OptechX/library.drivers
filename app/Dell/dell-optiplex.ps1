[System.String]$REPO_ROOT = Split-Path -Path $(Split-Path -Path $PSScriptRoot -Parent) -Parent
[System.String]$MANUFACTURER = "Dell"
<# Note: DELL DOES NOT SUPPORT x86 ANYMORE #>

#region Latitude
[System.String]$PC_MAKE = "OptiPlex"
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
        $UID = "${MANUFACTURER}::${pcMake}::${pcModel}" -replace ' ','_'
        $UID = $UID -replace $pattern, ''
        
        # UPDATED/PRODUCTION YEAR
        [System.String]$UpdatedYear = $pcUpdated.Split('/')[-1]

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

        Write-Output "About to run test on: ${UID}"

        # [System.String]$API_BASE_URI = 'https://engine.api.prod.optechx-data.com'
        
        # TRIGGER UPDATE
        Update-ApiDriversCore -Payload $Payload

        

        Start-Sleep -Milliseconds 50
    }
}
#endregion