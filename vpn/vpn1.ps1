#
#
[CmdletBinding()]
param (
    [Parameter( Mandatory = $false, ValueFromPipeline=$false, HelpMessage='username administrator VMs')]
    [string]$adminUsername ,
 
    [Parameter(Mandatory = $false, HelpMessage='password administrator VMs')]
    [string]$adminPassword 
    )

################# Input parameters #################
$subscriptionName  = "AzDev"     
$location          = "eastus"
$rgName            = "vpn1"
$deploymentName    = "vpn1"
$armTemplateFile   = "vpn1.json"
####################################################

$pathFiles      = Split-Path -Parent $PSCommandPath
$templateFile   = "$pathFiles\$armTemplateFile"


$parameters=@{
              "adminUsername"= $adminUsername;
              "adminPassword"= $adminPassword
              }

$subscr=Get-AzSubscription -SubscriptionName $subscriptionName
Select-AzSubscription -SubscriptionId $subscr.Id

# Create Resource Group step3
Write-Host (Get-Date)' - ' -NoNewline
Write-Host "Creating Resource Group $rgName " -ForegroundColor Cyan
Try {$rg = Get-AzResourceGroup -Name $rgName  -ErrorAction Stop
     Write-Host '  resource exists, skipping'}
Catch {$rg = New-AzResourceGroup -Name $rgName  -Location $location  }

$runTime=Measure-Command {

write-host "running ARM template:"$templateFile
New-AzResourceGroupDeployment  -Name $deploymentName -ResourceGroupName $rgName -TemplateFile $templateFile -TemplateParameterObject $parameters -Verbose 
}

write-host -ForegroundColor Yellow "runtime: "$runTime.ToString()