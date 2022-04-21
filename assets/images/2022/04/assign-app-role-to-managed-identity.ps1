########################################################## 
# Allow managed identity to call graph (or custom api)
#
# This script used the AzureAD powershell module.
# Install-Module AzureAD
#
# Stephan van Rooij 2022-04
# https://svrooij.io/2022/04/21/assign-app-role-to-managed-identity/
##########################################################

# Tenant and AccountID are only needed to connect to AzureAD
# $tenantId="00000000-0000-0000-0000-000000000000"
# $accountId="user@domain.com"
# Uncomment next line if not connected to AzureAD yet.
# Connect-AzureAD -TenantId $tenantId -AccountId $accountId

# Set $apiApplicationName to the exact name of the application (under enterprise applications in Azure Portal)
# $apiApplicationName = "Microsoft Graph" # for Graph
$apiApplicationName = "Microsoft Graph"

# Set $apiApplicationRole to the value of the Application Role you want to assign (repeat this script for multiple roles, each role need to be assigned separately)
$apiApplicationRole = "User.ReadWrite.All"

# Set the Object ID of the managed identity (copy from portal)
$managedIdentityObjectId="00000000-0000-0000-0000-000000000000"

Write-Output "Creating managed identity assignment for"
Write-Output "Managed Identity ID:`t$($managedIdentityObjectId)"

# Check if service principal exists
$managedIdentitySp = Get-AzureADServicePrincipal -ObjectId $managedIdentityObjectId -ErrorAction SilentlyContinue
if($null -eq $managedIdentitySp) {
  Write-Output "Managed identity not found"
  exit 10
}

Write-Output "Managed identity name:`t$($managedIdentitySp.DisplayName)"
Write-Output "Application:`t`t$($apiApplicationName)"

# Load the Service Principal (the ID and the roles are needed)
$apiServicePrincipal = Get-AzureADServicePrincipal -SearchString $apiApplicationName | Select-Object -first 1
if($null -eq $apiServicePrincipal) {
  Write-Output "Service principal for api not found"
  exit 20
}

Write-Output "Application ID:`t`t$($apiServicePrincipal.AppId)"
Write-Output "Service Principal ID:`t$($apiServicePrincipal.ObjectId)"
Write-Output "Role:`t`t`t$($apiApplicationRole)"
# Filter the correct role, the id is needed to assign it to the managed identity
$apiRole = $apiServicePrincipal.AppRoles | Where-Object {$_.Value -eq $apiApplicationRole -and $_.AllowedMemberTypes -contains "Application"}
if($null -eq $apiRole) {
  Write-Output "Application role not found"
  exit 30
}

Write-Output "Role ID:`t`t$($apiRole.Id)"

# Assign the role to the managed identity
New-AzureADServiceAppRoleAssignment -ObjectId $managedIdentityObjectId -PrincipalId $managedIdentityObjectId -ResourceId $apiServicePrincipal.ObjectId -Id $apiRole.Id

Write-Output "Managed Identity is assigned the required role"