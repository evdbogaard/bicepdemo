param name string = 'testidentity'
param env string = 'dev'
param location string = resourceGroup().location

var fullName = '${env}-${name}'

module identity 'br:evdbregistry.azurecr.io/bicep/modules/user-managed-identity:v1' = {
  name: 'identity-${name}'
  params: {
    location: location
    name: fullName
  }
}

module rbac 'br:evdbregistry.azurecr.io/bicep/modules/rbac:v1' = {
  name: 'rbac-${name}'
  params: {
    env: env
    name: fullName
    permissions: [
      'configurationReader'
      'documentStorageContributor'
      'serviceBusSender'
    ]
    principalId: identity.outputs.principalId
  }
}
