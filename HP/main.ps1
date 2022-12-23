# variables
$c = $PSScriptRoot
$dell_cab_file = "https://hpia.hpcloud.hp.com/downloads/sccmcatalog/HpCatalogForSms.latest.cab"
http://ftp.hp.com/pub/softlib/software/sms_catalog/HpCatalogForSms.latest.cab
$cab_file = "${c}/data/$(Split-Path -Path $dell_cab_file -Leaf)"

# get the dell driver CAB file
Invoke-WebRequest -Uri $dell_cab_file -UseBasicParsing -DisableKeepAlive -OutFile $cab_file

# expand the cab file locally
cabextract $cab_file --directory "HP/data"

# show me all the files
tree