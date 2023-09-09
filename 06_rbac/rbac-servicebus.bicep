param name string
param roleDefinitionId string
param principalId string
param env string

resource servicebus 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' existing = {
  name: '${env}-erwin-servicebus'
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().name, name, roleDefinitionId, principalId)
  scope: servicebus
  properties: {
    principalId: principalId
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
  }
}
