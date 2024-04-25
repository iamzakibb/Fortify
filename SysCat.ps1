# Define system categorizations as an array of custom objects
$SystemCategorizations = @(
    [PSCustomObject]@{
        ProjectName = 'Boundary'
        RiskLevel = 'Low'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'Risk Calc. Capability'
        BuildArtifactRepo = 'Risks greater than the noted tolerance are actiorable'
    },
    [PSCustomObject]@{
        ProjectName = 'Atlanta Fed Website'
        RiskLevel = 'Low'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'SAST'
        BuildArtifactRepo = 'AZDO, Repo, Files, (Project Name)'
    },
    [PSCustomObject]@{
        ProjectName = 'ReviewPoint'
        RiskLevel = 'Low'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'N/A'
        BuildArtifactRepo = 'N/A'
    },
    [PSCustomObject]@{
        ProjectName = 'FedDASH ATL-Cloud'
        RiskLevel = 'Low'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'N/A'
        BuildArtifactRepo = 'N/A'
    },
    [PSCustomObject]@{
        ProjectName = "Director\'s Visualization"
        RiskLevel = 'Low'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'N/A'
        BuildArtifactRepo = 'N/A'
    },
    [PSCustomObject]@{
        ProjectName = 'PA Shared Media Server'
        RiskLevel = 'Low'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'N/A'
        BuildArtifactRepo = 'N/A'
    },
    [PSCustomObject]@{
        ProjectName = 'InfoBank'
        RiskLevel = 'Low'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'SAST'
        BuildArtifactRepo = 'AZDO, Repo, Files, (Project Name)'
    },
    [PSCustomObject]@{
        ProjectName = 'SCEA-Cloud'
        RiskLevel = 'Low'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'SAST'
        BuildArtifactRepo = 'AZDO, Repo, Files. (Project Name)'
    },
    [PSCustomObject]@{
        ProjectName = 'Structure Galleria'
        RiskLevel = 'Low'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'SAST'
        BuildArtifactRepo = 'AZDO, Repo, Files. (Project Name)'
    },
    [PSCustomObject]@{
        ProjectName = 'BMS'
        RiskLevel = 'Low'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'N/A'
        BuildArtifactRepo = 'N/A'
    },
    [PSCustomObject]@{
        ProjectName = 'Stentofon'
        RiskLevel = 'Low 1'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'N/A'
        BuildArtifactRepo = 'N/A'
    },
    [PSCustomObject]@{
        ProjectName = 'Research Infrastructure'
        RiskLevel = 'Low 1'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'N/A'
        BuildArtifactRepo = 'N/A'
    },
    [PSCustomObject]@{
        ProjectName = 'MS Dynamics CRM'
        RiskLevel = 'Low'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'N/A'
        BuildArtifactRepo = 'N/A'
    },
    [PSCustomObject]@{
        ProjectName = "Investing in America\'s Workforce"
        RiskLevel = 'Low'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'SAST'
        BuildArtifactRepo = 'Sitecore (3rd Party Libs)'
    },
    [PSCustomObject]@{
        ProjectName = 'Financial Crimes Prevention Solution'
        RiskLevel = 'Moderate'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'N/A'
        BuildArtifactRepo = 'N/A'
    },
    [PSCustomObject]@{
        ProjectName = 'Contingency Info Anywhere (CIA)'
        RiskLevel = 'Moderate'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'SAST'
        BuildArtifactRepo = 'AZDO, Repo, Files, (Project Name)'
    },
    [PSCustomObject]@{
        ProjectName = 'Driving Policy-Cloud'
        RiskLevel = 'Moderate'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'SAST'
        BuildArtifactRepo = 'AZDO, Repo Files, (Project Name)'
    },
    [PSCustomObject]@{
        ProjectName = 'FRS Alert'
        RiskLevel = 'Moderate'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'SAST'
        BuildArtifactRepo = 'AZDO, Repo, Files, (Project Name)'
    },
    [PSCustomObject]@{
        ProjectName = 'LEU Fingerprint System'
        RiskLevel = 'Moderate 2'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'N/A'
        BuildArtifactRepo = 'N/A'
    },
    [PSCustomObject]@{
        ProjectName = 'Research Compute Cluster'
        RiskLevel = 'Moderate'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'N/A'
        BuildArtifactRepo = 'N/A'
    },
    [PSCustomObject]@{
        ProjectName = 'Research Workstation'
        RiskLevel = 'Moderate'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'N/A'
        BuildArtifactRepo = 'N/A'
    },
    [PSCustomObject]@{
        ProjectName = 'S&R MARS-Cloud'
        RiskLevel = 'Moderate'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'N/A'
        BuildArtifactRepo = 'N/A'
    },
    [PSCustomObject]@{
        ProjectName = 'MS CRM'
        RiskLevel = 'Moderate'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'N/A'
        BuildArtifactRepo = 'N/A'
    },
    [PSCustomObject]@{
        ProjectName = 'SBR Workstation'
        RiskLevel = 'Moderate 2'
        RiskTolerance = 'Moderate/Medium'
        Categorization = 'N/A'
        BuildArtifactRepo = 'N/A'
    }
)

# Accessing data from the array of custom objects
$ProjectInfo = $SystemCategorizations | Where-Object { $_.ProjectName -eq 'Boundary' }
Write-Host "Risk Level for $($ProjectInfo.ProjectName) project: $($ProjectInfo.RiskLevel)"
Write-Host "Risk Tolerance for $($ProjectInfo.ProjectName) project: $($ProjectInfo.RiskTolerance)"
Write-Host "Categorization for $($ProjectInfo.ProjectName) project: $($ProjectInfo.Categorization)"
Write-Host "Build Artifact Repository for $($ProjectInfo.ProjectName) project: $($ProjectInfo.BuildArtifactRepo)"
