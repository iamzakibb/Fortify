# Step 1: Define variables
$fortifySscUrl = "https://fortify.com/ssc"
$accessToken = "your_access_token"
$applicationName = "org.frb.atl.adsfortify_atl-ads-cia"

# Step 2: Retrieve CIA Application ID from Fortify SSC
function GetCIAApplicationId {
    param (
        [string]$fortifySscUrl,
        [string]$accessToken
    )
    $applicationsEndpoint = "$fortifySscUrl/api/v1/reports"
    
    try {
        $headers = @{
            "Authorization" = "FortifyToken $accessToken"
            "Accept"        = "application/json"
        }

        $response = Invoke-RestMethod -Uri $applicationsEndpoint -Headers $headers -Method Get

        if ($response) {
            $applicationsData = $response.data
            $ciaApplication = $applicationsData | Where-Object { $_.name -eq "CIA" }
            if ($ciaApplication) {
                return $ciaApplication.id
            } else {
                Write-Host "CIA application not found."
                return $null
            }
        } else {
            Write-Host "Failed to retrieve applications. Status code: $($response.StatusCode)"
            Write-Host $response
            return $null
        }
    }
    catch {
        Write-Host "An error occurred: $($_.Exception.Message)"
        if ($_.Exception.Response) {
            $errorResponse = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($errorResponse)
            $reader.BaseStream.Position = 0 
            $reader.DiscardBufferedData()
            $responseBody = $reader.ReadToEnd()
        }
        return $null
    }
}

# Step 3: Retrieve Latest Scan Result for the CIA Application
function GetLatestScanResult {
    param (
        [string]$applicationId,
        [string]$fortifySscUrl,
        [string]$accessToken
    )
    $latestScanResultEndpoint = "$fortifySscUrl/api/v1/applications/$applicationId/current-version/scans"
    try {
        $headers = @{
            "Authorization" = "Bearer $accessToken"
            "Accept"        = "application/json"
        }
        $response = Invoke-RestMethod -Uri $latestScanResultEndpoint -Method Get -Headers $headers
        if ($response) {
            $latestScanResult = $response.data | Sort-Object -Property { [DateTime]::Parse($_.date) } -Descending | Select-Object -First 1
            return $latestScanResult
        } else {
            Write-Host "Failed to retrieve latest scan result for CIA application."
            return $null
        }
    }
    catch {
        Write-Host "An error occurred: $($_.Exception.Message)"
        return $null
    }
}

# Step 4: Compare Latest Scan Result with System Categorization
function CompareWithSystemCategorization {
    param (
        [object]$latestScanResult,
        [object[]]$systemCategorization
    )
    if ($latestScanResult) {
        $severity = $latestScanResult.friority
        $matchingCategory = $systemCategorization | Where-Object { $_.ProjectName -eq $applicationName }
        if ($matchingCategory) {
            Write-Host "Application '$applicationName' found in system categorization under $($matchingCategory.Categorization)"
            Write-Host "Latest Scan Result Severity: $severity"
            return $severity
        } else {
            Write-Host "Application '$applicationName' not found in system categorization."
            return "Unknown"
        }
    } else {
        Write-Host "Latest scan result not available for '$applicationName'."
        return "Unknown"
    }
}

# Step 5: Call functions to retrieve CIA application ID, latest scan result, and compare with system categorization
$ciaApplicationId = GetCIAApplicationId -fortifySscUrl $fortifySscUrl -accessToken $accessToken
if ($ciaApplicationId) {
    $latestScanResult = GetLatestScanResult -applicationId $ciaApplicationId -fortifySscUrl $fortifySscUrl -accessToken $accessToken
    $systemCategorization = @(
        # System categorization data for CIA application
        [PSCustomObject]@{
            ProjectName = "Contingency Info Anywhere (CIA)"
            RiskLevel = "Low"
            RiskTolerance = "Moderate/Medium"
            Categorization = "SAST"
            BuildArtifactRepo = "AZDO, Repo, Files, (Project Name)"
        }
        # Add more entries as needed
    )
    $severity = CompareWithSystemCategorization -latestScanResult $latestScanResult -systemCategorization $systemCategorization

    # Step 6: Throw error if severity level is medium or greater
    if ($severity -ge "Medium") {
        throw " Severity level '$severity' is medium or greater."
    } else {
        Write-Host "Severity level is less than Medium."
    }
}
