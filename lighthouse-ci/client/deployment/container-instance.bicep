param userAssignedIdentity string
param containerInstanceName string
param registryHost string
param imageName string
param LHCI_SERVER string
param LHCI_TOKEN string
param URL string
param LHCI_BUILD_CONTEXT__GIT_REMOTE string
param LHCI_BUILD_CONTEXT__GITHUB_REPO_SLUG string
param LHCI_BUILD_CONTEXT__CURRENT_HASH string
param LHCI_BUILD_CONTEXT__ANCESTOR_HASH string
param LHCI_BUILD_CONTEXT__COMMIT_TIME string
param LHCI_BUILD_CONTEXT__CURRENT_BRANCH string
param LHCI_BUILD_CONTEXT__COMMIT_MESSAGE string
param LHCI_BUILD_CONTEXT__AUTHOR string
param LHCI_BUILD_CONTEXT__EXTERNAL_BUILD_URL string
param location string = resourceGroup().location

var imageFullName = '${registryHost}/${imageName}'

resource containerApp 'Microsoft.ContainerInstance/containerGroups@2021-07-01' = {
  name: containerInstanceName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentity}': {}
    }
  }
  properties: {
    osType: 'Linux'
    restartPolicy: 'Never'
    imageRegistryCredentials: [
      {
        server: registryHost
        identity: userAssignedIdentity
      }
    ]
    containers: [
      {
        name: containerInstanceName
        properties: {
          image: imageFullName
          resources: {
            requests: {
              cpu: 2
              memoryInGB: 4
            }
          }
          environmentVariables: [
            {
              name: 'LHCI_SERVER'
              value: LHCI_SERVER
            }
            {
              name: 'LHCI_TOKEN'
              value: LHCI_TOKEN
            }
            {
              name: 'URL'
              value: URL
            }
            {
              name: 'LHCI_BUILD_CONTEXT__GIT_REMOTE'
              value: LHCI_BUILD_CONTEXT__GIT_REMOTE
            }
            {
              name: 'LHCI_BUILD_CONTEXT__GITHUB_REPO_SLUG'
              value: LHCI_BUILD_CONTEXT__GITHUB_REPO_SLUG
            }
            {
              name: 'LHCI_BUILD_CONTEXT__CURRENT_HASH'
              value: LHCI_BUILD_CONTEXT__CURRENT_HASH
            }
            {
              name: 'LHCI_BUILD_CONTEXT__ANCESTOR_HASH'
              value: LHCI_BUILD_CONTEXT__ANCESTOR_HASH
            }
            {
              name: 'LHCI_BUILD_CONTEXT__COMMIT_TIME'
              value: LHCI_BUILD_CONTEXT__COMMIT_TIME
            }
            {
              name: 'LHCI_BUILD_CONTEXT__CURRENT_BRANCH'
              value: LHCI_BUILD_CONTEXT__CURRENT_BRANCH
            }
            {
              name: 'LHCI_BUILD_CONTEXT__COMMIT_MESSAGE'
              value: LHCI_BUILD_CONTEXT__COMMIT_MESSAGE
            }
            {
              name: 'LHCI_BUILD_CONTEXT__AUTHOR'
              value: LHCI_BUILD_CONTEXT__AUTHOR
            }
            {
              name: 'LHCI_BUILD_CONTEXT__EXTERNAL_BUILD_URL'
              value: LHCI_BUILD_CONTEXT__EXTERNAL_BUILD_URL
            }
          ]
        }
      }
    ]
  }
}
