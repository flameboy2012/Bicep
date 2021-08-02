param name string
param location string = resourceGroup().location
param server string


resource DBServer 'Microsoft.Sql/servers@2021-02-01-preview' existing = {
  name: server
}


resource Database 'Microsoft.Sql/servers/databases@2021-02-01-preview'= {
  name: name
  parent: DBServer
  location: location
  sku: {
    name: 'S1'
    tier: 'standard'
  }
}

output Name string = Database.name
output Id string = Database.id
