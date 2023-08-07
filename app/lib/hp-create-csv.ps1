$data = Import-Csv -Path ./app/data/HP/hp-all.csv

$win10Results = @()
$win11Results = @()

$data | Where-Object -FilterScript { $_.Win10 -like "Yes" } | ForEach-Object {
    $obj = $_    
    
    $resultObject = [PSCustomObject]@{
        Make = $obj.Series
        Model = $obj.Model
        Updated = (Get-Date).ToString("MM/dd/yyyy")
    }

    $win10Results += $resultObject
}

$data | Where-Object -FilterScript { $_.Win11 -like "Yes" } | ForEach-Object {
    $obj = $_    
    
    $resultObject = [PSCustomObject]@{
        Make = $obj.Series
        Model = $obj.Model
        Updated = (Get-Date).ToString("MM/dd/yyyy")
    }

    $win11Results += $resultObject
}

$win10FileContent = "./app/data/HP/hp-win10.csv"
$win11FileContent = "./app/data/HP/hp-win11.csv"

$win10Results | Export-Csv -Path $win10FileContent -NoTypeInformation
$win11Results | Export-Csv -Path $win11FileContent -NoTypeInformation

$win10FileContent,$win11FileContent | ForEach-Object {
    $fileConent = Get-Content -Path $_
    $updatedContent = $fileConent -replace '"', ''
    $updatedContent | Set-Content -Path $_
}

# clean up
Remove-Item -Path ./app/data/HP/hp-all.csv -Confirm:$false -Force