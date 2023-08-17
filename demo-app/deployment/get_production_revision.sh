resourceGroupName=${RESOURCE_GROUP_NAME}
containerAppName=${CONTAINER_APP_NAME}

if [ -z "$resourceGroupName" ] || [ -z "$containerAppName" ]; then
    echo "Both RESOURCE_GROUP_NAME and CONTAINER_APP_NAME environment variables are required."
    exit 1
fi

appCount=$(az containerapp list -g "$resourceGroupName" --query "[?name=='$containerAppName'].name" -o tsv | wc -l)

if [ "$appCount" -eq 1 ]; then
    productionRevision=$(az containerapp ingress show -g "$resourceGroupName" -n "$containerAppName" --query 'traffic[?label == `production`].revisionName' -o tsv)

    if [ -z "$productionRevision" ]; then
        productionRevision="none"
    fi
else
    productionRevision="none"
fi

echo $productionRevision