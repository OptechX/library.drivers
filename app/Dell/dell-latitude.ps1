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
        Update-ApiDriversCore -Payload $payload
    }
}
#endregion