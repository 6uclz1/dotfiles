Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

Install-Module oh-my-posh -Scope CurrentUser

if (-not(Test-Path $profile.CurrentUserAllHosts))
{
	New-Item -Path $profile.CurrentUserAllHosts -ItemType file
	Write-Output "[System.Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding('utf-8')" | Add-Content $profile.CurrentUserAllHosts -Encoding Default
	Write-Output "[System.Console]::InputEncoding  = [System.Text.Encoding]::GetEncoding('utf-8')" | Add-Content $profile.CurrentUserAllHosts -Encoding Default
	Write-Output "$env:LESSCHARSET = 'utf-8'" | Add-Content $profile.CurrentUserAllHosts -Encoding Default
	Write-Output "Import-Module posh-git" | Add-Content $profile.CurrentUserAllHosts -Encoding Default
	Write-Output "Import-Module oh-my-posh" | Add-Content $profile.CurrentUserAllHosts -Encoding Default
	Write-Output "Set-PoshPrompt -Theme powerlevel10k_rainbow" | Add-Content $profile.CurrentUserAllHosts -Encoding Default
}
