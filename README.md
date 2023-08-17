# Lighthouse CI Server on CBL-Mariner and MySQL

## Description

This repository provides everything needed to create and maintain a Lighthouse CI Server hosted on Microsoft's Azure platform, offering a seamless integration with GitHub Actions for continuous integration and deployment processes.

### Components

- **Docker Image**: Built on Microsoft's CBL-Mariner, a Linux distribution optimized for cloud environments, ensuring high performance and reliability.

- **Azure Web App**: Hosts the Linux-based web application component of the Lighthouse CI Server, providing scalable, high-availability hosting seamlessly integrated with Azure.

- **Azure Database for MySQL**: Utilized for storing the Lighthouse CI Server's reports, leveraging Azure's managed MySQL service for robust performance and security.

- **GitHub Actions**: Includes pre-configured actions to automate continuous integration and deployment.

## Prerequisites

- [Azure Account](https://azure.microsoft.com)
- [GitHub Account](https://github.com)

## Setup

### 2. Create an Azure Subscription

If you do not have an Azure subscription, create a new one:

1. Log in to the [Azure Portal](https://portal.azure.com).
2. Click on **Subscriptions** in the left sidebar.
3. Click on **Add** at the top of the page.
4. Follow the steps to create a new subscription.
5. Note down the subscription id.

### 3. Create an Azure Active Directory (AAD) Application

The AAD Application acts as an identity for the GitHub Actions workflow to interact with Azure services.

1. Log in to the [Azure Portal](https://portal.azure.com).
2. Search for **Azure Active Directory** in the search bar at the top and select it.
3. Click on **App registrations** and then **New registration**.
4. Enter a name for the application, and then click **Register**.
5. Once the application is created, note down the **Application (client) ID** and **Directory (tenant) ID**.

### 4. Create a new AAD Application secret

1. Search for and select **Azure Active Directory**.
2. Select **App registrations** and select your application from the list.
3. Select **Certificates & secrets**.
4. Select **Client secrets**, and then select **New client secret**.
5. Provide a description of the secret, and a duration.
6. Select Add.
7. Note down the secret value.

### 4. Assign Contributor Role to the AAD Application

1. Navigate to your Azure subscription.
2. Select **Access control (IAM)**, then click **Add role assignment**.
3. In the **Role** pane, select **Privileged administrator role** and select _Contributor_ as the role
4. Click **Next** or **Members**, select **Assign access to** to **User, group, or service principal**, and select the AAD application that you created earlier.
5. Click **Assign**.

### 5. Set GitHub Secrets

In your GitHub repository, go to **Settings** -> **Secrets and variables** -> **Actions** -> **New repository secret** and add the following secrets:

- `AZURE_APPLICATION_ID`: The Application (client) ID of the AAD application.
- `AZURE_APPLICATION_ID_PASSWORD`: The secret value of the AAD application.
- `AZURE_TENANT_ID`: The Directory (tenant) ID of the AAD application.
- `AZURE_SUBSCRIPTION_ID`: The Subscription ID where you want to deploy the resources.
- `AZURE_RESOURCE_GROUP`: Generate a name for the Azure resource group where you want to deploy the resources.
- `AZURE_CONTAINER_REGISTRY_NAME`: Generate an unique name for the Azure Container Registry where the Lighthouse server Docker images will be stored.
- `AZURE_WEB_APP_NAME`: Generate a name for the Web App service.
- `MYSQL_SERVER_NAME`: Generate an unique name for the MySQL server where the Lighthouse reports will be stored.
- `MYSQL_ADMIN_USERNAME`: Generate an administrator username for the MySQL server.
- `MYSQL_ADMIN_PASSWORD`: Generate an administrator password for the MySQL server.

#### Limitations and policies:

- The following secrets must be unique across the internet: `AZURE_CONTAINER_REGISTRY_NAME`, `MYSQL_SERVER_NAME`, and `AZURE_WEB_APP_NAME`.
- MySQL Admin Password:
  - Must be at least 8 characters and at most 128 characters.
  - Must contain characters from three of the following categories – English uppercase letters, English lowercase letters, numbers (0-9), and non-alphanumeric characters (!, $, #, %, etc.).
  - The password cannot contain all or part of the login name. Part of a login name is defined as three or more consecutive alphanumeric characters.

### 6. Run the GitHub Action Workflow

Once everything is set up, you can run the workflow manually from the **Actions** tab in your GitHub repository, or it will run automatically whenever there's a push to the `main` branch.

## Official documentations

- [Azure Subscription](https://learn.microsoft.com/azure/cost-management-billing/manage/create-subscription)
- [Azure AAD Application](https://learn.microsoft.com/azure/active-directory/develop/howto-create-service-principal-portal)
- [Azure AAD Application secret](https://learn.microsoft.com/azure/active-directory/develop/quickstart-register-app#add-a-client-secret)
- [Azure AAD assign Azure roles](https://learn.microsoft.com/azure/role-based-access-control/role-assignments-portal)
- [GitHub Actions Secrets](https://docs.github.com/rest/actions/secrets)
- [GitHub Actions](https://docs.github.com/actions/using-workflows/about-workflows)

## Pricing

For information on pricing, please refer to the following links:

- [Azure Web App](https://azure.microsoft.com/pricing/details/app-service/)
- [Azure Database for MySQL](https://azure.microsoft.com/pricing/details/mysql/)
- [Azure Container Registry](https://azure.microsoft.com/pricing/details/container-registry/)
