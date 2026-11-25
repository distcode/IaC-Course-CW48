# User Management with Microsoft Graph PowerShell SDK
# This script contains all code snippets from UserManagement.md for easy execution

# ============================================================================
# SIGN IN TO MICROSOFT.GRAPH
# ============================================================================
# Connect to Microsoft Graph with User.ReadWrite.All scope
Connect-MgGraph -Scopes 'User.ReadWrite.All'

# Hint: If you would use cmdlets just for reading use the scope 'User.Read.All'

# Variables used for the following cmdlets
$domain = 'trg.dist.at'
$password = 'MgMagic!'
$passwordSecure = ConvertTo-SecureString -String $password -AsPlainText -Force

# Hint: The *-MgUser* cmdlets do not need a secure Password.

# ============================================================================
# CREATE NEW USER
# ============================================================================
$htPasswordprofile = @{
    Password = $password;
    ForceChangePasswordNextSignIn = $false;
    # ForceChangePasswordnextSignInWithMfa=$true --> User must perform Mfa before change password!
}
New-MgUser -DisplayName 'Guido Brunetti' `
           -UserPrincipalName "guido@$domain" `
           -AccountEnabled `
           -MailNickname 'Guido' `
           -Surname 'Brunetti' `
           -GivenName 'Guido' `
           -UsageLocation 'IT' `
           -UserType 'Member' `
           -PasswordProfile $htPasswordprofile

# ============================================================================
# GET A USER'S INFORMATION
# ============================================================================
Get-MgUser
$curUser = Get-MgUser -Search '"DisplayName:Guido"' -ConsistencyLevel eventual
Get-MgUser -UserId $curUser.Id
Get-MgUser -UserId $curUser.Id | Format-List *

# ============================================================================
# FILTER USERS
# ============================================================================
Get-MgUser -Filter "city eq 'London'"
Get-MgUser -Filter "startswith(city, 'L')"

# Hint: There are many more operators like endswith, contains, ...
# See documentation: https://learn.microsoft.com/en-us/graph/filter-query-parameter?tabs=http

# ============================================================================
# GET USER'S DETAILS
# ============================================================================
# Only the properties passed to the '-Property' parameter are actually returned.
$curUser = Get-MgUser -Search '"DisplayName:Guido"' -ConsistencyLevel eventual -Property 'ID,UsageLocation'
$curUser | Format-List *

$curUser = Get-MgUser -Search '"DisplayName:Guido"' -ConsistencyLevel eventual -Property 'ID,UsageLocation,DisplayName,MailnickName,UserPrincipalName'
$curUser | Format-List *

# ============================================================================
# CHANGE USER'S SETTING
# ============================================================================
Update-MgUser -UserId $curUser.Id -City 'Venice'
$curUser = Get-MgUser -UserId $curUser.Id -Property 'ID, City'

# ============================================================================
# DELETE USER
# ============================================================================
Remove-MgUser -UserId $curUser.Id

# ============================================================================
# RESTORE DELETED USER
# ============================================================================
$curUser = Get-MgDirectoryDeletedItemAsUser -Filter "Displayname eq 'Guido Brunetti'"
Restore-MgDirectoryDeletedItem -DirectoryObjectId $curUser.Id
