param location string = 'westeurope'
param updateTag string = utcNow('u')

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: 'bicepdemoevdbwebapp'
  location: location
  sku: {
    name: 'F1'
    capacity: 1
  }
}

resource webApplication 'Microsoft.Web/sites@2021-01-15' = {
  name: 'bicepdemoevdbwebapp'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: 'deploymentScriptIdentity'
}

resource deploymentScriptPS 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'bicepdemoevdbDeploymentScriptPS'
  location: location
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '8.3'
    retentionInterval: 'P1D'
    forceUpdateTag: updateTag
    scriptContent: loadTextContent('script.ps1')
    environmentVariables: [
      {
        name: 'principalId'
        value: webApplication.identity.principalId
      }
      {
        name: 'groupName'
        value: 'GroupForApps'
      }
    ]
    timeout: 'PT10M'
    cleanupPreference: 'Always'
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
}

output result string = deploymentScriptPS.properties.outputs.groupId
