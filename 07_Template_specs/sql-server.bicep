@description('Name of the sql server')
@minLength(3)
@maxLength(16)
param name string

@description('Location of the sql server')
@allowed([
  'westeurope'
  'northeurope'
])
param location string

@description('Environment the sql server will be deployed in')
@allowed([
  'dev'
  'test'
  'prod'
])
param env string

@description('Username for the admin account')
param adminLogin string

@secure()
@description('Password for the admin account')
@minLength(32)
@maxLength(32)
param adminPassword string

var isProd = env == 'prod'

resource server 'Microsoft.Sql/servers@2022-08-01-preview' = {
  name: name
  location: location
  properties: {
    administratorLogin: adminLogin
    administratorLoginPassword: adminPassword
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
  }

  resource firewallOfficeIp 'firewallRules' = {
    name: 'Office IP'
    properties: {
      startIpAddress: '123.123.123.123'
      endIpAddress: '123.123.123.123'
    }
  }

  resource elaticpool 'elasticPools' = {
    name: 'pool1'
    location: location

    properties: {
      zoneRedundant: isProd
    }
  }
}

@description('Name of the KeyVault to store sql login and password information')
param keyvaultName string

resource keyvault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyvaultName

  resource secretLogin 'secrets' = {
    name: 'SqlServerLogin-${name}'
    properties: {
      value: adminLogin
    }
  }

  resource secretPassword 'secrets' = {
    name: 'SqlServerPassword-${name}'
    properties: {
      value: adminPassword
    }
  }
}

// az ts create -g BicepDemo -f sql-server.bicep -l westeurope --name SqlServer --version 2023-05-09
