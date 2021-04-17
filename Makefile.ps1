# TODO:
#   Support validation & build of specific builder
#   Create a helper function

function Test-PackerBuild ($nickname, $type, $template) {
  packer validate -var-file ".\JSON\config\common.json" -var-file ".\JSON\$nickname\$type.json" ".\JSON\template.json"
}
Set-Item -Path Alias:pv -Value Test-PackerBuild

function New-PackerBuild ($nickname, $type, $template) {
  $timestamp = Get-Date -Format "yyMMddHHmmss"
  $env:PACKER_LOG=1
  $env:PACKER_LOG_PATH=".\logs\$timestamp.$nickname.$type.txt"
  packer build -var-file ".\JSON\config\common.json" -var-file ".\JSON\$nickname\$type.json" ".\JSON\template.json"
}
Set-Item -Path Alias:pb -Value New-PackerBuild