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

.PHONY: pbf
pbf: export PACKER_LOG=1
pbf: export PACKER_LOG_PATH="${LOG_PATH}"
pbf:
	@echo "${LINE_DIVIDE}"
	@echo "  Setting up build environment"
	touch "${PACKER_LOG_PATH}"
	ls -lh ./logs
	@echo "  PACKER_LOG_PATH set to "${PACKER_LOG_PATH}""
	@echo "${LINE_DIVIDE}"
	@echo "${LINE_DIVIDE}"
	@echo "  Packer Validate"
	@echo "${LINE_DIVIDE}"
	packer validate ${TEMPLATE_DIR}
	@echo "${LINE_DIVIDE}"
	@echo "  Packer Build"
	@echo "${LINE_DIVIDE}"
	packer build -only=virtualbox-iso.full ${TEMPLATE_DIR}

.PHONY: pbb
pbb: export PACKER_LOG=1
pbb: export PACKER_LOG_PATH="${LOG_PATH}"
pbb:
	@echo "${LINE_DIVIDE}"
	@echo "  Packer Validate"
	@echo "${LINE_DIVIDE}"
	packer validate ${TEMPLATE_DIR}
	@echo "${LINE_DIVIDE}"
	@echo "  Packer Build"
	@echo "${LINE_DIVIDE}"
	packer build -only=virtualbox-iso.base ${TEMPLATE_DIR}