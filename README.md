![GitHub last commit](https://img.shields.io/github/last-commit/donaldcarol/azure-authentication-patterns)
![GitHub repo size](https://img.shields.io/github/repo-size/donaldcarol/azure-authentication-patterns)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Azure](https://img.shields.io/badge/Azure-Identity-blue)
![Security](https://img.shields.io/badge/Security-OIDC%20Enabled-brightgreen)
![IaC Ready](https://img.shields.io/badge/IaC-Ready-informational)

# Azure VM Ops via User-Assigned Managed Identity (UAMI)



This repo demonstrates **passwordless** VM operations in Azure using a **User-Assigned Managed Identity** from a controller VM.

No client secrets, no certificates.



## Scenario

- Controller VM (runs scripts): e.g. `VM-Eah-test`

- Target VM (managed): e.g. `vm-winsec01`

- Auth: **User-Assigned Managed Identity** (UAMI)

- Control plane: **Azure Resource Manager (ARM)** via HTTPS 443


## Key features

- Passwordless authentication using Azure **IMDS** (169.254.169.254) + Entra ID token issuance

- RBAC-based authorization (least privilege recommended)

- Two approaches:

1) Azure CLI (`az login --identity --client-id ...`)

2) Direct REST calls to ARM (no Azure CLI)



## Prerequisites

- UAMI created and attached to the controller VM

- RBAC role assignment for the UAMI on the target scope (VM or Resource Group)

- Azure CLI installed (for `vm-power.ps1`), optional for REST version



## Usage



### Power operations (Azure CLI)

```powershell

.\\scripts\\vm-power.ps1 -Action status -ResourceGroup RG-Lab -VmName vm-winsec01 -UamiClientId <UAMI\_CLIENT\_ID>

.\\scripts\\vm-power.ps1 -Action restart -ResourceGroup RG-Lab -VmName vm-winsec01 -UamiClientId <UAMI\_CLIENT\_ID>



