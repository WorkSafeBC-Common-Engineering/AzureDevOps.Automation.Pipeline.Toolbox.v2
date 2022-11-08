<#
	.NAME
    Get-CodeDuplicationMetrices.ps1

    .SYNOPSIS
	Powershell Script to get code duplication metrices from SonarQube Server using REST API
	
	.DESCRIPTION
    Supply the parameters and invoke the scripts. SonarQubeUserToken, projectkey and insrumentationKey are mandatory parameters and SonarQubeQualityGateURL is optional
	
	.USAGE EXAMPLE       
         C:\temp\Get-CodeDuplicationMetrices.ps1 `
                -SonarQubeUserToken 'USER_SONAR_QUBE_ACCESS_PAT' `
                -ProjectKey 'SONARQUBE_PROJECT_KEY' `
                -SonarQubeQualityGateURL 'SONAR_QUBE_SERVER_URL' 
#>
####### Set Parameters ######
Param(
    [Parameter(Mandatory = $true)]
    [string]
    $SonarQubeUserToken,

    [Parameter(Mandatory = $true)]
    [string]
    $ProjectKey,

    [Parameter(Mandatory = $false)]
    [string]
    $SonarQubeQualityGateUrl = '__TODO_ACTION__INSERT_SONARQUBE_URL__'
)

function Write-Log {
    <#	
        .Description  
        Writes a new line to the end of the specified log file
      
        .EXAMPLE
        Write-Log -LineValue "This is a new line which I am appending to the end of the log file."
  
        .EXAMPLE
        Write-Log -LineValue "This is a warning that i want to log." -loglevel 2
  
        .EXAMPLE
        Write-Log -LineValue "This is an error I want to log." -loglevel 3
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$LineValue,
  
        [Parameter( Mandatory = $false, HelpMessage = "Loglevel 1 = Informational, Loglevel 2 = Warning, Log Level 3 = Error")]
        [ValidateSet(1, 2, 3)]
        [int]$LogLevel = 1
    )
    $os = $env:OS
    if ($os -contains '*win*') { 
        $logPath = [system.io.path]::GetTempPath() + "\SonarQubeCodeMetrics-$(get-date -f MM-dd-yyyyTHH-mm-ss).log"
    }
    else {
        $logPath = [system.io.path]::GetTempPath() + "/SonarQubeCodeMetrics-$(get-date -f MM-dd-yyyyTHH-mm-ss).log"
    }   
   
    $parentLogPath = Split-Path $logPath -Parent
    if (!(Test-Path $parentlogpath)) {
        New-Item -ItemType directory -Path $parentlogpath
    } 
    
    try {
        if (!(Test-Path $logPath)) {
            ## Create the log file
            New-Item $logPath -Type File | Out-Null
            # Get the time to put into the log entry
            $timeGenerated = "$(Get-Date -Format HH:mm:ss).$((Get-Date).Millisecond)+000"
            # Build the standard line for CMTrace format
            $line = '<![LOG[{0}]LOG]!><time="{1}" date="{2}" component="{3}" context="" type="{4}" thread="" file="">'
            # Build the format for the line of data
            $lineFormat = $LineValue, $timeGenerated, (Get-Date -Format MM-dd-yyyy), "$($MyInvocation.ScriptName | Split-Path -Leaf):$($MyInvocation.ScriptLineNumber)", $LogLevel
            # Format the line
            $line = $line -f $lineFormat
            # Save the content to the log file
            Add-Content -Value $line -Path $logPath
        }
    }
    catch {
        $errorMessage = $_.Exception.Message
        Write-Host $errorMessage
    }
}
  
function Get-SonarQubeMetric {
    <#	
        .Description  
        Make an API Call to SonarQube API Server for given Metric
      
        .EXAMPLE
        Get-SonarQubeMetric 
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$SonarQubeQualityGateURL,
  
        [Parameter(Mandatory = $true)]
        [string]$MetricName,
  
        [Parameter(Mandatory = $true)]
        [string]$SonarQubeUserToken
    )
  
    $url = $SonarQubeQualityGateURL + "/measures/component?component=$projectKey&metricKeys=" + $MetricName
    $token = [System.Text.Encoding]::UTF8.GetBytes("$SonarQubeUserToken" + ":")
    $base64 = [System.Convert]::ToBase64String($token)
    $basicAuth = [string]::Format("Basic {0}", $base64)
    $headers = @{ Authorization = $basicAuth }
    $response = Invoke-RestMethod -Uri $url -Headers $headers   
    return $response
}
  
function CalculateCodemetrices() {
    # set error tracking counters
    $errorState = 0
    $errorMessage = $Null
    $response = $null
    $returnResponse = $null
    $htMetrices = @{}
    try {
        $codeMetrices = @("duplicated_lines_density", "duplicated_blocks", "duplicated_files", "duplicated_lines") 
        foreach ($codeMetric in $codeMetrices) {
            $response = Get-SonarQubeMetric -SonarQubeQualityGateURL $SonarQubeQualityGateUrl -metricname $codeMetric -SonarQubeUserToken $SonarQubeUserToken
            Write-Host $codeMetric = $response.component.measures -ForegroundColor Green
            $key = $response.component.measures.metric
            $value = $response.component.measures.value
            $htMetrices.Add($key, $value)
            $returnResponse += 'Number of ' + $key + '=' + $value + ';'
        }
        Write-Host "##vso[task.setvariable variable=SQDCVars.codeMetricesTaskVar;isOutput=true]$returnResponse"
        return $returnResponse
    }
    catch {
        Write-Host "Duplicate Code Metrics Failed"
        Write-Host "##vso[task.complete result=Failed;]FAILED"
        $errormessage = $_.Exception.Message
        $errorstate = 1
        Write-Log -LineValue $_.Exception
        $returnValue = @($errorstate, $errormessage)
        return $returnValue  
    }
}



    # Create a log file if a central log file has not been specified
    #------------------------------------------------------------------
    Write-Log -LineValue "Starting Script..."

    CalculateCodemetrices
