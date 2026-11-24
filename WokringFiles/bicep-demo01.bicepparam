using './bicep-demo01.bicep'

param iacLocation = 'West Europe'
param Prefix = 'cw48'
param IpAddresses = [
  '192.168.100.1'
  '192.168.100.2'
  '192.168.100.3'
]
param Config = {
  kind: 'Blob'
  SKU: 'Premium_RAGRS'
}

