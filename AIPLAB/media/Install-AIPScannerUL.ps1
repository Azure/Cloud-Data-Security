$daU = "contoso\AIPScanner"
$daP = "Somepass1" | ConvertTo-SecureString -AsPlainText -Force
$dacred = New-Object System.Management.Automation.PSCredential -ArgumentList $daU, $daP

"Installing Azure AD Module"
Install-Module -Name "AzureAD" -Force -AllowClobber -Confirm
"Importing Azure AD Module"
Import-Module -Name "AzureAD" -Force

$gacred = get-credential -Message "Enter Azure Global Admin Credentials"

"Connecting to Azure AD"
Connect-AzureAD -Credential $gacred

$SQL = "AdminPC"
	
$ScProfile = "East US"

"Installing AIP Scanner Service"	
Install-AIPScanner -ServiceUserCredentials $dacred -SqlServerInstance $SQL -Profile $ScProfile

# Store date and create unique Display Name for AAD application (you may comment out these lines and set $DisplayName to a unique value if desired)

$Date = Get-Date -UFormat %m%d%H%M
$DisplayName = "AIPOBOv2-" + $Date

# Creating Azure AD Application. This will create the application and assign permissions for Microsoft Rights Management Services, Microsoft Information Protection Sync Service, and Microsoft Graph.

$SvcPrincipal = Get-AzureADServicePrincipal -All $true | ? { $_.DisplayName -match "Microsoft Rights Management Services" }
$ReqAccess = New-Object -TypeName "Microsoft.Open.AzureAD.Model.RequiredResourceAccess"
$ReqAccess.ResourceAppId = $SvcPrincipal.AppId
$Role1 = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" -ArgumentList "d13f921c-7f21-4c08-bade-db9d048bd0da", "Role"
$Role2 = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" -ArgumentList "7347eb49-7a1a-43c5-8eac-a5cd1d1c7cf0", "Role"
$Role3 = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" -ArgumentList "006e763d-a822-41fc-8df5-8d3d7fe20022", "Role"
$ReqAccess.ResourceAccess = $Role1, $Role2, $Role3

$SvcPrincipalUL = Get-AzureADServicePrincipal -All $true | ? { $_.DisplayName -match "Microsoft Information Protection Sync Service" }
$ReqAccessUL = New-Object -TypeName "Microsoft.Open.AzureAD.Model.RequiredResourceAccess"
$ReqAccessUL.ResourceAppId = $SvcPrincipalUL.AppId
$Role4 = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" -ArgumentList "8b2071cd-015a-4025-8052-1c0dba2d3f64", "Role"
$ReqAccessUL.ResourceAccess = $Role4

$SvcPrincipalGr = Get-AzureADServicePrincipal -All $true | ? { $_.DisplayName -match "Microsoft Graph" }
$ReqAccessGr = New-Object -TypeName "Microsoft.Open.AzureAD.Model.RequiredResourceAccess"
$ReqAccessGr.ResourceAppId = $SvcPrincipalGr.AppId

$Scope1 = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" -ArgumentList "e1fe6dd8-ba31-4d61-89e7-88639da4683d", "Scope"
$ReqAccessGr.ResourceAccess = $Scope1
New-AzureADApplication -DisplayName $DisplayName -ReplyURLs http://localhost -RequiredResourceAccess @($ReqAccess, $ReqAccessUL, $ReqAccessGr)
$WebApp = Get-AzureADApplication -Filter "DisplayName eq '$DisplayName'"

New-AzureADServicePrincipal -AppId $WebApp.AppId
$WebAppKey = New-Guid
$Date = Get-Date

New-AzureADApplicationPasswordCredential -ObjectId $WebApp.ObjectID -startDate $Date -endDate $Date.AddYears(1) -Value $WebAppKey.Guid -CustomKeyIdentifier "Password"
$TenantID = (Get-AzureADCurrentSessionInfo).tenantid

# Generate Authentication Token scripts

'"A browser will launch to the created web application to provide Admin consent for the required API permissions. Please log in with tenant admin credentials to provide permissions for this application.  If you are unable to provide this consent, please provide the URL below to your tenant administrator."' | Out-File ~\Desktop\Grant-AdminConsentUL.ps1

'$weburl = "https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/CallAnAPI/appId/'+$WebApp.AppId+'/isMSAApp/"' | Out-File ~\Desktop\Grant-AdminConsentUL.ps1 -Append
"" | Out-File ~\Desktop\Grant-AdminConsentUL.ps1 -Append

'$weburl' | Out-File ~\Desktop\Grant-AdminConsentUL.ps1 -Append
'"Press Enter below to launch the browser"' | Out-File ~\Desktop\Grant-AdminConsentUL.ps1 -Append
"" | Out-File ~\Desktop\Grant-AdminConsentUL.ps1 -Append

'Pause' | Out-File ~\Desktop\Grant-AdminConsentUL.ps1 -Append

'Start-Process $weburl' | Out-File ~\Desktop\Grant-AdminConsentUL.ps1 -Append
'$ServiceAccount = Get-Credential -Message "Enter the on-premises service account credentials"' | Out-File ~\Desktop\Set-AIPAuthenticationUL.ps1

"Set-AIPAuthentication -AppID " + $WebApp.AppId + " -AppSecret " + $WebAppKey.Guid + " -TenantID " + $TenantID.Guid + ' -OnBehalfOf $ServiceAccount' | Out-File ~\Desktop\Set-AIPAuthenticationUL.ps1 -append

"Restart-Service AIPScanner" | Out-File ~\Desktop\Set-AIPAuthenticationUL.ps1 -append
