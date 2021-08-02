param name string
param location string = resourceGroup().location

@allowed([
  'Standard'
  'Premium V2'
  'Premium V3'
  'Dynamic'
])
param tier string

@allowed([
  'S1'
  'S2'
  'S3'
  'P1V2'
  'P2V2'
  'P3V2'
  'P1V3'
  'P2V3'
  'P3V3'
  'Y1'
])
param sku string

var uniqueName = '${name}-${location}-${uniqueString(resourceGroup().id)}'

resource AppServicePlan 'Microsoft.Web/serverfarms@2020-10-01' = {
  name: uniqueName
  location: location
  sku: {
    name: sku 
    tier: tier
  }
}

output Id string = AppServicePlan.id
