param name string
param location string = resourceGroup().location
param AppInsightKey string
param StorageConinectionString string

var uniqueName = '${name}-${location}-${uniqueString(resourceGroup().id)}'

module AppServicePlan 'AppServicePlan.bicep' =  {
  name: 'AppServicePlan-Deploy-${location}'
  params: {
    name: name
    location : location
    sku: 'Y1'
    tier: 'Dynamic'
  }
}

resource functionApp 'Microsoft.Web/sites@2020-06-01' = {
  name: uniqueName
  location: location
  kind: 'functionapp'
  properties: {
    httpsOnly: true
    serverFarmId: AppServicePlan.outputs.Id
    clientAffinityEnabled: true
    siteConfig: {
      appSettings: [
        {
          'name': 'APPINSIGHTS_INSTRUMENTATIONKEY'
          'value': AppInsightKey
        }
        {
          name: 'AzureWebJobsStorage'
          value: StorageConinectionString
        }
        {
          'name': 'FUNCTIONS_EXTENSION_VERSION'
          'value': '~3'
        }
        {
          'name': 'FUNCTIONS_WORKER_RUNTIME'
          'value': 'dotnet'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: StorageConinectionString
        }
        // WEBSITE_CONTENTSHARE will also be auto-generated - https://docs.microsoft.com/en-us/azure/azure-functions/functions-app-settings#website_contentshare
        // WEBSITE_RUN_FROM_PACKAGE will be set to 1 by func azure functionapp publish
      ]
      minTlsVersion: '1.2'
      scmMinTlsVersion: '1.2'
    }
  }
}

output Name string = functionApp.name
output Id string = functionApp.id
output VerficationId string = functionApp.properties.customDomainVerificationId
output ServerId string = functionApp.properties.serverFarmId
