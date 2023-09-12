param location string = 'westeurope'
param env string = 'dev'
param name string = 'my-api'
param createProductionSlot bool = false

module names 'br/demoRegistry:naming-convention:v1' = {
  name: 'namingConvention-${name}'
  params: {
    env: env
    name: name
  }
}

module userIdentity 'br:bicepdemoevdbacr.azurecr.io/modules/bicep/user-managed-identity:v1' = {
  name: 'userIdentity-${name}'
  params: {
    location: location
    name: names.outputs.appName
  }
}

module rbac 'br:evdbregistry.azurecr.io/bicep/modules/rbac:v1' = {
  name: 'rbac-${name}'
  params: {
    env: env
    name: name
    permissions: [
      'configurationReader'
      'documentStorageContributor'
      'serviceBusSender'
    ]
    principalId: userIdentity.outputs.id
  }
}

var appServicePlan = {
  dev: {
    name: 'simple-asp'
    resourceGroup: 'Default-Web-WestEurope'
  }
  prod: {
    name: 'prod-asp'
    resourceGroup: 'Default-Web-WestEurope'
  }
}

module app 'br:bicepdemoevdbacr.azurecr.io/modules/bicep/app-service-dotnet-6:v1' = {
  name: 'app-${name}'
  params: {
    appServicePlan: appServicePlan[env]
    env: env
    name: names.outputs.appName
    location: location
    userIdentityId: userIdentity.outputs.id
    userIdentityClientId: userIdentity.outputs.clientId
    createProductionSlot: createProductionSlot
  }
}

module servicebusTopics 'topics.bicep' = {
  name: 'topics-${name}'
}
