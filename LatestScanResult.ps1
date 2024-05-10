
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
        
        # Extract application names

        # $applicationNames = $applicationsData | ForEach-Object {
        #     [PSCustomObject]@{
        #         Id          = $_.id
        #         Name        = $_.name
        #         ProjectId   = $_.project.id
        #         ProjectName = $_.project.name
        #     }
        # }
        $LatestApplication = $applicationsData | ForEach-Object {
            [PSCustomObject]@{
                Id   = $_.id
                Name = $_.name
            }
        } | Where-Object { $_.name.contains($applicationName) } | Sort-Object -Property id -Descending | Select-Object -First 1
        #printing the name of latest version of the specified application
        Write-Host "Latest Application: $($LatestApplication.Name) Project ID: $($LatestApplication.id)"
        

        # Print the list of application names
        # Write-Host "List of applications:"
        # foreach ($name in $applicationNames) {
        #     Write-Host "Version ID: $($name.Id) Version Name: $($name.Name) Project ID: $($name.ProjectId) Project Name: $($name.ProjectName)"
        # }
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
