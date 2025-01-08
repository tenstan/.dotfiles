# Modules/applications that should be installed:
# - fzf
# - posh-git
# - OhMyPosh
# - bat
# - PSFzf
# - fd


Import-Module posh-git
Import-Module PsFzf


# Set up theme
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/onehalf.minimal.omp.json" | Invoke-Expression
$env:POSH_GIT_ENABLED = $true # Make OhMyPosh aware of posh-git


# Set up autocomplete
Set-PSReadLineKeyHandler -Key Tab -Function Complete # Bash style autocomplete
Set-PSReadLineOption -BellStyle None


# Path shortcuts
function df { Set-Location -Path "$home\.dotfiles" }


# Set up bat
$env:BAT_PAGING = 'never' # Disable paging with bat
Remove-Item Alias:cat -Force
Set-Alias -Name cat -Value bat -Scope Global -Force

