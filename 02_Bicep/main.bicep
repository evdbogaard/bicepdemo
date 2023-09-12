param env string
param location string = resourceGroup().location
param principalId string
param topicNames array

metadata version = 'v1'

module keyVault 'keyvault.bicep' = {
  name: 'deployKeyVault'
  params: {
    location: location
    prinicpalId: principalId
  }
}

module serviceBus 'servicebus.bicep' = {
  name: 'deployServiceBus'
  params: {
    env: env
    keyvaultName: keyVault.outputs.keyvaultName
    location: location
    topicNames: topicNames
  }
}

module storageAccount 'br:bicepdemoevdbacr.azurecr.io/modules/bicep/storage:v1' = {
{
  name: 'deployStorage'
  params: {
    env: env
    keyvaultName: keyVault.outputs.keyvaultName
    location: location
  }
}
