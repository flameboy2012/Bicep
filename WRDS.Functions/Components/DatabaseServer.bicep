param name string
param location string = resourceGroup().location

var uniqueName = '${name}-${location}-${uniqueString(resourceGroup().id)}'

resource DatabaseServer 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: uniqueName
  location: location
  properties: {
    administratorLogin: 'sqladmin'
    administratorLoginPassword: 'Qbttxpse2'
  }
}

output Id string = DatabaseServer.id
output Name string = DatabaseServer.name
