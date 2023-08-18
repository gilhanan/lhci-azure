CLIENT_ID=
CLIENT_SECRET=
TENANT_ID=

az login --service-principal -u $CLIENT_ID -p $CLIENT_SECRET --tenant $TENANT_ID

password=$(az account get-access-token --resource https://ossrdbms-aad.database.windows.net --query accessToken -o tsv)

mysql --host gh-lhci-server-db.mysql.database.azure.com \
      --user lhci \
      --password=$password \
      --enable-cleartext-plugin