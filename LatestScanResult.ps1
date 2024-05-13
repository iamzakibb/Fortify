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
        
        # $LatestApplication = $applicationsData | ForEach-Object {
        #     [PSCustomObject]@{
        #         Id   = $_.id
        #         Name = $_.name
        #     }
        # } | Where-Object { 
        #     $_.Name -like "*$applicationName*" -or $_.project.name -like "*$applicationName*"
        # } | Sort-Object -Property Id -Descending | Select-Object -First 1
        
        # $LatestApplication = $applicationsData | Where-Object { $_.name.contains($applicationName) }
        # $LatestApplication = $application | Where-Object { $_.project.name -like "*$applicationName*" -or $_.project -like "*$applicationName*" } | Sort-Object -Property Id -Descending | Select-Object -First 1
        # ----------
        $LatestApplication = $applicationsData |  Where-Object { $_.project.name -like "*$applicationName*" -or $_.project -like "*$applicationName*" } | Sort-Object -Property Id -Descending | Select-Object -First 1


        # Print the name of the latest version of the specified application
        if ($LatestApplication) {
            Write-Host "Application id, version and project name: $($LatestApplication.id) $($LatestApplication.name) $($LatestApplication.project.name)"
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
