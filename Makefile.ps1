# TODO:
#   Create a helper function

function Test-PackerHclBuild ($nickname, $type) {
  Write-Output "`n########################################`n"
  Write-Output "  Packer Validate - $nickname $type"
  Write-Output "`n########################################`n"  
  packer validate -var-file ".\HCL\config\$nickname\$type.pkrvars.hcl" .\HCL\
}
Set-Item -Path Alias:pv -Value Test-PackerHclBuild

function Set-PackerHclFormat {
  Write-Output "`n########################################`n"
  Write-Output "  Packer Format"
  Write-Output "`n########################################`n"  
  packer fmt -recursive .\HCL
}
Set-Item -Path Alias:pfmt -Value Set-PackerHclFormat

function New-PackerHclBuild ($nickname, $type) {
  $timestamp = Get-Date -Format "yyMMddHHmmss"
  $env:PACKER_LOG = 1
  $env:PACKER_LOG_PATH = ".\logs\$timestamp.$nickname.$type.txt"
  Write-Output "`n########################################`n"
  Write-Output "  Packer Validate - $nickname $type"
  Write-Output "`n########################################`n"
  packer validate -except="hyperv-vmcx.adds" -var-file ".\HCL\config\$nickname\$type.pkrvars.hcl" .\HCL\
  Write-Output "`n########################################`n"
  Write-Output "  Packer Build - $nickname $type"
  Write-Output "`n########################################`n"
  packer build -except="hyperv-vmcx.adds" -var-file ".\HCL\config\$nickname\$type.pkrvars.hcl" .\HCL\
}
Set-Item -Path Alias:pb -Value New-PackerHclBuild

function New-PackerFullDesktop ($nickname) {
  $timestamp = Get-Date -Format "yyMMddHHmmss"
  $env:PACKER_LOG = 1
  $env:PACKER_LOG_PATH = ".\logs\$timestamp.$nickname.desktop.txt"
  Write-Output "`n########################################`n"
  Write-Output "  Packer Validate - $nickname full"
  Write-Output "`n########################################`n"
  packer validate -only="hyperv-iso.full" -var-file ".\HCL\config\$nickname\desktop.pkrvars.hcl" .\HCL\
  Write-Output "`n########################################`n"
  Write-Output "  Packer Build - $nickname full"
  Write-Output "`n########################################`n"
  packer build -only="hyperv-iso.full" -var-file ".\HCL\config\$nickname\desktop.pkrvars.hcl" .\HCL\
}
Set-Item -Path Alias:pfull -Value New-PackerFullDesktop

function New-PackerBaseDesktop ($nickname) {
  $timestamp = Get-Date -Format "yyMMddHHmmss"
  $env:PACKER_LOG = 1
  $env:PACKER_LOG_PATH = ".\logs\$timestamp.$nickname.desktop.txt"
  Write-Output "`n########################################`n"
  Write-Output "  Packer Validate - $nickname base"
  Write-Output "`n########################################`n"
  packer validate -only="hyperv-iso.base" -var-file ".\HCL\config\$nickname\desktop.pkrvars.hcl" .\HCL\
  Write-Output "`n########################################`n"
  Write-Output "  Packer Build - $nickname base"
  Write-Output "`n########################################`n"
  packer build -only="hyperv-iso.base" -var-file ".\HCL\config\$nickname\desktop.pkrvars.hcl" .\HCL\
}
Set-Item -Path Alias:pbase -Value New-PackerBaseDesktop

function New-PackerAddsDesktop ($nickname) {
  $timestamp = Get-Date -Format "yyMMddHHmmss"
  $env:PACKER_LOG = 1
  $env:PACKER_LOG_PATH = ".\logs\$timestamp.$nickname.desktop.txt"
  Write-Output "`n########################################`n"
  Write-Output "  Packer Validate - $nickname adds"
  Write-Output "`n########################################`n"
  packer validate -only="hyperv-vmcx.adds" -var-file ".\HCL\config\$nickname\desktop.pkrvars.hcl" .\HCL\
  Write-Output "`n########################################`n"
  Write-Output "  Packer Build - $nickname adds"
  Write-Output "`n########################################`n"
  packer build -only="hyperv-vmcx.adds" -var-file ".\HCL\config\$nickname\desktop.pkrvars.hcl" .\HCL\
}
Set-Item -Path Alias:padds -Value New-PackerAddsDesktop
