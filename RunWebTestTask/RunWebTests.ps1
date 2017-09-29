param(
    [string]$WebTestLocation,
    [string]$ResultsLocation,
    [string]$TestSettingsLocation,
    [switch]$PublisTestResults,
    [switch]$OverWriteTestResults
)

# Checks if the folder of the path for the Test Results exists. If not, creates it.
$testresultsfolder = Split-Path $ResultsLocation

if ($PublisTestResults) {
    Write-Warning "Publish Test Results set to true but feature still not implemented."
}

# Checking wether Test Results file exists or not. If Overwrite set to true, removes it to be recreated after.
if (-Not (Test-Path $testresultsfolder -PathType Container)) {
    Write-Warning "Folder $testresultsfolder does not exist. Creating..."
    New-Item $testresultsfolder -Type Directory
}
elseif (Test-Path $ResultsLocation) {
    if ($OverWriteTestResults) {
        Write-Warning "The Test Results file $ResultsLocation already exists."
        Write-Warning "OverwriteTestResults set to true. Replacing it..."
        Remove-Item "$testresultsfolder\\*" -Recurse
    }
    else {
        Write-Error "The Test Results file $ResultsLocation already exists."
    }
}

# Retrieves all the web test files under the specified folder
$files = Get-ChildItem $WebTestLocation -Filter "*.webtest"
$paramstring = ""

# Adds all web test files to an array
foreach($webtest in $files){
    $paramstring = $paramstring + "/testcontainer:""$WebTestLocation\" + $webtest + """ "
}

# If specified, checks if the Test Settings file path is valid. If not, switches not to use Test Settings file.
if (-not ([string]::IsNullOrEmpty($TestSettingsLocation))) {
    if (Test-Path $TestSettingsLocation) {
        $paramstring = $paramstring + "/testsettings:""" + $TestSettingsLocation + """ "
    }
    else {
        Write-Warning "You specified an invalid Test Settings location. Switching to run without a Test Settings file."
    }
}

$cmd = '& "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\MSTest.exe" ' + $paramstring + '/usestderr /resultsfile:"' + $ResultsLocation + '"'
#Write-Host $cmd
Invoke-Expression $cmd