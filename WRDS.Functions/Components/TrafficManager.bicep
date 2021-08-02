param name string
param endpoints array
param monitorPath string = '/'

var uniqueName = '${name}-${uniqueString(resourceGroup().id)}'

resource TrafficManager 'Microsoft.Network/trafficmanagerprofiles@2018-08-01' = {
  name: uniqueName
  location: 'global'
  properties : {
    trafficRoutingMethod: 'Priority'
    dnsConfig: {
      relativeName: uniqueName
      ttl: 60
    }
    monitorConfig : {
      path : monitorPath
      port : 443
      protocol: 'HTTPS'
      expectedStatusCodeRanges: [
        {
          min:200
          max:200
        }
      ]
    }
    endpoints : [for endpoint in endpoints : {
      name: endpoint.name
      type: 'Microsoft.Network/trafficManagerProfiles/azureEndpoints'
      properties: {
        targetResourceId: endpoint.id
        priority: endpoint.priority
      }
    }]
  }
}

output id string = TrafficManager.id
