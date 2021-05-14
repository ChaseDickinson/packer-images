# TODO:
#   Support validation & build of specific builder
#   Create a helper function

function Test-PackerJsonBuild ($nickname, $type) {
  packer validate -var-file ".\JSON\config\common.json" -var-file ".\JSON\config\$nickname\$type.json" ".\JSON\template.json"
}
Set-Item -Path Alias:pjv -Value Test-PackerBuild

function New-PackerJsonBuild ($nickname, $type) {
  $timestamp = Get-Date -Format "yyMMddHHmmss"
  $env:PACKER_LOG = 1
  $env:PACKER_LOG_PATH = ".\logs\$timestamp.$nickname.$type.txt"
  packer build -var-file ".\JSON\config\common.json" -var-file ".\JSON\config\$nickname\$type.json" ".\JSON\template.json"
}
Set-Item -Path Alias:pjb -Value New-PackerBuild

function Test-PackerHclBuild ($nickname, $type) {
  packer validate -var-file ".\HCL\config\$nickname\$type.pkrvars.hcl" .\HCL\
}
Set-Item -Path Alias:phv -Value Test-PackerHclBuild

function New-PackerHclBuild ($nickname, $type) {
  $timestamp = Get-Date -Format "yyMMddHHmmss"
  $env:PACKER_LOG = 1
  $env:PACKER_LOG_PATH = ".\logs\$timestamp.$nickname.$type.txt"
  packer build -var-file ".\HCL\config\$nickname\$type.pkrvars.hcl" .\HCL\
}
Set-Item -Path Alias:phb -Value New-PackerHclBuild