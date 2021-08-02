param name string
param location string = resourceGroup().location
param AppInsightKey string

var uniqueName = '${name}-${location}-${uniqueString(resourceGroup().id)}'

module AppServicePlan 'AppServicePlan.bicep' =  {
  name: 'AppServicePlan-Deploy-${location}'
  params: {
    name: name
    location : location
    tier: 'Standard'
    sku: 'S1'
  }
}

resource AppService 'Microsoft.Web/sites@2021-01-15' = {
  name:uniqueName
  location: location
  properties:{
    httpsOnly: true
    serverFarmId: AppServicePlan.outputs.Id
    clientAffinityEnabled: true
    siteConfig: {
      appSettings: [
        {
          'name': 'APPINSIGHTS_INSTRUMENTATIONKEY'
          'value': AppInsightKey
        }
      ]
      minTlsVersion: '1.2'
      scmMinTlsVersion: '1.2'
    }
  }
}

output Name string = AppService.name
output Id string = AppService.id
