param resourceId string
param name string
param dnsZone string
param VerificationID string

resource DNSZone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: dnsZone
}

resource CName 'Microsoft.Network/dnsZones/CNAME@2018-05-01' = {
  parent: DNSZone
  name: name
  properties: {
    TTL: 3600
    targetResource: {
      id: resourceId
    }
  }
}

resource Txt 'Microsoft.Network/dnsZones/TXT@2018-05-01' = {
  parent: DNSZone
  name: 'asuid.${name}'
  properties: {
    TTL:3600
    TXTRecords:[
      {
        value: [
          VerificationID
        ]
      }
    ]
  }
}

output FQDN string = CName.properties.fqdn
