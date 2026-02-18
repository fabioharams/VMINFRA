# VM Infrastructure - Azure Developer CLI Template

This `azd` template deploys **3 Windows Server 2022 Datacenter (Gen2)** virtual machines on Azure.

## Architecture

- **3x Virtual Machines** — `Standard_D2as_v7` in Brazil South
- **1x Virtual Network** — `10.0.0.0/16` with a default subnet `10.0.0.0/24`
- **Network Security Group** — attached to the subnet
- **No public IP addresses** — VMs are only accessible via private IPs

## Prerequisites

- [Azure Developer CLI (azd)](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd)
- An Azure subscription

## Getting Started

1. **Set environment variables** for the VM admin credentials:

   ```bash
   azd env set AZURE_VM_ADMIN_USERNAME <your-username>
   azd env set AZURE_VM_ADMIN_PASSWORD <your-secure-password>
   ```

2. **Provision the infrastructure**:

   ```bash
   azd up
   ```

3. **Clean up** when done:

   ```bash
   azd down
   ```

## Configuration

| Parameter           | Default              | Description                        |
|---------------------|----------------------|------------------------------------|
| `location`          | `brazilsouth`        | Azure region                       |
| `resourceGroupName` | `rg-vminfra`         | Resource group name                |
| `vmCount`           | `3`                  | Number of VMs to deploy            |
| `vmSize`            | `Standard_D2as_v7`   | VM instance size                   |
| `vmNamePrefix`      | `vm`                 | Prefix for VM names (vm-1, vm-2…)  |
