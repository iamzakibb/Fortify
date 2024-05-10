# Set up your Fortify SSC URL
$sscUrl = "https://fortify.frb.org"
$applicationName = "cia"
# Set up your Personal Access Token
$patToken = "MzU2NzhhY2MtNzNmNCOOMWRhLTgwZjAtMDY4MTQxMTUwYzhi"

# Endpoint for retrieving applications
$applicationsEndpoint = "$sscUrl/api/v1/projectVersions?start=0&limit=200&fulltextsearch=false&includeInactive=false&myAssignedIssues-false&onlyIfHasIssues-false"


Write-Output "Applications Endpoint: $applicationsEndpoint"

# Set up headers with the Personal Access Token
$headers = @{
    "Authorization" = "FortifyToken $patToken"
    "Accept"        = "application/json"
}

try {
    # Send request to retrieve applications
    $response = Invoke-RestMethod -Uri $applicationsEndpoint -Headers $headers -Method Get
    
    # Check if the request was successful
    if ($response) {
        $applicationsData = $response.data
        
        # Debugging: Output the response data
        Write-Host "Response Data:"
        $applicationsData | Format-Table
        
        # Extract latest application
        $LatestApplication = $applicationsData | ForEach-Object {
            [PSCustomObject]@{
                Id   = $_.id
                Name = $_.name
            }
        } | Where-Object { $_.name.contains($applicationName) } | Sort-Object -Property Id -Descending | Select-Object -First 1
        
        # Debugging: Output the latest application
        Write-Host "Latest Application:"
        $LatestApplication | Format-Table
        
        # Print the name of the latest version of the specified application
        if ($LatestApplication) {
            Write-Host "Version ID: $($LatestApplication.Id) Version Name: $($LatestApplication.Name)"
        }
        else {
            Write-Host "No application found with name '$applicationName'."
        }
    }
    else {
        Write-Host "Failed to retrieve applications. Status code: $($response.StatusCode)"
        Write-Host $response
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
        Write-Host "Response Body: $responseBody"
        Write-Host "Response Headers:"
        $_.Exception.Response.Headers | ForEach-Object {
            Write-Host "$($_.Key): $($_.Value)"
        }
    }
}