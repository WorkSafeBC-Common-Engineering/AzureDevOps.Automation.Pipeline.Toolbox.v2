<#
	.SYNOPSIS
	Powershell Script to log telemetry to App Insights using REST API
	
	.DESCRIPTION
        Supply the parameters and invoke the scripts. OperationId, action and Event are mandatory parameters 
	
	.USAGE EXAMPLE       
         C:\temp\AI_script_version2.ps1 `
                -OperationId '__TODO_ACTION_INSERT_OPERATION_ID__' `
                -Action 'start' `
                -Event 'Bootstrap' `
                -BootstrapMode 'testmode' `
                -ApplicationType 'dotnet' `
                -ApplicationBlueprint 'generic' `
                -PortfolioName 'CLOUD.Samples' `
                -ProductName 'AzDOPSteps.Ops' `
                -SourcesDirectory 'd:\a\1\s' `
                -VerboseFlag 'true' `
                -ForceCheck 'true' `
                -Previews 'Previews text'               


#>
[CmdletBinding()]
param (
 [Parameter(Mandatory= $true)]
 [string]$OperationId,

 [Parameter(Mandatory= $true)]
 [string]$Action,

 [Parameter(Mandatory= $true)]
 [string]$Event,

 [Parameter(Mandatory= $false)]
 [string]$BootstrapMode,

 [Parameter(Mandatory= $false)]
 [string]$ApplicationType,

 [Parameter(Mandatory= $false)]
 [string]$ApplicationBlueprint,

 [Parameter(Mandatory= $false)]
 [string]$PortfolioName,

 [Parameter(Mandatory= $false)]
 [string]$ProductName,

 [Parameter(Mandatory= $false)]
 [string]$SourcesDirectory,

 [Parameter(Mandatory= $false)]
 [string]$VerboseFlag,

 [Parameter(Mandatory= $false)]
 [string]$ForceCheck,

 [Parameter(Mandatory= $false)]
 [string]$Previews,

 [Parameter(Mandatory= $false)]
 [string]$PollingTimeout,

 [Parameter(Mandatory= $false)]
 [string]$ApiKey,

 [Parameter(Mandatory= $false)]
 [string]$SonarQube,

 [Parameter(Mandatory= $false)]
 [string]$ConfigMode,

 [Parameter(Mandatory= $false)]
 [string]$ProjectKey,

 [Parameter(Mandatory= $false)]
 [string]$ProjectName,
 
 [Parameter(Mandatory= $false)]
 [string]$ScannerMode,

 [Parameter(Mandatory= $false)]
 [string]$CliSources,

 [Parameter(Mandatory= $false)]
 [string]$Mutants,

 [Parameter(Mandatory= $false)]
 [string]$Survivors,

 [Parameter(Mandatory= $false)]
 [string]$DuplicateCode
)

<#
    .SYNOPSIS
        Function to build custom properties for Bootstrap Event.

    .DESCRIPTION

         Event 			Action				Parameters
	Bootstrap	        Start                           BootstrapMode: <text>
                                                                ApplicationType: <text>
                                                                ApplicationBlueprint: <text>
                                                                PortfolioName: <text>
                                                                ProductName: <text>
                                                                SourcesDirectory: <text>
                                                                Verbose: <text>
                                                                ForceCheck: <text>
                                                                Previews: <text>

        Bootstrap               Exit               
#>

Function LogBootstrapEvent () 
{    
    switch ($Action)
    {
        'Start'
        {
            $properties = [PSCustomObject]@{
                Action               = $Action
                Mode                 = $BootstrapMode
                ApplicationType      = $ApplicationType
                ApplicationBlueprint = $ApplicationBlueprint
                PortfolioName        = $PortfolioName
                ProductName          = $ProductName
                SourcesDirectory     = $SourcesDirectory
                Verbose              = $VerboseFlag
                ForceCheck           = $ForceCheck
                Previews             = $Previews
            }
        }
        'Exit'
        {
            $properties = [PSCustomObject]@{
                Action = $Action
            }  
        }   
    }
    return $properties
}


<#
    .SYNOPSIS
	Function to build custom properties for Building Code Event.

    .DESCRIPTION

          Event 			Action				Parameters
	Building Code	                Stryker	                      Mutants: <text>
                                                                      Survivors: <text>
#>

Function LogBuildingCodeEvent
{
    switch ($Action)
    {
        'Stryker'
        {
            $properties = [PSCustomObject]@{
                Action    = $Action
                Mutants   = $Mutants
                Survivors = $Survivors 
            }
        }   
        'Duplicate Code'
        {
            $properties = [PSCustomObject]@{
                Action     = $Action
                Duplicates = $DuplicateCode
            }
        }
    }   
    return $properties            
}

<#
    .SYNOPSIS
	Function to build custom properties for DevSecOps Event.

    .DESCRIPTION

         Event 			Action				                        Parameters
	    DevSecOps	    SonarQube Prepare	                    SonarQube: <text>
                                                                ScannerMode: <text>
                                                                ProjectKey: <text>
                                                                ProjectName: <text>
                                                                -or-
                                                                SonarQube: <text>
                                                                ConfigMode: <text>
                                                                ScannerMode: <text>
                                                                ProjectKey: <text>
                                                                ProjectName: <text>
                                                                CliSources: <text>
        DevSecOps	    SonarQube Analyze	                    PollingTimeout: <text>
        DevSecOps	    SonarQube Publish	                    PollingTimeout: <text>
	    DevSecOps	    Whitesource Scan	                    ApiKey: <text>
#>

Function DevSecOpsEvent () 
{
    switch ($Action)
    {
        'SonarQube Prepare'
        {
            if(![string]::IsNullOrEmpty($CliSources) -or ![string]::IsNullOrEmpty($ConfigMode) )
            {
                $properties = [PSCustomObject]@{
                    Action      = $Action
                    SonarQube   = $SonarQube
                    ConfigMode  = $ConfigMode
                    ProjectKey  = $ProjectKey
                    ProjectName = $ProjectName
                    ScannerMode =  $ScannerMode
                    CliSources  = $CliSources
                }
            }
            else
            {
                $properties = [PSCustomObject]@{
                    Action      = $Action
                    SonarQube   = $SonarQube
                    ScannerMode = $ScannerMode
                    ProjectKey  = $ProjectKey
                    ProjectName = $ProjectName 
                }                    
            }
        }
    
        'SonarQube Analyze'
        {
            $properties = [PSCustomObject]@{
                Action = $Action
            }
        }

        'SonarQube Publish'
        {
            $properties = [PSCustomObject]@{
                Action         = $Action
                PollingTimeout = $PollingTimeout
            }
        }

        'Whitesource Scan'
        {
            $properties = [PSCustomObject]@{
                Action = $Action
                ApiKey = $ApiKey
            }
        }
    }
    return $properties      
}

######################################################################################################
# MAIN SCRIPT
######################################################################################################

##Instrumentation key
$InstrumentationKey = '__TODO_ACTION__INSERT_AI_INSTRUMENTATION_KEY__'

#Build the custom properties
$properties = switch ($Event)
{
    'Bootstrap' {LogBootstrapEvent}
    'DevSecOps' {DevSecOpsEvent}
    'Building Code' {LogBuildingCodeEvent}
}

#Build the request body
$bodyObject = [PSCustomObject]@{
    'name' = "Microsoft.ApplicationInsights.$InstrumentationKey.Event"
    'time' = ([System.dateTime]::UtcNow.ToString('o'))
    'iKey' = $InstrumentationKey
    'tags' = [PSCustomObject]@{
        'ai.operation.id' = $OperationId
    }
    'data' = [PSCustomObject]@{
        'baseType' = 'EventData'
        'baseData' = [PSCustomObject]@{
            'ver' = '2'
            'name' = $Event
            'properties' = $properties
        }
    }
}

$bodyAsCompressedJson = $bodyObject | ConvertTo-JSON -Depth 10 -Compress
$headers = @{'Content-Type' = 'application/x-json-stream';}

# Invoke rest api call to log telemetry to Application insights

# 2021.02.06 WS Add Retry count
$retryCount = 3
$retrySleep = 1.13
$retryCheck = $retryCount - 1

for ( $failureCount = 0; $failureCount -lt $retryCount; $failureCount++ )
{
    try
    {
        Invoke-WebRequest -Uri 'https://dc.services.visualstudio.com/v2/track' -Method 'POST' -headers $headers -body $bodyAsCompressedJson
        break;
    }
    catch
    {
        if ( $failureCount -eq $retryCheck )
        {
            $errorMessage = "Retry count exceeded: " + $_.Exception.Message
            Write-Host -BackgroundColor Red -ForegroundColor White $errorMessage
            break;
        }
        else 
        {
            $retrySleep = $retrySleep * ( $failureCount + 1 );
            $errorMessage = "Sleep and then retry. Count: " + $failureCount + " Sleep: " + $retrySleep +  " Error: " + $_.Exception.Message
            Write-Host -BackgroundColor Yellow -ForegroundColor Black $errorMessage
            Start-Sleep -Seconds $retrySleep
        }
    }
}