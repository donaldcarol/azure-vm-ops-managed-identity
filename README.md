\# Azure VM Ops via User-Assigned Managed Identity (UAMI)



This repo demonstrates \*\*passwordless\*\* VM operations in Azure using a \*\*User-Assigned Managed Identity\*\* from a controller VM.

No client secrets, no certificates.



\## Scenario

\- Controller VM (runs scripts): e.g. `VM-Eah-test`

\- Target VM (managed): e.g. `vm-winsec01`

\- Auth: \*\*User-Assigned Managed Identity\*\* (UAMI)

\- Control plane: \*\*Azure Resource Manager (ARM)\*\* via HTTPS 443



\## Key features

\- Passwordless authentication using Azure \*\*IMDS\*\* (169.254.169.254) + Entra ID token issuance

\- RBAC-based authorization (least privilege recommended)

\- Two approaches:

&nbsp; 1) Azure CLI (`az login --identity --client-id ...`)

&nbsp; 2) Direct REST calls to ARM (no Azure CLI)



\## Prerequisites

\- UAMI created and attached to the controller VM

\- RBAC role assignment for the UAMI on the target scope (VM or Resource Group)

\- Azure CLI installed (for `vm-power.ps1`), optional for REST version



\## Usage



\### Power operations (Azure CLI)

```powershell

.\\scripts\\vm-power.ps1 -Action status -ResourceGroup RG-Lab -VmName vm-winsec01 -UamiClientId <UAMI\_CLIENT\_ID>

.\\scripts\\vm-power.ps1 -Action restart -ResourceGroup RG-Lab -VmName vm-winsec01 -UamiClientId <UAMI\_CLIENT\_ID>



