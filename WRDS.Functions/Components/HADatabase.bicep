param name string
param primaryLocation string = resourceGroup().location
param secondaryLocation string

module PrimaryServer 'DatabaseServer.bicep' = {
  name: 'DatabaseServer-Deploy-${primaryLocation}'
  params: {
    name: name
    location: primaryLocation
  }
}

module SecondaryServer 'DatabaseServer.bicep' = {
  name: 'DatabaseServer-Deploy-${secondaryLocation}'
  params: {
    name: name
    location: secondaryLocation
  }
}

module Database 'Database.bicep' = {
  name: 'Database-Deploy'
  params: {
    name: name
    location: primaryLocation
    server: PrimaryServer.outputs.Name
  }
}

module FailoverGroup 'FailoverGroup.bicep' = {
  name: 'FailoverGroup-Deploy'
  params:{
    name: name
    database: Database.outputs.Id
    primaryServer:PrimaryServer.outputs.Name
    secondaryServer: SecondaryServer.outputs.Name
  }
}

output Url string = FailoverGroup.outputs.Url
