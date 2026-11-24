using './SingleVM.bicep'

param Prefix = 'iac'
param VMName = 'VM'
param VMSize = 'Standard_D2alds_v7'
param location = 'France Central'

param AdminUserName = 'localadmin'
// Retrieve admin password from Azure Key Vault
// Syntax: getSecret('<subscriptionId>', '<resourceGroupName>', '<keyVaultName>', '<secretName>', '<secretVersion>')
param AdminPassword = getSecret('eec0968d-6c7a-40df-b5a5-a1ce6558617e', 'RG-IaC--Preparation', 'iac-keyvault-012', 'VMStdAdminPassword')
