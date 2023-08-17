param mysqlServerName string
param mysqlDatabaseName string
param tenantId string
param userAssignedIdentity string
param aadAdministratorLogin string
param aadAdministratorSID string
param administratorLogin string
@secure()
param administratorLoginPassword string
param location string = resourceGroup().location

resource mysqlFlexibleServer 'Microsoft.DBforMySQL/flexibleServers@2021-12-01-preview' = {
  name: mysqlServerName
  location: location
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentity}': {}
    }
  }
  properties: {
    version: '8.0.21'
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    availabilityZone: '1'
    highAvailability: {
      mode: 'Disabled'
    }
    storage: {
      storageSizeGB: 20
      iops: 360
      autoGrow: 'Disabled'
    }
    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
  }
}

resource mysqlDatabase 'Microsoft.DBforMySQL/flexibleServers/databases@2021-12-01-preview' = {
  name: mysqlDatabaseName
  parent: mysqlFlexibleServer
  properties: {
    charset: 'utf8'
    collation: 'utf8_general_ci'
  }
}

resource requireSecureTransport 'Microsoft.DBforMySQL/flexibleServers/configurations@2021-12-01-preview' = {
  name: 'require_secure_transport'
  parent: mysqlFlexibleServer
  properties: {
    value: 'OFF'
    currentValue: 'OFF'
    source: 'user-override'
  }
}

resource firewallRules 'Microsoft.DBforMySQL/flexibleServers/firewallRules@2021-12-01-preview' = {
  name: mysqlDatabaseName
  parent: mysqlFlexibleServer
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

resource administrators 'Microsoft.DBforMySQL/flexibleServers/administrators@2021-12-01-preview' = {
  name: 'ActiveDirectory'
  parent: mysqlFlexibleServer
  properties: {
    administratorType: 'ActiveDirectory'
    login: aadAdministratorLogin
    sid: aadAdministratorSID
    tenantId: tenantId
    identityResourceId: userAssignedIdentity
  }
}

resource aadAuthOnly 'Microsoft.DBforMySQL/flexibleServers/configurations@2021-12-01-preview' = {
  name: 'aad_auth_only'
  parent: mysqlFlexibleServer
  dependsOn: [
    administrators
  ]
  properties: {
    value: 'ON'
    currentValue: 'ON'
    source: 'user-override'
  }
}
