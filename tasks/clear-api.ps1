foreach ($id in (Invoke-RestMethod -Uri https://engine.api.prod.optechx-data.com/v1/DriversCore -Method Get).id)
{
    Write-Output "Clearing record: ${id}"
    Invoke-RestMethod -Uri "https://engine.api.prod.optechx-data.com/v1/DriversCore/${id}" -Method Delete -Headers @{accept="json/application"}
}