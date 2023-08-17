resourceGroupName=${RESOURCE_GROUP_NAME}
containerAppName=${CONTAINER_APP_NAME}

if [ -z "$resourceGroupName" ] || [ -z "$containerAppName" ]; then
    echo "Both RESOURCE_GROUP_NAME and CONTAINER_APP_NAME environment variables are required."
    exit 1
fi

echo "Listing all revisions..."
allRevisions=$(az containerapp revision list -g "$resourceGroupName" -n "$containerAppName" --query "[].name" -o tsv)

echo "Found $(echo "$allRevisions" | wc -w) revisions."

echo "Finding staging and production revisions..."
stagingRevision=$(az containerapp ingress show -g "$resourceGroupName" -n "$containerAppName" --query 'traffic[?label == `staging`].revisionName' -o tsv)
productionRevision=$(az containerapp ingress show -g "$resourceGroupName" -n "$containerAppName" --query 'traffic[?label == `production`].revisionName' -o tsv)

echo "Staging revision: $stagingRevision"
echo "Production revision: $productionRevision"

for revision in $allRevisions; do
    if [[ "$revision" != "$stagingRevision" && "$revision" != "$productionRevision" ]]; then
        echo "Deactivating revision: $revision"
        az containerapp revision deactivate -g "$resourceGroupName" -n "$containerAppName" --revision "$revision"
    fi
done

echo "Inactive process complete."
