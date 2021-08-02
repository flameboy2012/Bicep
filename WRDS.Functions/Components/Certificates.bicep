param name string
param location string = resourceGroup().location
param customDomain string
param appService string

resource AppService  'Microsoft.Web/sites@2021-01-15' existing = {
  name: appService
}

resource Certificate 'Microsoft.Web/certificates@2021-01-15' = {
  name: name
  location: location
  properties: {
    hostNames:[
      customDomain
    ]
    serverFarmId: AppService.properties.serverFarmId

  }
}

resource HostNameBinding 'Microsoft.Web/sites/hostNameBindings@2021-01-15' = {
  name: name
  parent: AppService
  properties: {
    customHostNameDnsRecordType: 'CName'
    sslState: 'SniEnabled'
    thumbprint: Certificate.properties.thumbprint
  }
}
