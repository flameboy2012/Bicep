param name string = 'WRDSFunc'
param location string = resourceGroup().location
param secondaryLocation string = 'westeurope'

module Storage 'Components/Storage.bicep' = {
  name: 'Storage-Deploy'
  params: {
    storagePrefix: name
    storageSKU: 'Standard_RAGRS'
  }
}

module AppInsights 'Components/AppInsights.bicep' = {
  name: 'AppInsight-Deploy'
  params: {
    name: name 
  }
}

module FunctionPrimary 'Components/Function.bicep' = {
  name: 'Function-Deploy-${location}'
  params: {
    name: name
    AppInsightKey: AppInsights.outputs.key
    StorageConinectionString: Storage.outputs.storageConnectionString
  }
}

module FunctionSecondary 'Components/Function.bicep' = {
  name: 'Function-Deploy-${secondaryLocation}'
  params: {
    location: secondaryLocation
    name: name
    AppInsightKey: AppInsights.outputs.key
    StorageConinectionString: Storage.outputs.storageConnectionString
  }
}

module TrafficManager 'Components/TrafficManager.bicep' = {
  name: 'TrafficManager-Deploy'
  params: {
    name: name
    endpoints: [
      {
        id : FunctionPrimary.outputs.Id
        name : FunctionPrimary.outputs.Name
        priority : 1
      }
      {
        id : FunctionSecondary.outputs.Id
        name : FunctionSecondary.outputs.Name
        priority : 2
      }
    ]
  }
}

module DNS 'Components/DNS.bicep' = {
  name: 'DNS-Deploy'
  scope: resourceGroup('DNS')
  params: {
    dnsZone: 'Sc0tti.net'
    name: 'WRDSFunc'
    resourceId: TrafficManager.outputs.id
    VerificationID: FunctionPrimary.outputs.VerficationId
  }
}

module PrimaryCert 'Components/Certificates.bicep' = {
  name: 'Cert-Deploy-${location}'
  params:{
    name: name
    customDomain: DNS.outputs.FQDN
    appService: FunctionPrimary.outputs.Name
  }
}

module SecondaryCert 'Components/Certificates.bicep' = {
  name: 'Cert-Deploy-${secondaryLocation}'
  params:{
    name: name
    location: secondaryLocation
    customDomain: DNS.outputs.FQDN
    appService: FunctionSecondary.outputs.Name
  }
}

output PrimaryFunctionName string = FunctionPrimary.outputs.Name
output SecondaryFunctionName string = FunctionSecondary.outputs.Name
output StorageConnectionString string = Storage.outputs.storageConnectionString
