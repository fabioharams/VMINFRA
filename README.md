# VM Infrastructure - Azure Developer CLI Template

This `azd` template deploys **4 Windows Server virtual machines** across two Azure regions with private networking and global VNet peering.

## Architecture

### Brazil South
- **3x Virtual Machines** (`vm-1`, `vm-2`, `vm-3`) — `Standard_D2as_v7`, Windows Server 2022 Datacenter Gen2
- **1x Virtual Network** `vnet-vminfra` — `10.0.0.0/16`
- **3x Subnets** — `snet-1` (`10.0.1.0/24`), `snet-2` (`10.0.2.0/24`), `snet-3` (`10.0.3.0/24`) — one VM per subnet
- **Network Security Group** — attached to all subnets

### Sweden Central
- **1x Virtual Machine** (`vm-swedencentral`) — `Standard_D2as_v7`, Windows Server 2025 Datacenter Gen2
- **1x Virtual Network** `vnet-swedencentral` — `10.1.0.0/16`
- **1x Subnet** — `snet-swedencentral` (`10.1.0.0/24`)
- **Network Security Group** — attached to the subnet

### Cross-Region Connectivity
- **Global VNet Peering** — bidirectional peering between `vnet-vminfra` and `vnet-swedencentral`
- **No public IP addresses** — all VMs are only accessible via private IPs

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
