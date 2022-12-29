$files = Get-ChildItem -Path /home/runner/work/optechx.drivers/optechx.drivers/downloads -Filter "*.msi"


foreach ($file in $files)
{
    if ($file -like "SurfaceBook_Win*")
    {
        if ($file -like "*_Win10_*")
        {
            Write-Host "Surface Book is Windows 10"
        }
        if ($file -like "*_Win11_*")
        {
            Write-Host "Surface Book is Windows 11"
        }
    }
    if ($file -like "SurfaceBook2_Win*")
    {
        if ($file -like "*_Win10_*")
        {
            Write-Host "Surface Book 2 is Windows 10"
        }
        if ($file -like "*_Win11_*")
        {
            Write-Host "Surface Book 2 is Windows 11"
        }
    }
    if ($file -like "SurfaceBook3_Win*")
    {
        if ($file -like "*_Win10_*")
        {
            Write-Host "Surface Book 3 is Windows 10"
        }
        if ($file -like "*_Win11_*")
        {
            Write-Host "Surface Book 3 is Windows 11"
        }
    }
}
