$srcFile = "./app/data/Lenovo/lenovo-lenovolaptop.csv"
$data = Import-Csv -Path $srcFile

$win10Results = @()
$win11Results = @()

$data | Where-Object -FilterScript { $_.Win10 -like "Yes" } | ForEach-Object {
    $obj = $_    
    
    $resultObject = [PSCustomObject]@{
        Make = "Laptop"
        Model = $obj.Model
        Updated = (Get-Date).ToString("MM/dd/yyyy")
    }

    $win10Results += $resultObject
}

$data | Where-Object -FilterScript { $_.Win11 -like "Yes" } | ForEach-Object {
    $obj = $_    
    
    $resultObject = [PSCustomObject]@{
        Make = "Laptop"
        Model = $obj.Model
        Updated = (Get-Date).ToString("MM/dd/yyyy")
    }

    $win11Results += $resultObject
}

$win10FileContent = "./app/data/Lenovo/lenovo-laptop-win10.csv"
$win11FileContent = "./app/data/Lenovo/lenovo-laptop-win11.csv"

$win10Results | Export-Csv -Path $win10FileContent -NoTypeInformation
$win11Results | Export-Csv -Path $win11FileContent -NoTypeInformation

$win10FileContent,$win11FileContent | ForEach-Object {
    $fileConent = Get-Content -Path $_
    $updatedContent = $fileConent -replace '"', ''
    $updatedContent | Set-Content -Path $_
}

# clean up
Remove-Item -Path $srcFile -Confirm:$false -Force