param name string = 'WRDSPortal'
param location string = resourceGroup().location
param secondaryLocation string = 'westeurope'

module AppInsight 'Components/AppInsights.bicep' = {
  name: 'AppInsight-Deploy'
  params: {
    name: name
  }
}

module AppServicePrimary 'Components/AppService.bicep' = {
  name: 'AppService-Deploy-${location}'
  params: {
    name: name
    AppInsightKey: AppInsight.outputs.key
  }
}

module AppServiceSecondary 'Components/AppService.bicep' = {
  name: 'AppService-Deploy-${secondaryLocation}'
  params: {
    name: name
    location: secondaryLocation
    AppInsightKey: AppInsight.outputs.key
  }
}

module TrafficManager 'Components/TrafficManager.bicep' = {
  name: 'TrafficManager-Deploy'
  params: {
    name: name
    endpoints: [
      {
        id : AppServicePrimary.outputs.Id
        name : AppServicePrimary.outputs.Name
        priority : 1
      }
      {
        id : AppServiceSecondary.outputs.Id
        name : AppServiceSecondary.outputs.Name
        priority : 2
      }
    ]
  }
}

output PrimaryAppService string = AppServicePrimary.outputs.Name
output SecondaryAppService string = AppServiceSecondary.outputs.Name
