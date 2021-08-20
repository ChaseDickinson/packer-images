####################################
# Packer Builds by @Okie_Chase
####################################

# Macros
BUILD_ARGS:=-color=false
LINE_DIVIDE=************************************************************
SHELL:=/bin/bash
TEMPLATE_DIR:=./templates/desktop/ubuntu/
TIMESTAMP:=$(shell /bin/date "+%y%m%d%H%M")

# Enable Packer Logging
PACKER_LOG:=1
PACKER_LOG_PATH:=./logs/${TIMESTAMP}_ubuntu_desktop.log
export PACKER_LOG PACKER_LOG_PATH

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

.PHONY: pba
pba:
	@echo "${LINE_DIVIDE}"
	@echo "  Packer Validate"
	@echo "${LINE_DIVIDE}"
	packer validate ${TEMPLATE_DIR}
	@echo "${LINE_DIVIDE}"
	@echo "  Packer Build - All"
	@echo "${LINE_DIVIDE}"
	packer build ${BUILD_ARGS} ${TEMPLATE_DIR}

.PHONY: pbb
pbb:
	@echo "${LINE_DIVIDE}"
	@echo "  Packer Validate"
	@echo "${LINE_DIVIDE}"
	packer validate ${TEMPLATE_DIR}
	@echo "${LINE_DIVIDE}"
	@echo "  Packer Build - Base"
	@echo "${LINE_DIVIDE}"
	packer build -only=virtualbox-iso.base ${BUILD_ARGS} ${TEMPLATE_DIR}

.PHONY: pbf
pbf:
	@echo "${LINE_DIVIDE}"
	@echo "  Packer Validate"
	@echo "${LINE_DIVIDE}"
	packer validate ${TEMPLATE_DIR}
	@echo "${LINE_DIVIDE}"
	@echo "  Packer Build - Full"
	@echo "${LINE_DIVIDE}"
	packer build -only=virtualbox-iso.full ${BUILD_ARGS} ${TEMPLATE_DIR}