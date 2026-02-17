param(
  [Parameter(Mandatory=$true)][string]$SubscriptionId,
  [Parameter(Mandatory=$true)][string]$ResourceGroup,
  [Parameter(Mandatory=$true)][string]$VmName,
  [Parameter(Mandatory=$true)][string]$UamiClientId,
  [string]$ApiVersion = "2023-09-01"
)

$ErrorActionPreference = "Stop"

# 1) Get ARM token from IMDS for the specified UAMI
$tokenUri = "http://169.254.169.254/metadata/identity/oauth2/token" +
            "?api-version=2018-02-01" +
            "&resource=$([System.Uri]::EscapeDataString('https://management.azure.com/'))" +
            "&client_id=$UamiClientId"

$token = Invoke-RestMethod -Headers @{Metadata="true"} -Method GET -Uri $tokenUri

$headers = @{
  Authorization = "Bearer $($token.access_token)"
  "Content-Type" = "application/json"
}

# 2) Call ARM restart action
$restartUri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroup" +
              "/providers/Microsoft.Compute/virtualMachines/$VmName/restart?api-version=$ApiVersion"

Invoke-RestMethod -Method POST -Uri $restartUri -Headers $headers
Write-Host "Restart request submitted to ARM."
