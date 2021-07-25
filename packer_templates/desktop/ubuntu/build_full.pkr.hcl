########################################
# Builds
########################################
build {
  sources = [
    "source.virtualbox-iso.base"
  ]

  post-processor "vagrant" {
    keep_input_artifact = false
    output              = "${local.artifact_directory}/${source.type}_${source.name}_${local.timestamp}.box"
  }
}