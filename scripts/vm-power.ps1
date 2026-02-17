<#
.SYNOPSIS
  VM power operations using User-Assigned Managed Identity (UAMI).
.DESCRIPTION
  Logs in via Azure IMDS using UAMI client-id (no secrets) and performs VM power actions through Azure ARM.
#>

param(
  [Parameter(Mandatory=$true)]
  [ValidateSet("status","start","stop","deallocate","restart")]
  [string]$Action,

  [Parameter(Mandatory=$true)]
  [string]$ResourceGroup,

  [Parameter(Mandatory=$true)]
  [string]$VmName,

  [Parameter(Mandatory=$true)]
  [string]$UamiClientId
)

$ErrorActionPreference = "Stop"

Write-Host "Logging in with UAMI client-id: $UamiClientId"
az login --identity --client-id $UamiClientId | Out-Null

Write-Host "Target: RG=$ResourceGroup VM=$VmName Action=$Action"

switch ($Action) {
  "status" {
    $state = az vm get-instance-view -g $ResourceGroup -n $VmName `
      --query "instanceView.statuses[?starts_with(code,'PowerState/')].displayStatus | [0]" -o tsv
    Write-Host "Power state: $state"
  }
  "start" {
    az vm start -g $ResourceGroup -n $VmName
  }
  "stop" {
    az vm stop -g $ResourceGroup -n $VmName
  }
  "deallocate" {
    az vm deallocate -g $ResourceGroup -n $VmName
  }
  "restart" {
    az vm restart -g $ResourceGroup -n $VmName
  }
}
