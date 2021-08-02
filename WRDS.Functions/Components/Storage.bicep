@minLength(3)
@maxLength(11)
param storagePrefix string

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageSKU string = 'Standard_LRS'
param location string = resourceGroup().location

var uniqueStorageName = '${toLower(storagePrefix)}${uniqueString(resourceGroup().id)}'

resource Storage 'Microsoft.Storage/storageAccounts@2019-04-01' = {
  name: uniqueStorageName
  location: location
  sku: {
    name: storageSKU
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

output storageEndpoint object = Storage.properties.primaryEndpoints
output storageConnectionString string = 'DefaultEndpointsProtocol=https;AccountName=${Storage.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(Storage.id, Storage.apiVersion).keys[0].value}'
