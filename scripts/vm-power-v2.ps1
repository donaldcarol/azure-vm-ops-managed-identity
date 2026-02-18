<#
.SYNOPSIS
  VM power operations using Managed Identity (auto-detect).
.DESCRIPTION
  Logs in via Azure Managed Identity (IMDS) without specifying client-id and performs VM power actions via Azure CLI.
  Notes:
    - If System-Assigned MI exists, it's typically used by default.
    - If only one User-Assigned MI exists (and no ambiguity), it may be used by default.
    - If multiple UAMIs are attached, login can fail unless identity is specified explicitly.
#>

param(
  [Parameter(Mandatory=$true)]
  [ValidateSet("status","start","stop","deallocate","restart")]
  [string]$Action,

  [Parameter(Mandatory=$true)]
  [string]$ResourceGroup,

  [Parameter(Mandatory=$true)]
  [string]$VmName
)

$ErrorActionPreference = "Stop"

Write-Host "Logging in with Managed Identity (auto-detect)..."
az login --identity | Out-Null

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
