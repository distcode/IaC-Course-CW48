# Group Management with Microsoft Graph PowerShell SDK
# This script contains all code snippets from GrpManagement.md for easy execution

# ============================================================================
# SIGN IN TO MICROSOFT.GRAPH
# ============================================================================
# 'Group.ReadWrite.All' is needed for group management,
# 'User.ReadWrite.All' to read and change user attributes as well
Connect-MgGraph -Scopes 'User.ReadWrite.All', 'Group.ReadWrite.All'

# ============================================================================
# CREATE A NEW GROUP
# ============================================================================
# -SecurityEnabled creates a security group, -MailEnabled:$false creates a
# group without a mail address (not mail enabled security group)
New-MgGroup `
    -MailNickname 'mgDetectives' `
    -DisplayName 'mgDetectives' `
    -SecurityEnabled `
    -MailEnabled:$false

# ============================================================================
# GET GROUPS / GROUP
# ============================================================================
Get-MgGroup
$myGroup = Get-MgGroup -Search 'displayName:mgDetectives' -ConsistencyLevel eventual
$myGroup = Get-MgGroup -GroupId $myGroup.Id
$myGroup | Format-List -Property *

# ============================================================================
# ADD MEMBER(S) TO GROUPS
# ============================================================================
# Instead of Add-MgGroupMember use New-MgGroupMember;
# -DirectoryObjectId indicates the object to add to the group
$myUser = Get-MgUser -Search '"Displayname:Guido"' -ConsistencyLevel eventual
New-MgGroupMember -GroupId $myGroup.Id -DirectoryObjectId $myUser.Id
Get-MgGroupMember -GroupId $myGroup.Id
Get-MgGroupMember -GroupId $myGroup.Id | ForEach-Object { Get-MgUser -UserId $PSItem.Id }

# ============================================================================
# REMOVE MEMBER(S) FROM GROUP(S)
# ============================================================================
$myUser = Get-MgUser -Search '"Displayname:Guido"' -ConsistencyLevel eventual
Remove-MgGroupMemberByRef -GroupId $myGroup.Id -DirectoryObjectId $myUser.Id
