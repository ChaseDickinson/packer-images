# --------------------------------------------------------------------------------
# Define variables
# --------------------------------------------------------------------------------
variable "boot_command" {
  default     = null
  description = "Command to start the installation"
  type        = string
}

variable "files" {
  default     = "../../files"
  description = "Relative directory for files to be loaded to image"
  type        = string
}

variable "iso_checksum" {
  default     = null
  description = "Expected checksum of downloaded image"
  type        = string
}

variable "os_name" {
  default     = null
  description = "Nickname of Ubuntu version"
  type        = string
}

variable "os_type" {
  default     = "desktop"
  description = "Type of OS; eitehr desktop or server"
  type        = string
}

variable "os_version" {
  default     = null
  description = "Ubuntu version number"
  type        = string
}

variable "scripts" {
  default     = "../../scripts"
  description = "Relative directory for scripts to be run on image"
  type        = string
}

variable "ssh_username" {
  default     = "ubuntu"
  description = "Default username to be created"
  type        = string
}

variable "ssh_password" {
  default     = "ubuntu"
  description = "Default password to be created"
  type        = string
}
