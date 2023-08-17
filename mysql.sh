resourceGroup="gh-lhci"
serverName="gh-lhci-server-db"
identityName="gh-lhci-server-identity"
userPrincipalName="lhci@gilhanangmail.onmicrosoft.com"
userDiaplayName="LHCI"
password="p8CLqyM0pha0"

echo resourceGroup is: $resourceGroup
echo serverName is: $serverName
echo identityName is: $identityName
echo userPrincipalName is: $userPrincipalName
echo userDiaplayName is: $userDiaplayName
echo password is: $password

sudo apt-get install mysql-client -y

identityClientId=$(az identity show --resource-group $resourceGroup --name $identityName --query clientId --output tsv)

echo Identity Client Id is: $identityClientId

exists=$(az ad user list --filter "userPrincipalName eq '$userPrincipalName'" --query [].id --output tsv)
if [ -z "$exists" ]; then
    az ad user create --display-name $userDiaplayName --password $password --user-principal-name $userPrincipalName
else
    echo "User already exists."
fi

userObjectId=$(az ad user list --filter "userPrincipalName eq '$userPrincipalName'" --query [].id --output tsv)

echo User Object Id is $userObjectId

az mysql flexible-server ad-admin create \
    --resource-group $resourceGroup \
    --server-name $serverName \
    --display-name $userPrincipalName \
    --object-id $userObjectId \
    --identity $identityName

az login -u $userPrincipalName -p $password --allow-no-subscriptions

accessToken=$(az account get-access-token --resource-type oss-rdbms --output tsv --query accessToken)

echo Access Token is $accessToken

mysql \
    --host $serverName.mysql.database.azure.com \
    --user $userPrincipalName@$serverName \
    --enable-cleartext-plugin \
    --password=$accessToken

# mysql --host=$serverName.mysql.database.azure.com --user=$userPrincipalName@$serverName --password=$accessToken --enable-cleartext-plugin << EOF
# SET aad_auth_validate_oids_in_tenant = OFF;
# CREATE AADUSER '$userPrincipalName' IDENTIFIED BY '$identityClientId';
# GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER ON *.* TO '$userPrincipalName'@'%' WITH GRANT OPTION;
# FLUSH PRIVILEGES;
# EOF


# SET aad_auth_validate_oids_in_tenant = OFF;
# CREATE AADUSER 'lhci' IDENTIFIED BY '44a827ce-27e9-4fd9-948a-b88fd2d55f71';
# GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER ON *.* TO 'lhci'@'%' WITH GRANT OPTION;
# FLUSH PRIVILEGES;

# delete


# DROP USER IF EXISTS 'lhci'@'%';
# CREATE AADUSER 'lhci' IDENTIFIED BY 'b754f994-14be-4549-bc52-e60c5624648d';
# GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER ON *.* TO 'lhci'@'%' WITH GRANT OPTION;
# FLUSH PRIVILEGES;
