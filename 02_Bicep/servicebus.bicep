param env string 
param location string
param topicNames array
param keyvaultName string

var isProd = env == 'prod'

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: 'bicepdemoevdbservicebus'
  location: location
  sku: {
    name: 'Premium'
    capacity: 1
    tier: 'Premium'
  }
  properties: {
    minimumTlsVersion: '1.2'
  }

  resource topic 'topics' = [for name in topicNames: {
    name: name
    properties: {
      enablePartitioning: isProd
    }
  }]
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyvaultName

  resource secret 'secrets' = {
    name: 'ServiceBusConnString'
    properties: {
      value: listKeys('${serviceBusNamespace.id}/AuthorizationRules/RootManageSharedAccessKey', serviceBusNamespace.apiVersion).primaryConnectionString 
    }
  }
}
