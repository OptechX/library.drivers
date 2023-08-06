[System.String]$REPO_ROOT = Split-Path -Path $(Split-Path -Path $PSScriptRoot -Parent) -Parent
[System.String]$MANUFACTURER = "Dell"
<# Note: DELL DOES NOT SUPPORT x86 ANYMORE #>

#region Latitude
[System.String]$PC_MAKE = "Latitude"
[System.String[]]$CsvFiles = (Get-ChildItem -Path "${REPO_ROOT}/app/data/${MANUFACTURER}/*${PC_MAKE}*" -Filter *.csv -Recurse | Select-Object -ExpandProperty FullName)

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
        try {
            [System.DateTime]$pcUpdated = [DateTime]::ParseExact($pc.'Updated', "MM/dd/yyyy", [System.Globalization.CultureInfo]::InvariantCulture)

            # UID
            $pattern = '[^a-zA-Z_0-9:]'
            $UID = "${MANUFACTURER}::${pcMake}::${pcModel}" -replace ' ','_'
            $UID = $UID -replace $pattern, ''
            
            # UPDATED/PRODUCTION YEAR
            # [System.String]$UpdatedYear = $pcUpdated.Split('/')[-1]

            # PAYLOAD
            $Payload = [DriversCorePayload]::new()
            $Payload.id = 0
            $Payload.uid = $UID
            $Payload.oem = $MANUFACTURER
            $Payload.make = $pcMake
            $Payload.model = $pcModel
            $Payload.lastUpdated = $pcUpdated
            $Payload.supportedWinRelease = @($windowsOS)

            Write-Output "About to run test on: ${UID}"
            
            # TRIGGER UPDATE
            Update-ApiDriversCore -Payload $Payload

            Start-Sleep -Milliseconds 50

            $Payload
        }
        catch {
            <# DO NOTHING, DATA IS CRAP #>
        }   
    }
}
#endregion