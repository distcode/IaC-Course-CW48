# License Management with Microsoft Graph PowerShell SDK
# This script contains all code snippets from LicManagement.md for easy execution

# ============================================================================
# SIGN IN TO ENTRA ID
# ============================================================================
# To assign licenses the scopes User.ReadWrite.All and Organization.Read.All are required.
Connect-MgGraph -Scopes User.ReadWrite.All, Organization.Read.All

# ============================================================================
# SET USAGE LOCATION
# ============================================================================
# The usage location is mandatory for assigning licenses.
$curUser = Get-MgUser -Filter "givenname eq 'guido'" -Property 'ID, UsageLocation'
Update-MgUser -UserId $curUser.Id -UsageLocation IT

# ============================================================================
# GET LICENSE SKUS
# ============================================================================
# Show all purchased licenses in your tenant
Get-MgSubscribedSku | Format-Table SkuPartNumber,ServicePlans
# Show licenses with the amount of paid and consumed licenses
Get-MgSubscribedSku | Format-Table SkuPartNumber,ConsumedUnits,@{Label='PaidUnits';E={$_.prepaidunits.enabled}}
# Save the Microsoft 365 E5 subscription in a variable for later use
$licSKU = Get-MgSubscribedSku | Where-Object {
    $PSItem.SkuPartNumber -eq 'Office_365_w/o_Teams_Bundle_Business_Premium'
}

# ============================================================================
# ASSIGN LICENSES
# ============================================================================
# Assign a license with all service plans
Set-MgUserLicense -UserId $curUser.Id -AddLicenses @{SkuId = $licSKU.SkuId} -RemoveLicenses @()

# ============================================================================
# ASSIGN LICENSES WITH OPTIONS
# ============================================================================
# Select the service plans to disable
$disabledServices = $licSKU.ServicePlans | Where-Object { $_.ServicePlanName -like 'VIVA*' }
# Create a license hashtable with SkuId and DisabledPlans (an array of ServicePlanIds), then assign it
$lic = @{ SkuId = $licSKU.SkuId; DisabledPlans = $disabledServices.ServicePlanId }
Set-MgUserLicense -UserId $curUser.Id -AddLicenses $lic -RemoveLicenses @()

# ============================================================================
# GET INFORMATION OF ASSIGNED LICENSES
# ============================================================================
$curUser = Get-MgUser -Filter "givenname eq 'guido'" -Property 'ID, UsageLocation, UserPrincipalName'
Get-MgUserLicenseDetail -UserId $curUser.Id

# ============================================================================
# REMOVE A LICENSE
# ============================================================================
# Unassign a license: -RemoveLicenses takes an array of SkuIds
Set-MgUserLicense -UserId $curUser.Id -RemoveLicenses @($licSKU.SkuId) -AddLicenses @()
