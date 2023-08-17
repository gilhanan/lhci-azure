param managedIdentityClientId string
param userAssignedIdentity string
param containerAppName string
param registryHost string
param imageName string
param mysqlDatabaseName string
param mysqlServerName string
param mysqlUser string
param location string = resourceGroup().location

var port = 9001
var environmentName = '${containerAppName}-env'
var imageFullName = '${registryHost}/${imageName}'

resource containerApp 'Microsoft.App/containerapps@2023-05-02-preview' = {
  name: containerAppName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentity}': {}
    }
  }
  properties: {
    managedEnvironmentId: resourceId('Microsoft.App/managedEnvironments', environmentName)
    configuration: {
      ingress: {
        external: true
        targetPort: port
      }
      registries: [
        {
          identity: userAssignedIdentity
          server: registryHost
        }
      ]
    }
    template: {
      containers: [
        {
          name: containerAppName
          image: imageFullName
          resources: {
            cpu: 1
            memory: '2.0Gi'
          }
          env: [
            {
              name: 'AZURE_CLIENT_ID'
              value: managedIdentityClientId
            }
            {
              name: 'port'
              value: '${port}'
            }
            {
              name: 'mysqlServerName'
              value: mysqlServerName
            }
            {
              name: 'mysqlDatabaseName'
              value: mysqlDatabaseName
            }
            {
              name: 'mysqlUser'
              value: mysqlUser
            }
          ]
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
    }
  }
  dependsOn: [
    environment
  ]
}

resource environment 'Microsoft.App/managedEnvironments@2023-05-02-preview' = {
  name: environmentName
  location: location
  properties: {
    workloadProfiles: [
      {
        name: 'Consumption'
        workloadProfileType: 'Consumption'
      }
    ]
  }
}
