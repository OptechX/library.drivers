# Surface Book
# Surface Book 3
Import-Module -Name Selenium
$Driver = Start-SeChrome
Start-Sleep -Seconds 10
Enter-SeUrl https://www.microsoft.com/download/details.aspx?id=101315 -Driver $Driver
$Element = Find-SeElement -Driver $Driver -Selection '/html/body/main/div/div/form/div/div[2]/div/div/div/div[2]/div/div/div/div/div[2]/div[3]/div/div/div/a'
Invoke-SeClick -Element $Element
$Element = Find-SeElement -Driver $Driver -Selection '/html/body/main/div/div/form/div/div[2]/div/div/div/div[2]/div/div/div/div/div[2]/div[3]/div/div/div/div/div/div[2]/div/div[2]/div/div[2]/div/div[1]/div/div/div/div/div[2]/div[1]/div[1]/div/div[1]/input'
Invoke-SeClick -Element $Element
$Element = FInd-SeElement -Driver $Driver -Selection '//*[@id="5b70c241-07ba-40b9-c0c1-6aae74ab472b"]'
Invoke-SeClick -Element $Element
$a = 0
do {
    $b = (Get-ChildItem -Path $HOME\Downloads -Filter "*.part").Count
    Start-Sleep -Seconds 30
} until (
    $b -eq $a
)
<# something goes here #>
$Driver.Close()
$Driver.Quit()


# Surface Book 2
# https://www.microsoft.com/download/details.aspx?id=56261

# Surface Book
# https://www.microsoft.com/download/details.aspx?id=49497