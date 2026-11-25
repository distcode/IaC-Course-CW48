# Useful cmdlets for Microsoft Graph PowerShell SDK

Some often used useful cmdlet for Microsoft Graph.

---

Table of Content

- [Useful cmdlets for Microsoft Graph PowerShell SDK](#useful-cmdlets-for-microsoft-graph-powershell-sdk)
  - [Installation](#installation)
  - [Connecting](#connecting)
  - [Check Scope](#check-scope)
  - [Disconnecting](#disconnecting)
  - [Find cmdlets and permission requirements](#find-cmdlets-and-permission-requirements)
  - [No suitable cmdlet found](#no-suitable-cmdlet-found)

---

## Installation

How to install Microsoft Graph modules.

```PowerShell
# PS 5.1
Install-Module Microsoft.Graph
# PS 7
Install-PSResource Microsoft.Graph
```

There's also a beta version available.

```PowerShell
Install-PSResource Microsoft.Graph.Beta
```

## Connecting

To sign in for Microsoft Graph you should avoid an interactive login. Instead, use a service principle (SP). A SP needs a secret or a certificate for singing in. The following snippets assume all preparation for SP, secret and/or certificate.

Sign in with a secret:

```PowerShell
$TenantID = '<yourTenantID>'
$AppID = '<yourSP-App/CLientID>'
$Secret = '<yourSecret>'

$secureSecret = Convertto-SecureString -String $Secret -AsPlainText -Force
$cred = New-Object -TypeName pscredential -ArgumentList $AppID,$SecureSecret

Connect-MgGraph -TenantID $TenantID -ClientSecretCredential $Cred
```

Sign in with a certificate:

```PowerShell
$TenantID = '<yourTenantID>'
$AppID = '<yourSP-App/CLientID>'
$Thumbprint = '<yourThumbprint>'

$Cert = Get-ChildItem Cert:\LocalMachine\my\$Thumbprint

Connect-MgGraph -TenantID $TenantID -ClientID $AppID -Certificate $Cert
```

## Check Scope

To check current connected SP:

```PowerShell
Get-MgContext

(Get-MgContext).Scope
```

## Disconnecting

Should you change in Entra ID the scope of a SP (permissions) you have to sing in again. Therefor sign out first:

```PowerShell
Disconnect-MgGraph
```

## Find cmdlets and permission requirements

Use this

```PowerShell
Find-MgGraphCommand
Find-MgGraphCommand -Command Update-MgUser
Find-MgGraphCommand -Uri 'https://graph.microsoft.com/v1.0/me/insights/trending'

(Find-MgGraphCommand -Command Update-MgUser).Permissions
(Find-MgGraphCommand -Uri 'https://graph.microsoft.com/v1.0/me/insights/trending').Permissions
```

## No suitable cmdlet found

If you cannot find a suitable cmdlet for a specific Microsoft Graph API endpoint, you can use instead the cmdlet `Invoke-MgGraphRequest` to make direct API calls.

Examples:

```PowerShell
# What are the trending insights of a user
Invoke-MgGraphRequest -Method GET -Uri 'https://graph.microsoft.com/v1.0/users/{user-id}/insights/trending'

# How many users are in the tenant
Invoke-MgGraphRequest -Uri 'https://graph.microsoft.com/v1.0/users/$count' `
    -Headers @{ ConsistencyLevel = 'eventual' }
```

Parameters of `Invoke-MgGraphRequest` include:

- `-Method`: The HTTP method to use (GET, POST, PATCH, DELETE, etc.). Default is GET.
- `-Uri`: The full URI of the Microsoft Graph API endpoint.
- `-Headers`: A hashtable of HTTP headers to include in the request.
- `-Body`: The body of the request for methods like POST or PATCH.
- `-ContentType`: The content type of the request body, e.g., 'application/json'.
