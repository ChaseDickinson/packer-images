####################################
# Packer Builds by @Okie_Chase
####################################

# Macros
LINE_DIVIDE=************************************************************
HCL_DIR:=./HCL
JSON_DIR:=./JSON
OS_NAME?=focal
OS_TYPE?=desktop
IMAGE?=full
RUN=${OS_NAME}_${OS_TYPE}_${IMAGE}

# Phony rules
.PHONY: all
all: validate build

.PHONY: validate
validate:
	@echo "${LINE_DIVIDE}"
	@echo "  Packer Validate - ${RUN}"
	@echo "${LINE_DIVIDE}"
	packer validate -var-file ${JSON_DIR}/${OS_NAME}/${OS_TYPE}.json ${JSON_DIR}/${IMAGE}.json

.PHONY: build
build:
	@echo "${LINE_DIVIDE}"
	@echo "  Packer Build - ${RUN}"
	@echo "${LINE_DIVIDE}"
	packer build -var-file ${JSON_DIR}/${OS_NAME}/${OS_TYPE}.json ${JSON_DIR}/${IMAGE}.json
