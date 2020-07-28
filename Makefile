####################################
# Packer Builds by @Okie_Chase
####################################

# Macros
# JSON template path
# JSON variable path

# Phony rules
# validate single template -> packer validate -var-file .\focal\desktop.json .\full.json -> make validate focal desktop full
# build single template -> packer build -var-file .\bionic\server.json .\adds.json -> make build bionic server adds