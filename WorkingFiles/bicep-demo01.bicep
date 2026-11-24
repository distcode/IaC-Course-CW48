
targetScope = 'resourceGroup'

@allowed(['North Europe','West Europe','Austria East','Germany West Central'])
param iacLocation string = 'Austria East'

param iacLocationInherited string = resourceGroup().location

@minLength(2)
@maxLength(4)
@description('Specify a prefix for all resource names.')
param Prefix string = 'iac'

param IpAddresses array

param Config object = {
  kind: 'StandardV2'
  SKU: 'Standard_LRS'
}

@description('VM Name with Prefix')
var VMName string = '${Prefix}-VM-DC1'
var VMSize string = 'Standard_B4s_v2'

output Location string = iacLocation
output VMName string = VMName
output VMSize string = VMSize

output Prefix string = Prefix
output IpAddresses array = IpAddresses
output ConifgKind string = Config.Kind
output ConfigSKU string = Config.SKU
output Config object = Config
