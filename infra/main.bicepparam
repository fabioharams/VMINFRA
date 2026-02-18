using './main.bicep'

param location = 'brazilsouth'
param resourceGroupName = 'rg-vminfra'
param vmCount = 3
param vmSize = 'Standard_D2as_v7'
param vmNamePrefix = 'vm'
param adminUsername = readEnvironmentVariable('AZURE_VM_ADMIN_USERNAME', '')
param adminPassword = readEnvironmentVariable('AZURE_VM_ADMIN_PASSWORD', '')
