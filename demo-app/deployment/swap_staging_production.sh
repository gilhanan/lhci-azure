resourceGroupName=${RESOURCE_GROUP_NAME}
containerAppName=${CONTAINER_APP_NAME}

if [ -z "$resourceGroupName" ] || [ -z "$containerAppName" ]; then
    echo "Both RESOURCE_GROUP_NAME and CONTAINER_APP_NAME environment variables are required."
    exit 1
fi

echo "Finding staging revision..."
stagingRevision=$(az containerapp ingress show -g "$resourceGroupName" -n "$containerAppName" --query 'traffic[?label == `staging`].revisionName' -o tsv)
echo "Staging revision: $stagingRevision"

echo "Finding production revision..."
productionRevision=$(az containerapp ingress show -g "$resourceGroupName" -n "$containerAppName" --query 'traffic[?label == `production`].revisionName' -o tsv)

if [ -z "$productionRevision" ]; then
    echo "No production revision found."
    echo "Applying production label to staging revision..."
    az containerapp revision label add -g "$resourceGroupName" -n "$containerAppName" --label production --revision "$stagingRevision"
else
    echo "Production revision: $productionRevision"
    echo "Swapping staging and production revisions..."
    az containerapp revision label swap -g "$resourceGroupName" -n "$containerAppName" --source staging --target production
fi

echo "Setting traffic for production=100 and staging=0..."
if [ -z "$productionRevision" ]; then
    az containerapp ingress traffic set -g "$resourceGroupName" -n "$containerAppName" --label-weight production=100
else
    az containerapp ingress traffic set -g "$resourceGroupName" -n "$containerAppName" --label-weight production=100 staging=0
fi

echo "Swap complete."
