variable "create" {
  description = "Controls if resources should be created (affects all resources)"
  type        = bool
  default     = true
}

################################################################################
# Helm Release
################################################################################

variable "config" {
  description = "Wrapper variable around Helm release configuration values to allow upstream use of module to define only one variable per release"
  type        = any
  default     = {}
}
