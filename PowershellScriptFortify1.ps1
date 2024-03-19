# Set up your Fortify SSC URL
$sscUrl = ""

# Set up your Personal Access Token
$patToken = ""

# Endpoint for retrieving applications
$applicationsEndpoint = "$sscUrl/api/v1/applications"

# Set up headers with the Personal Access Token
$headers = @{
    "Authorization" = "CIToken $patToken"
    "Accept" = "application/json"
}

try {
    # Send request to retrieve applications
    $response = Invoke-RestMethod -Uri $applicationsEndpoint -Headers $headers -Method Get
    
    # Check if the request was successful
    if ($response) {
        $applicationsData = $response
        
        # Extract application names
        $applicationNames = $applicationsData | ForEach-Object { $_.applicationName }
        
        # Print the list of application names
        Write-Host "List of applications:"
        foreach ($name in $applicationNames) {
            Write-Host $name
        }
    } else {
        Write-Host "Failed to retrieve applications. Status code: $($response.StatusCode)"
    }
} catch {
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
