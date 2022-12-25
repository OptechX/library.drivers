foreach ($id in (Invoke-RestMethod -Uri https://engine.api.dev.optechx-data.com/v1/DriversCore -Method Get).id)
{
    Invoke-RestMethod -Uri "https://engine.api.dev.optechx-data.com/v1/DriversCore${id}" -Method Delete -Headers @{accept="json/application"}
    Start-Sleep -Milliseconds 50
}