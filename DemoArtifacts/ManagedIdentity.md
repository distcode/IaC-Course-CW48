# Managed Identity Sign In

To sign in as Managed Identity use: 

```PowerShell
$response = Invoke-WebRequest -UseBasicParsing -Method GET `
  -Uri 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fmanagement.azure.com%2F' `
  -Headers @{ Metadata = 'true' }

$token = ($response.Content | ConvertFrom-Json).access_token
```

... and to use the access token:

```PowerShell
Invoke-WebRequest -UseBasicParsing `
  -Uri 'https://management.azure.com/subscriptions?api-version=2020-01-01' `
  -Headers @{ Authorization = "Bearer $token" }
```
