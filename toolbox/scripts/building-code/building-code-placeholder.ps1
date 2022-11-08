##################################################################################################################
# 
# PLACEHOLDER script for the building code package
#
##################################################################################################################

Write-Host ""
Write-Host "------------------------------------------------------------------------------------------------------"
Write-Host "Building code placeholder script"
Write-Host "------------------------------------------------------------------------------------------------------"
Write-Host ""

Write-Host "Running building code mode check"
if ($env:BUILDING_CODE_MODE -eq "VALIDATEONLY") 
{
    Write-Host "No build problems detected"
    Write-Host "##vso[task.complete result=Succeeded;]SUCCEEDED"
}
elseif ($env:BUILDING_CODE_MODE -eq "WARN") 
{
    Write-Host "Build problems detected but passing build"
    Write-Host "##vso[task.complete result=SucceededWithIssues;]SUCCEEDED WITH ISSUES"
}
elseif ($env:BUILDING_CODE_MODE -eq "FAIL") 
{
    Write-Host "Build problems detected, failing build"
    Write-Host "##vso[task.complete result=Failed;]FAILED"
}