param name string = 'WRDSService'
param location string = resourceGroup().location

module HADB 'Components/HADatabase.bicep' = {
  name: 'HADB-Deploy'
  params: {
    name: name
    primaryLocation: location
    secondaryLocation: 'westeurope'
  }
}

output DatabaseUrl string = HADB.outputs.Url
