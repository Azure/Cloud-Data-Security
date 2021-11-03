---
title: Azure Purview Deployment Checklist
description: Azure Purview Deployment Checklist
author: Zeinab Mokhtarian Koorabbasloo
copied from: https://github.com/zeinab-mk/Purview-Deployment-Checklist
file: Readme.md
---

| Update: 05/05/2021  |
---
<br>

# Azure Purview Deployment Checklist

[Azure Purview](https://docs.microsoft.com/en-us/azure/purview/overview) is a unified data governance service that helps you manage and govern your on-premises, multi-cloud, and software-as-a-service (SaaS) data. Using Azure Purview, you can easily create a holistic, up-to-date map of your data landscape with automated data discovery, sensitive data classification, and end-to-end data lineage. You can also empower data consumers to find valuable, trustworthy data.

In order to perform a successful deployment of Azure Purview including registering and scanning all your data sources in Azure so you can create a unified data governance across all your data in the organization, you need to plan carefully and consider all the required steps. In some cases, you may need to work with other teams in your organization to prepare your environment.
This guide and scripts are aimed to help you to achieve this goal.

These PowerShell scripts are aimed assist Azure Subscription owners and Azure Purview Data Source Administrators to identify required access and setup required authentication and network rules for Azure Purview Account across Azure data sources.

## 1. Readiness Checklist

[Azure Purview Readiness Checklist](https://github.com/zeinab-mk/Purview-Deployment-Checklist/blob/main/docs/Azure-Purview-Deployment-Readiness-Checklist.md) is a checklist of high-level steps to guide you to plan and deploy Azure Purview as your data governance solution. The guide is divided into four phases:

1. **Readiness** – Learn the pre-requisite tools and approaches important to all adoption efforts.
2. **Build Foundation** – Deploy Azure Purview Accounts to establish your unified data governance model.
3. **Register Data Sources** – Setup first landing zone and onboard initial group of data sources.
4. **Curate and consume data** – Enable a unified Data Governance solution for data consumers using Azure Purview.

<br>

## 2. Azure Purview Automated Readiness Checklist Scripts

To help you prepare your environment, we have deployed the following scripts so, you can evaluate your existing environment and identify missing configurations so Azure Purview can scan data sources.

Use any of the following **PowerShell-based scripts** to validate your data sources readiness prior scanning data sources in Azure Purview:

- **Azure-Purview-automated-readiness-checklist.ps1**
- **Azure-Purview-automated-readiness-checklist-csv-Input.ps1**

<br>

|**Script**  |**Use cases**  |**Prerequisites**  |**Required Permissions**  |
|---------|---------|---------|---------|
|[Azure-Purview-automated-readiness-checklist.ps1](https://github.com/zeinab-mk/Purview-Deployment-Checklist/blob/main/scripts/Azure-Purview-automated-readiness-checklist.ps1) |<ul><li>Possibility to run the script on a Top-level Management Group or a Subscription as data source scope</li><li>Validates if Azure Purview Managed Identity has access to data sources on both network access and authorization</li><li>Missing configurations are listed as output report</li></ul> |<ul><li>An Azure Purview Account</li><li>Powershell Az Module</li><li>Powershell AzureAD Module</li><li>Powershell Az.Synapse Module</li><li>SQLCMD</li></ul> |<ul><li>Contributor on Azure Purview Resource Group</li><li>Reader at data source Subscription or Management Group </li><li>Get/List Key Vault secret</li><li>Azure AD Global Reader</li></ul> |
|[Azure-Purview-automated-readiness-checklist-csv-Input.ps1](https://github.com/zeinab-mk/Purview-Deployment-Checklist/blob/main/scripts/Azure-Purview-automated-readiness-checklist-csv-Input.ps1) |<ul><li>Possibility to run the script over data sources in multiple subscriptions using a csv list as input </li><li>Validates if Azure Purview Managed Identity has access to data sources on both network access and authorization</li><li>Missing configurations are listed as output report</li><li>Reduced prompts when running the script</li></ul> |<ul><li>An Azure Purview Account</li><li>Powershell Az Module</li><li>Powershell AzureAD Module</li><li>Powershell Az.Synapse Module</li><li>SQLCMD</li></ul> |<ul><li>Contributor on Azure Purview Resource Group</li><li>Reader at data source Subscription or Management Group </li><li>Get/List Key Vault secret</li><li>Azure AD Global Reader</li></ul>|

### 2.1. Core Capabilities 

#### 2.1.1. Azure Purview Authentication type

To scan data sources, Azure Purview requires access to data sources. This is done by using **Credentials**. A credential is an authentication information that Azure Purview can use to authenticate to your registered data sources. There are few options to setup the credentials for Azure Purview such as using Managed Identity assigned to the Purview Account, using a Key Vault or a Service Principals.

The automated readiness checklist currently is supported for **Managed Identity**.

#### 2.1.2. Data Sources types

Currently, the following **data sources** are supported in the script:

- Azure Blob Storage (BlobStorage)
- Azure Data Lake Storage Gen 2 (ADLSGen2)
- Azure Data Lake Storage Gen 1 (ADLSGen1)
- Azure SQL Database (AzureSQLDB)
- Azure SQL Managed Instance (AzureSQLMI)
- Azure Synapse (Synapse)

You can choose **all** or any of these data sources as input when running the script.

**Azure Blob Storage (BlobStorage):**

- RBAC: Verify if Azure Purview MSI has 'Storage Blob Data Reader role' in each of the subscriptions below the selected scope.
- RBAC: Verify if Azure Purview MSI has 'Reader' role on selected scope.
- Service Endpoint: Verify if Service Endpoint is ON, AND check if 'Allow trusted Microsoft services to access this storage account' is enabled.
- Networking: check if Private Endpoint is created for storage and enabled for Blob.

**Azure Data Lake Storage Gen 2 (ADLSGen2)**

- RBAC: Verify if Azure Purview MSI has 'Storage Blob Data Reader' role in each of the subscriptions below the selected scope.
- RBAC: Verify if Azure Purview MSI has 'Reader' role on selected scope.
- Service Endpoint: Verify if Service Endpoint is ON, AND check if 'Allow trusted Microsoft services to access this storage account' is enabled.
- Networking: check if Private Endpoint is created for storage and enabled for Blob Storage.

**Azure Data Lake Storage Gen 1 (ADLSGen1)**

- Networking: Verify if Service Endpoint is ON, AND check if 'Allow all Azure services to access this Data Lake Storage Gen1 account' is enabled.
- Permissions: Verify if Azure Purview MSI has access to Read/Execute.

**Azure SQL Database (AzureSQLDB)**

- SQL Servers:
  - Network: Verify if Public or Private Endpoint is enabled.
  - Firewall: Verify if 'Allow Azure services and resources to access this server' is enabled.
  - Azure AD Admin: Check if Azure SQL Server has AAD Authentication.
  - AAD Admin: Populate Azure SQL Server AAD Admin user or group.

- SQL Databases:
  - SQL Role: Check if Azure Purview MSI has db_datareader role.

**Azure SQL Managed Instance (AzureSQLMI)**

- SQL Managed Instance Servers:
  - Network: Verify if Public or Private Endpoint is enabled.
  - ProxyOverride: Verify if Azure SQL Managed Instance is configured as Proxy or Redirect.
  - Networking: Verify if NSG has an inbound rule to allow AzureCloud over required ports; Redirect: 1433 and 11000-11999 or Proxy: 3342.
  - Azure AD Admin: Check if Azure SQL Server has AAD Authentication.
  - AAD Admin: Populate Azure SQL Server AAD Admin user or group.

- SQL Databases:
  - SQL Role: Check if Azure Purview MSI has db_datareader role.

**Azure Synapse (Synapse):**

- RBAC: Verify if Azure Purview MSI has 'Storage Blob Data Reader role' in each of the subscriptions below the selected scope.
- RBAC: Verify if Azure Purview MSI has 'Reader' role on selected scope.
- SQL Servers (dedicated pools):
  - Network: Verify if Public or Private Endpoint is enabled.
  - Firewall: Verify if 'Allow Azure services and resources to access this server' is enabled.
  - Azure AD Admin: Check if Azure SQL Server has AAD Authentication.
  - AAD Admin: Populate Azure SQL Server AAD Admin user or group.

- SQL Databases:
  - SQL Role: Check if Azure Purview MSI has db_datareader role.

#### 2.1.3. Data Sources Scopes

As your data sources scope, you can select a top-level **Management Group** a **Subscription** or use a csv file which contains subset of your Subscriptions. If you select a Management Group, the readiness check script will run on all subscriptions inside the Management Group including child Management Groups. If you select Subscriptions as data source scope, the script will only run on the resources in selected subscriptions.

### 2.2. Prerequisites

The following prerequisites are required to successfully run the script:

- An Azure Subscription.
- An Azure Purview Account.
- Access to Azure AD and Azure Subscriptions where Azure Purview account and data sources are deployed.
- if csv file is used, a valid user's credential must be configured inside key Vault's secrets in each subscriptions. The script will use these credentials to validate Azure Purview access to Azure SQL Servers, Azure Synapse or Azure SQL Managed Instances.

#### 2.2.1. Required Permissions

The following permissions (minimum) are needed run the script in your Azure environment:
Role | Scope |
|-------|--------|
| Global Reader | Azure AD Tenant |
| Reader | Management Group or Subscription where your Azure Data Sources reside |
| Reader | Subscription where Azure Purview Account is created |
| SQL Admin (Azure AD Authentication) | Azure SQL Servers or Azure SQL Managed Instances |
| Access to your Azure Key Vault | Access to get/list Key Vault's secret for Azure SQL DB, SQL MI or Synapse authentication |  

#### 2.2.2 Required Modules

This script requires Azure PowerShell [Az](https://docs.microsoft.com/en-us/powershell/azure/new-azureps-module-az?view=azps-5.8.0) Modules.

### 2.3. How to run the scripts?

Use the steps in the following examples to run the script:  

#### 2.3.1. Azure-Purview-automated-readiness-checklist

1. Run the [Azure-Purview-automated-readiness-checklist.ps1](https://github.com/zeinab-mk/Purview-Deployment-Checklist/blob/main/scripts/Azure-Purview-automated-readiness-checklist.ps1) script using a PowerShell console and select any of the desired options as data source types.
2. Type "y" to clear context.
3. Sign in to Azure AD and Azure when prompted.
4. Type Azure subscription name of your Azure Purview Account.
5. Type Azure Purview account name.
6. Type 1 if your data sources are located in multiple subscriptions under a top-level Management. Type 2, if you are checking readiness on data sources inside a single subscription.
7. Type Management Group or Subscription Name.
8. Review the output report.

#### 2.3.2. Azure-Purview-automated-readiness-checklist-csv-Input

1. Create a csv file (e.g. "C:\Temp\Subscriptions.csv) with 4 columns:
    a. Column name: SubscriptionId
        This column must contain all subscription ids where your data sources reside.
        example: 12345678-aaaa-bbbb-cccc-1234567890ab

    b. Column name: KeyVaultName
        Provide existing key vault name resource that is deployed in the same corresponding data source subscription.
        example: ContosoDevKeyVault

    c. Column name: SecretNameSQLUserName
        Provide existing key vault secret name that contains Azure Synapse / Azure SQL Servers/ SQL MI Azure AD authentication admin username saved in the secret. This user can be added to a group that is configured in Azure AD authentication on Azure SQL Servers.
        example: ContosoDevSQLAdmin

    d. Column name: SecretNameSQLPassword
        Provide existing key vault secret name that contains Azure Synapse / Azure SQL Servers/ SQL MI Azure AD authentication admin password saved in the secret. This user can be added to a group that is configured in Azure AD authentication on Azure SQL Servers.
        example: ContosoDevSQLPassword

        Note: Before running this script update the file name / path further in the code, if needed.

2. Run the [Azure-Purview-automated-readiness-checklist-csv-Input.ps1](https://github.com/zeinab-mk/Purview-Deployment-Checklist/blob/main/scripts/Azure-Purview-automated-readiness-checklist-csv-Input.ps1) script using a PowerShell console providing the following parameters:
   a. AzureDataType: as data source type, use any of the following options:

        "BlobStorage"
        "AzureSQLMI"
        "AzureSQLDB"
        "ADLSGen2"
        "ADLSGen1"
        "Synapse"
        "All"

    b. PurviewAccount: Your existing Azure Purview Account resource name.

    c. PurviewSub: Subscription ID where Azure Purview Account is deployed.

3. Type "y" to clear context.
4. Sign in to Azure AD and Azure when prompted.
5. If prompted type a user name and password for SQL authentication. This user must exist inside your Azure Active Directory. the script validates whether the user have access to Azure SQL DB, Azure SQL MI and Azure Synapse dedicated pools and if so, uses this as authentication method to connect to each database and validates if Azure Purview MSI has db_datareader role assigned.  
6. Review the output report.

<br>

## 3. Azure Purview Automated MSI Configuration 

These scripts can help you to setup Azure network and access permissions for Azure Purview account, before scanning data sources inside your Azure environment in Azure Purview.

Use any of the following **PowerShell-based scripts** to validate your data sources readiness prior scanning data sources in Azure Purview:

- **Azure-Purview-MSI-Configuration.ps1**
- **Azure-Purview-MSI-Configuration-csv-Input.ps1**

<br>

|**Script**  |**Use cases**  |**Prerequisites**  |**Required Permissions**  |
|---------|---------|---------|---------|
|[Azure-Purview-MSI-Configuration.ps1](https://github.com/zeinab-mk/Purview-Deployment-Checklist/blob/main/scripts/Azure-Purview-MSI-Configuration.ps1) |<ul><li>Possibility to run the script on a Top-level Management Group or a Subscription as data source scope</li><li>Validates and configures required access for Azure Purview Managed Identity on both network and authorization</li><li>Detected settings and progress in the script will generate an output report. Admin will receive several prompts to take action before configuring any settings</li></ul> |<ul><li>An Azure Purview Account</li><li>Powershell Az Module</li><li>Powershell AzureAD Module</li><li>Powershell Az.Synapse Module</li><li>SQLCMD</li></ul> |<ul><li>Contributor on Azure Purview Resource Group</li><li>Owner at data source Subscription or Management Group </li><li>Get/List Key Vault secret</li><li>Azure AD Global Reader</li></ul> |
|[Azure-Purview-MSI-Configuration-csv-Input.ps1](https://github.com/zeinab-mk/Purview-Deployment-Checklist/blob/main/scripts/Azure-Purview-MSI-Configuration-csv-Input.ps1) |<ul><li>Possibility to run the script over data sources in multiple subscriptions using a csv list as input </li><li>Validates and configures required access for Azure Purview Managed Identity on both network and authorization</li><li>Admin is not required to provide any confirmation to setup the configurations.</li><li>Reduced prompts when running the script</li></ul> |<ul><li>An Azure Purview Account</li><li>Powershell Az Module</li><li>Powershell AzureAD Module</li><li>Powershell Az.Synapse Module</li><li>SQLCMD</li></ul> |<ul><li>Contributor on Azure Purview Resource Group</li><li>Reader at data source Subscription or Management Group </li><li>Get/List Key Vault secret</li><li>Azure AD Global Reader</li></ul>|

<br>

### 3.1. Core Capabilities

#### 3.1.1. Authentication type

Azure Purview Managed Identity. One benefit of using Managed Identity for Azure Purview is that if you are using the Purview Managed Identity to set up scans, you will not have to explicitly create a credential and link your key vault to Purview to store them, however you still need to assign access to Purview MSI across your data sources and make sure data sources are reachable.

#### 3.1.2. Data Sources types

Currently, the following **data sources** are supported in this script:

- Azure Blob Storage (BlobStorage)
- Azure Data Lake Storage Gen 2 (ADLSGen2)
- Azure Data Lake Storage Gen 1 (ADLSGen1)
- Azure SQL Database (AzureSQLDB)
- Azure SQL Managed Instance (AzureSQLMI)
- Azure Synapse (Dedicated Pool)

This script can help you to automatically:

**Azure Blob Storage (BlobStorage):**

- RBAC: Verify and assign Azure RBAC 'Reader' role to Azure Purview MSI on selected scope.
- RBAC: Verify and assign Azure RBAC 'Storage Blob Data Reader role' to Azure Purview MSI in each of the subscriptions below selected scope.
- Networking: Verify and report if Private Endpoint is created for storage and enabled for Blob Storage.
- Service Endpoint: If Private Endpoint is disabled check if Service Endpoint is ON, AND enable 'Allow trusted Microsoft services to access this storage account'.

**Azure Data Lake Storage Gen 2 (ADLSGen2)**

- RBAC: Verify and assign Azure RBAC 'Reader' role to Azure Purview MSI on selected scope.
- RBAC: Verify and assign Azure RBAC 'Storage Blob Data Reader role' to Azure Purview MSI in each of the subscriptions below selected scope.
- Networking: Verify and report if Private Endpoint is created for storage and enabled for Blob Storage.
- Service Endpoint: If Private Endpoint is disabled check if Service Endpoint is ON, AND enable 'Allow trusted Microsoft services to access this storage account'.

**Azure Data Lake Storage Gen 1 (ADLSGen1)**

- Networking: Verify if Service Endpoint is ON, AND enabled 'Allow all Azure services to access this Data Lake Storage Gen1 account' on Data Lake Storage.
- Permissions: Verify and assign Read/Execute access to Azure Purview MSI .

**Azure SQL Database (AzureSQLDB)**

- SQL Servers:
  - Network: Verify and report if Public or Private Endpoint is enabled.
  - Firewall: If Private Endpoint is off, verify firewall rules and enable 'Allow Azure services and resources to access this server'.
  - Azure AD Admin: Enable Azure AD Authentication for Azure SQL Server.

- SQL Databases:
  - SQL Role: Assign Azure Purview MSI with db_datareader role.

**Azure SQL Managed Instance (AzureSQLMI)**

- SQL Managed Instance Servers:
  - Network: Verify if Public or Private Endpoint is enabled. Reports if Public endpoint is disabled.
  - ProxyOverride: Verify if Azure SQL Managed Instance is configured as Proxy or Redirect.
  - Networking: Verify and update NSG rules to allow AzureCloud with inbound access to SQL Server over required ports; Redirect: 1433 and 11000-11999 or Proxy: 3342.
  - Azure AD Admin: Enable Azure AD Authentication for Azure SQL Managed Instance.
  
- SQL Databases:
  - SQL Role: Assign Azure Purview MSI with db_datareader role.

**Azure Synapse (Synapse):**

- RBAC: Verify and assign Azure RBAC 'Reader' role to Azure Purview MSI on selected scope.
- RBAC: Verify and assign Azure RBAC 'Storage Blob Data Reader role' to Azure Purview MSI in each of the subscriptions below selected scope.
- SQL Servers (Dedicated Pools):
  - Network: Verify and report if Public or Private Endpoint is enabled.
  - Firewall: If Private Endpoint is off, verify firewall rules and enable 'Allow Azure services and resources to access this server'.
  - Azure AD Admin: Enable Azure AD Authentication for Azure SQL Server.

- SQL Databases:
  - SQL Role: Assign Azure Purview MSI with db_datareader role.

#### 3.1.3. Data Sources Scopes

As your data sources scope, you can select a top-level **Management Group** a **Subscription** or use a csv file which contains subset of your Subscriptions. If you select a Management Group, the readiness check script will run on all subscriptions inside the Management Group including child Management Groups. If you select Subscriptions as data source scope, the script will only run on the resources in selected subscriptions.

### 3.2. Prerequisites

The following prerequisites are required to successfully run the script:

- An Azure Subscription.
- An Azure Purview Account.
- Access to Azure AD and Azure Subscriptions where Azure Purview account and data sources are deployed.
- if csv file is used, a valid user's credential must be configured inside key Vault's secrets in each subscriptions. The script will configure Azure Ad Authentication using these credentials for Azure SQL Servers, Azure Synapse or Azure SQL Managed Instances.

#### 3.2.1 Required Permissions

The following permissions (minimum) are needed run the script in your Azure environment:
Role | Scope | Why is needed? |
|-------|--------|--------|
| Global Reader | Azure AD Tenant | To read Azure SQL Admin user group membership and Azure Purview MSI |
| Global Administrator | Azure AD Tenant | To assign 'Directory Reader' role to Azure SQL Managed Instances |
| Contributor | Subscription or Resource Group where Azure Purview Account is created | To read Azure Purview Account resource. Create Key Vault resource and a secret. |
| Owner or User Access Administrator | Management Group or Subscription where your Azure Data Sources reside | To assign RBAC |
| Contributor | Management Group or Subscription where your Azure Data Sources reside | To setup Network configuration |
| SQL Admin (Azure AD Authentication) | Azure SQL Servers or Azure SQL Managed Instances | To assign db_datareader role to Azure Purview |
| Access to your Azure Key Vault | Access to get/list Key Vault's secret for Azure SQL DB, SQL MI or Synapse authentication |  

#### 3.2.2 Required Modules

This script requires Azure PowerShell [Az](https://docs.microsoft.com/en-us/powershell/azure/new-azureps-module-az?view=azps-5.8.0) Modules.

### 3.3. How to run the scripts?

Use the steps in the following examples to run the script:  

#### 3.3.1 Azure-Purview-MSI-Configuration

1. Run the [Azure-Purview-MSI-Configuration.ps1](https://github.com/zeinab-mk/Purview-Deployment-Checklist/blob/main/scripts/Azure-Purview-MSI-Configuration.ps1) script using a PowerShell console and select any of the desired options as data source types.
2. Type "y" to clear context.
3. Sign in to Azure AD and Azure when prompted.
4. Type Azure subscription name of your Azure Purview Account.
5. Type Azure Purview account name.
6. Type 1 if your data sources are located in multiple subscriptions under a top-level Management. Type 2, if you are checking readiness on data sources inside a single subscription.
7. Type Management Group or Subscription Name.
8. When prompted, provide required information to configure access management or network configuration over the data sources and defined scope.
9. Review the output report.

#### 3.3.2 Azure-Purview-MSI-Configuration-csv-Input.ps1

1. Create a csv file (e.g. "C:\Temp\Subscriptions.csv) with 4 columns:
    a. Column name: SubscriptionId
        This column must contain all subscription ids where your data sources reside.
        example: 12345678-aaaa-bbbb-cccc-1234567890ab

    b. Column name: KeyVaultName
        Provide existing key vault name resource that is deployed in the same corresponding data source subscription.
        example: ContosoDevKeyVault

    c. Column name: SecretNameSQLUserName
        Provide existing key vault secret name that contains Azure Synapse / Azure SQL Servers/ SQL MI Azure AD authentication admin username saved in the secret. This user can be added to a group that is configured in Azure AD authentication on Azure SQL Servers.
        example: ContosoDevSQLAdmin

    d. Column name: SecretNameSQLPassword
        Provide existing key vault secret name that contains Azure Synapse / Azure SQL Servers/ SQL MI Azure AD authentication admin password saved in the secret. This user can be added to a group that is configured in Azure AD authentication on Azure SQL Servers.
        example: ContosoDevSQLPassword

        Note: Before running this script update the file name / path further in the code, if needed.

2. Run the [Azure-Purview-MSI-Configuration-csv-Input.ps1](https://github.com/zeinab-mk/Purview-Deployment-Checklist/blob/main/scripts/Azure-Purview-MSI-Configuration-csv-Input.ps1) script using a PowerShell console providing the following parameters:
   a. AzureDataType: as data source type, use any of the following options:

        "BlobStorage"
        "AzureSQLMI"
        "AzureSQLDB"
        "ADLSGen2"
        "ADLSGen1"
        "Synapse"
        "All"

    b. PurviewAccount: Your existing Azure Purview Account resource name.

    c. PurviewSub: Subscription ID where Azure Purview Account is deployed.

3. Type "y" to clear context.
4. Sign in to Azure AD and Azure when prompted.
5. If prompted, type a user name and password for SQL authentication. This means that the username in the Key Vault secret does not match with your Azure SQL authentication, so you can provide your administrator's credential to connect to the Azure SQL Servers.
Note: other settings will not require any prompts.
6. Review the output report.
