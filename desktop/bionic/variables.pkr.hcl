# Variables for bionic desktop image

locals {
    home         = "/home/${var.ssh_username}"
    iso_checksum = "add4614b6fe3bb8e7dddcaab0ea97c476fbd4ffe288f2a4912cb06f1a47dcfa0"
    os_name      = "bionic"
    os_type      = "desktop"
    os_version   = "18.04.3"
}

variable "files" {
  description = "Directory where files to be loaded to VM are stored"
  type        = "string"
  default     = "../../files"
}

variable "home" {
  description = "Path of the home directory on the VM"
  type        = "string"
}

variable "scripts" {
  description = "Directory where configuration scripts are stored"
  type        = "string"
  default     = "../../scripts"
}

variable "ssh_username" {
  description = "Username for account to be created"
  type        = "string"
  default     = "ubuntu"
}

variable "ssh_password" {
  description = "Initial password for account to be created"
  type        = "string"
  default     = "ubuntu"
}
