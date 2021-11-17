# Get Started

## Prerequisites

* If you don't have an Azure subscription, create a [free subscription](https://azure.microsoft.com/free/) before you begin.

* An [Azure Active Directory tenant](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-access-create-new-tenant) associated with your subscription.

* The user account that you use to sign in to Azure must be a member of the **contributor or owner role**, or an **administrator** of the Azure subscription. To view the permissions that you have in the subscription, go to the [Azure portal](https://portal.azure.com/), select your username in the upper-right corner, select the "..." icon for more options, and then select My permissions. If you have access to multiple subscriptions, select the appropriate subscription.

* No [Azure Policies](https://docs.microsoft.com/en-us/azure/governance/policy/overview) preventing creation of Storage accounts or Event Hub namespaces. Purview will deploy a managed Storage account and Event Hub when it is created. If a blocking policy exists and needs to remain in place, please follow our [Purview exception tag guide](https://docs.microsoft.com/en-us/azure/purview/create-purview-portal-faq) and follow the steps to create an exception for Purview accounts.


### Create a Purview Account

* [Create an Account - Azure Portal](https://docs.microsoft.com/en-us/azure/purview/create-catalog-portal)
* [Create an Account - PowerShell/CLI](https://docs.microsoft.com/en-us/azure/purview/create-catalog-powershell)
* [Create an Account - .NET SDK](https://docs.microsoft.com/en-us/azure/purview/create-purview-dotnet)
* [Create an Account - Python](https://docs.microsoft.com/en-us/azure/purview/create-purview-python)
