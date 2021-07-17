####################################
# Packer Builds by @Okie_Chase
####################################

# Macros
LINE_DIVIDE=************************************************************
SHELL:=/bin/bash
TEMPLATE_DIR:=./packer_templates/desktop/ubuntu/
TIMESTAMP:=$(shell /bin/date "+%y%m%d%H%M")
LOG_PATH:=./logs/${TIMESTAMP}_ubuntu_desktop.txt

# Phony rules
.PHONY: pfmt
pfmt:
	@echo "${LINE_DIVIDE}"
	@echo "  Packer Format"
	@echo "${LINE_DIVIDE}"
	packer fmt ${TEMPLATE_DIR}

.PHONY: pv
pv:
	@echo "${LINE_DIVIDE}"
	@echo "  Packer Validate"
	@echo "${LINE_DIVIDE}"
	packer validate ${TEMPLATE_DIR}

.PHONY: pb
pb: export PACKER_LOG=1
pb: export PACKER_LOG_PATH="${LOG_PATH}"
pb:
	@echo "${LINE_DIVIDE}"
	@echo "  Packer Validate"
	@echo "${LINE_DIVIDE}"
	packer validate ${TEMPLATE_DIR}
	@echo "${LINE_DIVIDE}"
	@echo "  Packer Build"
	@echo "${LINE_DIVIDE}"
	packer build ${TEMPLATE_DIR}