resourceGroupName=${RESOURCE_GROUP_NAME}
containerAppName=${CONTAINER_APP_NAME}

if [ -z "$resourceGroupName" ] || [ -z "$containerAppName" ]; then
    echo "Both RESOURCE_GROUP_NAME and CONTAINER_APP_NAME environment variables are required."
    exit 1
fi

echo "Finding latest revision..."
latestRevision=$(az containerapp revision list -g $resourceGroupName -n $containerAppName --query "reverse(sort_by([].{name:name, date:properties.createdTime},&date))[0].name" -o tsv)
echo "Latest revision: $latestRevision"

echo "Finding staging revision..."
stagingRevision=$(az containerapp ingress show -g $resourceGroupName -n $containerAppName --query 'traffic[?label == `staging`].revisionName' -o tsv)

echo "Finding production revision..."
productionRevision=$(az containerapp ingress show -g $resourceGroupName -n $containerAppName --query 'traffic[?label == `production`].revisionName' -o tsv)

if [ -z "$stagingRevision" ]; then
    echo "No staging revision found."
else
    echo "Staging revision: $stagingRevision"
    echo "Removing staging label from revision: $stagingRevision"
    az containerapp revision label remove -g $resourceGroupName -n $containerAppName --label staging
fi

echo "Applying staging label to latest revision..."
az containerapp revision label add -g $resourceGroupName -n $containerAppName --label staging --revision "$latestRevision" --no-prompt --yes

if [ -z "$productionRevision" ]; then
    az containerapp ingress traffic set -g $resourceGroupName -n $containerAppName --revision-weight latest=100 --label-weight staging=0
else
    az containerapp ingress traffic set -g $resourceGroupName -n $containerAppName --label-weight production=100 staging=0
fi
