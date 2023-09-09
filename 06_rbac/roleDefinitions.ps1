$result = New-Object -TypeName psobject

$definitions = az role definition list --query "[].{Name:roleName,Id:name}" | ConvertFrom-Json

foreach ($definition in $definitions)
{
    $result | Add-Member -MemberType NoteProperty -Name $definition.Name -Value $definition.Id
}

$result | ConvertTo-Json | Out-File roleDefinitions.json