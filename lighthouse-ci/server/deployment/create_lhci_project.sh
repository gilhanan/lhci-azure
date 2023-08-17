LHCI_HOST=${LHCI_HOST}
NAME=${NAME}
REPO_URL=${REPO_URL}
BASE_BRANCH=${BASE_BRANCH}
SLUG=${SLUG}

if [ -z "$LHCI_HOST" ] || [ -z "$NAME" ] || [ -z "$REPO_URL" ] || [ -z "$BASE_BRANCH" ] || [ -z "$SLUG" ]; then
    echo "All of the following environment variables are required: LHCI_HOST, NAME, REPO_URL, BASE_BRANCH, SLUG, KEYVAULT_NAME"
    exit 1
fi

create_project() {
    response=$(curl -s -X POST "https://${LHCI_HOST}/v1/projects" -H "Content-Type: application/json" -d '{
        "name": "'"$NAME"'",
        "externalUrl": "'"$REPO_URL"'",
        "baseBranch": "'"$BASE_BRANCH"'",
        "slug": "'"$SLUG"'"
    }')

    token=$(echo $response | jq -r '.token')
    adminToken=$(echo $response | jq -r '.adminToken')

    if [ -z "$token" ]; then
        echo "Error: token is empty"
        exit 1
    fi

    if [ -z "$adminToken" ]; then
        echo "Error: adminToken is empty"
        exit 1
    fi

    echo "{\"token\":\"$token\",\"adminToken\":\"$adminToken\"}"
}

projects=$(curl -s "https://${LHCI_HOST}/v1/projects")
projects_count=$(echo $projects | jq '. | length')

if ! [[ "$projects_count" =~ ^[0-9]+$ ]]; then
    echo "Error: Failed to get projects"
    exit 1
fi

if [ "$projects_count" -eq 0 ]; then
    create_project
else
    echo "{}"
fi
