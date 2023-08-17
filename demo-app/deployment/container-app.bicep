param userAssignedIdentity string
param containerAppName string
param registryHost string
param imageName string
param location string = resourceGroup().location
param revisionUniqueId string = newGuid()
param productionRevision string = 'none'

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
      activeRevisionsMode: 'multiple'
      ingress: {
        external: true
        targetPort: 80
        traffic: productionRevision == 'none' ? [
          {
            latestRevision: true
            label: 'staging'
            weight: 100
          }
        ] : [
          {
            latestRevision: true
            label: 'staging'
            weight: 0
          }
          {
            revisionName: productionRevision
            label: 'production'
            weight: 100
          }
        ]
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
              name: 'revisionUniqueId'
              value: revisionUniqueId
            }
          ]
        }
      ]
      scale: {
        minReplicas: 0
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
