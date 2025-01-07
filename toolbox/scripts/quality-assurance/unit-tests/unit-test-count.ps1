<#
    .DESCRIPTION
        Script to get the test count for a build pipeline and store it in a variable
        ref: https://learn.microsoft.com/en-us/rest/api/azure/devops/testresults/resultdetailsbybuild/get?view=azure-devops-rest-7.2
    .PARAMETER PAT
        Personal Access Token (PAT) for the Azure DevOps account
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$PAT
)

$project = $env:SYSTEM_TEAMPROJECT
$buildId = $env:BUILD_BUILDID
$organization = "__TODO_INSERT_AZDO_ORG_NAME__"
$apiVersion = "7.2-preview.1"

Write-Host "Project: $project BuildId: $buildId Token Length: $($PAT.Length)"

try {

    $BasicAuthEncode = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($PAT)"))
    $AuthHeader = @{ "Authorization" = "Basic $BasicAuthEncode" }
    $buildPipelineTestResultsUrl = "https://vstmr.dev.azure.com/$organization/$project/_apis/testresults/resultsbybuild?buildId=$buildId&api-version=$apiVersion"
    Write-Host $buildPipelineTestResultsUrl
    $buildPipelineTestResults = Invoke-RestMethod -Uri $buildPipelineTestResultsUrl `
                                    -Headers $AuthHeader `
                                    -Method 'Get'  `
                                    -ContentType 'application/json'

    $buildPipelineTestCount = $buildPipelineTestResults.count
    Write-Host "##vso[task.setvariable variable=unitTestCount;isOutput=true]$buildPipelineTestCount"
    Write-Host "Total Tests: $($buildPipelineTestResults.count)"
}
catch {
    $apiCallError = -1
    Write-Host "##vso[task.complete result=SucceededWithIssues;]Task completed with issues"
    Write-Host "##vso[task.setvariable variable=unitTestCount;isOutput=true]$apiCallError"
    Write-Host "Error: $($_.Exception.Message)"
}