param(
    [string]$webtestlocation,
    [string]$resultslocation,
    [string]$testsettingslocation,
    [bool]$publistestresults
)

$files = Get-ChildItem $webtestlocation -Filter "*.webtest"
$paramstring = ""

foreach($webtest in $files){
    $paramstring = $paramstring + "/testcontainer:""$webtestlocation\" + $webtest + """ "
}

if (-not ([string]::IsNullOrEmpty($testsettingslocation))) {
    if (Test-Path $testsettingslocation) {
        $paramstring = $paramstring + "/testsettings:""" + $testsettingslocation + """ "
    }
    else {
        Write-Warning "You specified an invalid Test Settings location. Switching to run without a Test Settings file."
    }
}

$cmd = '& "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\MSTest.exe" ' + $paramstring + '/usestderr /resultsfile:"' + $resultslocation + '"'
Write-Host $cmd