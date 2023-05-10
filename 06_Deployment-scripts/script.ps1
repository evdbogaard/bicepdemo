$groupId = (Get-AzADGroup -DisplayName $env:groupName).Id

$members = (Get-AzAdGroupMember -GroupObjectId $groupId).Id

if ($members -Contains $env:principalId)
{
    Write-Host "User already member of group"
}
else
{
    Write-Host "Adding user to group"
    Add-AzAdGroupMember -TargetGroupObjectId $groupId -MemberObjectId $env:principalId
}

$DeploymentScriptOutputs = @{}
$DeploymentScriptOutputs['groupId'] = $groupId
$DeploymentScriptOutputs['groupName'] = $env:groupName
$DeploymentScriptOutputs['principalId'] = $env:principalId