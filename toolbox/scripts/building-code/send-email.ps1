<#
	.NAME
    Send-Mail.ps1

    .SYNOPSIS
	Powershell Script to Send Email using office 365 smtp settings
	
	.DESCRIPTION
    Supply the parameters and invoke the scripts. To,From,message are mandatory parameters and others are optional
	
	.USAGE EXAMPLE       
         C:\temp\Send-Mail.ps1 `
                -To 'TO' `
                -From 'SUBJECT' `
                -Subject 'FROM' `
                -body 'BODY' `

Calling Syntax #.\Send-Mail.ps1 -To "target@demo.com" -Subject "test subject" -From "source@demo.com" -Password "xxxxxx" -Body "Test body"              

#>

####### Set Parameters ######
Param(
     [Parameter(Mandatory=$false)]
     [string]
     $To,

     [Parameter(Mandatory=$false)]
     [string]
     $Subject,

     [Parameter(Mandatory = $false)]
     [string]
     $From,

     [Parameter(Mandatory = $false)]
     [String]
     $Password,

     [Parameter(Mandatory = $false)]
     [string]
     $Body
)

Write-Verbose "$((Get-Date).ToShortDateString()) : Started running $($MyInvocation.MyCommand)"

#----------------------
# Add common functions
#----------------------
. $PSScriptRoot\functions.ps1
#------------------------------------------------------------------

Write-Log -LineValue "Starting Script..."
### Script Global Settings
$creds = New-Object System.Management.Automation.PSCredential -ArgumentList $From, $($password | ConvertTo-SecureString -AsPlainText -Force)

#Declare SMTP Connection Settings
$smtpConnection = @{
    # Office365 SMTP Relay FQDN
    smtpServer = 'smtp.office365.com'
    port = 587 
    useSsl = $true
    credential = $creds
}

### Script Variables
#Declare Mailmessages.
$mailMessage = @{
    from = $From
    to = @(
        $To
    )
    cc = @(
        "CC@EMAIL.COM"
    )
    bcc = @(
        "BCC@EMAIL.COM"
    )
    subject = 'INFO-SonarQube Metrices'
    
    priority = 'High' #Normal by default, options: High, Low, Normal

    bodyAsHtml = $true    

    body = "Something Unexpected Occured as no Content has been Provided for this Mail Message!" #Default Message
}

### Script Start

#Set Mail Body and store it as HTML with Special CSS Class
$messageBody_HTLM = $Body

#Retrieve CSS Stylesheet
$css = Invoke-WebRequest "https://raw.githubusercontent.com/advancedrei/BootstrapForEmail/master/Stylesheet/bootstrap-email.min.css"  -UseBasicParsing | Select-Object -ExpandProperty Content

#Build HTML Mail Message and Apply it to the MailMessage HashTable
$mailMessage.body = ConvertTo-Html -Title $MailMessage.subject -Head "<style>$($CSS)</style>" $Body "
    <p>
        Worksafe BC Devops,    
    </p>

    <p>
        Attention - Please refer quality gate parametres related to code duplications for your project.</br>
        </br>
        <div class='alert alert-info' role='alert'>
            SonarQube Code Duplicate Report
        </div>
        $($messageBody_HTLM)
    </P>
" | Out-String


#Send MailMessage
#This example uses the HashTable's with a technique called Splatting to match/bind the Key's in the HashTable with the Parameters of the command.
#Use the @ Symbol instead of $ to invoke Splatting, Splatting improves readability and allows for better management and reuse of variables

try
{
    Send-MailMessage @smtpConnection @mailMessage
}
catch
{
    Write-Host "Send Email Failed"
    Write-Host "##vso[task.complete result=Failed;]FAILED"
    $errorMessage = $_.Exception.Message
    Write-Log -LineValue $_.Exception    
    return $errorMessage  
}