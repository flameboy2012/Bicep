param name string
param database string
param primaryServer string
param secondaryServer string

resource PrimaryServer 'Microsoft.Sql/servers@2021-02-01-preview' existing = {
  name: primaryServer
}

resource SecondaryServer 'Microsoft.Sql/servers@2021-02-01-preview' existing = {
  name: secondaryServer
}

resource FailoverGroup 'Microsoft.Sql/servers/failoverGroups@2021-02-01-preview' = {
  name: toLower(name)
  parent: PrimaryServer
  properties: {
    databases:[
      database
    ]
    partnerServers:[
      {
        id: SecondaryServer.id
      }
    ]
    readWriteEndpoint: {
      failoverPolicy: 'Automatic'
      failoverWithDataLossGracePeriodMinutes: 60
    }
  }
}

output Url string = '${FailoverGroup.name}${environment().suffixes.sqlServerHostname}'

