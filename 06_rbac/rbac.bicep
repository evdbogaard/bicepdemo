param env string
param name string
param principalId string

metadata version = 'v1'

@allowed([
  'configurationReader'

  'documentStorageReader'
  'documentStorageContributor'

  'serviceBusReceiver'
  'serviceBusSender'
])
param permissions array

var definitions = loadJsonContent('roleDefinitions.json')

module configurationReader 'rbac-resource-group.bicep' = if (contains(permissions, 'configurationReader')) {
  name: 'rbac-${name}-configurationReader'
  params: {
    name: name
    principalId: principalId
    roleDefinitionId: definitions['App Configuration Data Reader']
  }
  scope: resourceGroup('BicepDemo')
}

var documentStorageRgs = ['BicepDemo-Documents-NL', 'BicepDemo-Documents-EU']
module documentStorageReader 'rbac-resource-group.bicep' = [for rg in documentStorageRgs: if (contains(permissions, 'documentStorageReader')) {
  name: 'rbac-${name}-dsr-${rg}'
  params: {
    name: name
    principalId: principalId
    roleDefinitionId: definitions['Storage Table Data Reader']
  }
  scope: resourceGroup(rg)
}]

module documentStorageContributor 'rbac-resource-group.bicep' = [for rg in documentStorageRgs: if (contains(permissions, 'documentStorageContributor')) {
  name: 'rbac-${name}-dsc-${rg}'
  params: {
    name: name
    principalId: principalId
    roleDefinitionId: definitions['Storage Table Data Contributor']
  }
  scope: resourceGroup(rg)
}]

module serviceBusReceiver 'rbac-servicebus.bicep' = if (contains(permissions, 'serviceBusReceiver')) {
  name: 'rbac-${name}-serviceBusReceiver'
  params: {
    name: name
    principalId: principalId
    roleDefinitionId: definitions['Azure Service Bus Data Receiver']
    env: env
  }
  scope: resourceGroup('BicepDemo')
}

module serviceBusSender 'rbac-servicebus.bicep' = if (contains(permissions, 'serviceBusSender')) {
  name: 'rbac-${name}-serviceBusSender'
  params: {
    name: name
    principalId: principalId
    roleDefinitionId: definitions['Azure Service Bus Data Sender']
    env: env
  }
  scope: resourceGroup('BicepDemo')
}
