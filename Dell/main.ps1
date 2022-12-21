# variables
$c = $PSScriptRoot
$dell_cab_file = "https://downloads.dell.com/catalog/DriverPackCatalog.cab"
$cab_file = "${c}/$(Split-Path -Path $dell_cab_file -Leaf)"

# get the dell driver CAB file
Invoke-WebRequest -Uri $dell_cab_file -UseBasicParsing -DisableKeepAlive -OutFile $cab_file

# expand the cab file locally
cabextract $cab_file

# show me all the files
tree