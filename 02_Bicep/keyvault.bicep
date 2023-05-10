param location string
param prinicpalId string

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: 'bicepdemoevdbkv'
  location: location
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enableRbacAuthorization: true
    tenantId: tenant().tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
}

var keyVaultAdministrator = '00482a5a-887f-4fb3-b363-3b7fe8e74483'
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(keyVault.id, prinicpalId, keyVaultAdministrator)
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', keyVaultAdministrator) 
    principalId:  prinicpalId
    principalType: 'User'
  }
  scope: keyVault
}

output keyvaultName string = keyVault.name
