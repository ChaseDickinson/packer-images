####################################
# Packer Builds by @Okie_Chase
####################################

# Macros
LINE_DIVIDE=************************************************************
HCL_DIR:=./HCL
JSON_DIR:=./JSON

# Phony rules
.PHONY: bd
bd:
	@echo "${LINE_DIVIDE}"
	@echo "  Bionic Desktop"
	@echo "${LINE_DIVIDE}"
	@echo "  Validate"
	packer validate -var-file ${JSON_DIR}/config/common.json -var-file ${JSON_DIR}/config/bionic/desktop.json ${JSON_DIR}/template.json
	@echo "  Build"
	packer build -force -var-file ${JSON_DIR}/config/common.json -var-file ${JSON_DIR}/config/bionic/desktop.json ${JSON_DIR}/template.json

.PHONY: ba
bfa:
	@echo "${LINE_DIVIDE}"
	@echo "  Bionic Desktop - Adds"
	@echo "${LINE_DIVIDE}"
	@echo "  Validate"
	packer validate -var-file ${JSON_DIR}/config/common.json -var-file ${JSON_DIR}/config/bionic/desktop.json ${JSON_DIR}/adds.json
	@echo "  Build"
	packer build -var-file ${JSON_DIR}/config/common.json -var-file ${JSON_DIR}/config/bionic/desktop.json ${JSON_DIR}/adds.json

.PHONY: fd
fd:
	@echo "${LINE_DIVIDE}"
	@echo "  Focal Desktop"
	@echo "${LINE_DIVIDE}"
	@echo "  Validate"
	packer validate -var-file ${JSON_DIR}/config/common.json -var-file ${JSON_DIR}/config/focal/desktop.json ${JSON_DIR}/template.json
	@echo "  Build"
	packer build -force -var-file ${JSON_DIR}/config/common.json -var-file ${JSON_DIR}/config/focal/desktop.json ${JSON_DIR}/template.json

.PHONY: fd-base
fd-base:
	@echo "${LINE_DIVIDE}"
	@echo "  Focal Desktop - Base"
	@echo "${LINE_DIVIDE}"
	@echo "  Validate"
	packer validate -only=base -var-file ${JSON_DIR}/config/common.json -var-file ${JSON_DIR}/config/focal/desktop.json ${JSON_DIR}/template.json
	@echo "  Build"
	packer build -only=base -var-file ${JSON_DIR}/config/common.json -var-file ${JSON_DIR}/config/focal/desktop.json ${JSON_DIR}/template.json

.PHONY: fd-full
fd-full:
	@echo "${LINE_DIVIDE}"
	@echo "  Focal Desktop - Full"
	@echo "${LINE_DIVIDE}"
	@echo "  Validate"
	packer validate -only=full -var-file ${JSON_DIR}/config/common.json -var-file ${JSON_DIR}/config/focal/desktop.json ${JSON_DIR}/template.json
	@echo "  Build"
	packer build -only=full -var-file ${JSON_DIR}/config/common.json -var-file ${JSON_DIR}/config/focal/desktop.json ${JSON_DIR}/template.json

.PHONY: fa
fa:
	@echo "${LINE_DIVIDE}"
	@echo "  Focal Desktop - Adds"
	@echo "${LINE_DIVIDE}"
	@echo "  Validate"
	packer validate -var-file ${JSON_DIR}/config/common.json -var-file ${JSON_DIR}/config/focal/desktop.json ${JSON_DIR}/adds.json
	@echo "  Build"
	packer build -var-file ${JSON_DIR}/config/common.json -var-file ${JSON_DIR}/config/focal/desktop.json ${JSON_DIR}/adds.json

.PHONY: bs
bs:
	@echo "${LINE_DIVIDE}"
	@echo "  Bionic Server"
	@echo "${LINE_DIVIDE}"
	@echo "  Validate"
	packer validate -var-file ${JSON_DIR}/bionic/server.json ${JSON_DIR}/full.json	
	@echo "  Build"
	packer build -var-file ${JSON_DIR}/bionic/server.json ${JSON_DIR}/full.json

.PHONY: fs
fs:
	@echo "${LINE_DIVIDE}"
	@echo "  Focal Server"
	@echo "${LINE_DIVIDE}"
	@echo "  Validate"
	packer validate -var-file ${JSON_DIR}/focal/server.json ${JSON_DIR}/full.json	
	@echo "  Build"
	packer build -var-file ${JSON_DIR}/focal/server.json ${JSON_DIR}/full.json

.PHONY: complete_validate
complete_validate:
	@echo "${LINE_DIVIDE}"
	@echo "  Packer Validate All Versions & Templates"
	@echo "${LINE_DIVIDE}"
	packer validate -var-file ${JSON_DIR}/bionic/desktop.json ${JSON_DIR}/full.json
	packer validate -var-file ${JSON_DIR}/bionic/server.json ${JSON_DIR}/full.json
	packer validate -var-file ${JSON_DIR}/focal/desktop.json ${JSON_DIR}/full.json
	packer validate -var-file ${JSON_DIR}/focal/server.json ${JSON_DIR}/full.json
	packer validate -var-file ${JSON_DIR}/bionic/desktop.json ${JSON_DIR}/base.json
	packer validate -var-file ${JSON_DIR}/bionic/server.json ${JSON_DIR}/base.json
	packer validate -var-file ${JSON_DIR}/focal/desktop.json ${JSON_DIR}/base.json
	packer validate -var-file ${JSON_DIR}/focal/server.json ${JSON_DIR}/base.json