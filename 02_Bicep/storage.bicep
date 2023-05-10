param env string
param location string
param keyvaultName string

var isProd = env == 'prod'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'bicepdemoevdbst'
  location: location
  kind: 'StorageV2'
  sku: {
    name: isProd ? 'Standard_RAGZRS' : 'Standard_LRS'
  }
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    accessTier: 'Hot'
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyvaultName

  resource secret 'secrets' = {
    name: 'StorageConnString'
    properties: {
      value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}' 
    }
  }
}
