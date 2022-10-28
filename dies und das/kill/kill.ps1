$mypath=Split-Path $script:MyInvocation.MyCommand.Path


$ErrorActionPreference = "Stop"
#$p= Get-Process Zoll # | Format-List Name, Id
$p= Get-Process Lekl # | Format-List Name, Id
$p | Format-Table Name, Id
Stop-Process -InputObject $p -Confirm -PassThru
#Stop-Process -Name "Zoll"

