# variables
$c = $PSScriptRoot
$microsoft_catalogs_url = "https://go.microsoft.com/fwlink/?linkid=874591"
$download_page = ([System.Net.WebRequest]::CreateDefault($microsoft_catalogs_url)).GetResponse()
$microsoft_cabfile = Split-Path -Path $download_page.ResponseUri.OriginalString -Leaf
$cab_file = "${c}/data/${microsoft_cabfile}"
$xml_file = "${c}/data/$($microsoft_cabfile.Replace('.cab','.xml'))"

# get the Microsoft cab file
Invoke-WebRequest -Uri $download_page.ResponseUri.OriginalString -OutFile $cab_file -UseBasicParsing -DisableKeepAlive

# expand the cab file locally
cabextract $cab_file --directory "SCCM/data"

# read xml of each library file
[xml]$catalogXMLPayload = Get-Content -Path $xml_file

# expaand each library into separate directory, and copy library data
foreach ($payload in $catalogXMLPayload.Catalogs.Catalog)
{
    $publisher = $payload.LocalizedProperties.Publisher
    $cabfile = $payload.DownloadUrl

    New-Item -ItemType Directory -Name $publisher -Force -Confirm:$false
    Invoke-WebRequest -Uri $cabfile -DisableKeepAlive -UseBasicParsing `
        -OutFile "./${publisher}/$(Split-Path -Path $cabfile -Leaf)"
    cabextract "./${publisher}/$(Split-Path -Path $cabfile -Leaf)" --directory $publisher

    # copy local library data
    Copy-Item -Path "${c}/lib/${publisher}/*" -Destination  "./${publisher}/" -Recurse -Force -Confirm:$false
}

# sanity check
tree