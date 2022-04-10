variable "create" {
  description = "Controls if resources should be created (affects all resources)"
  type        = bool
  default     = true
}

variable "node_security_group_id" {
  description = "The node group security group ID. Used to provided addtional security group rules when required by addon enabled"
  type        = string
  default     = null
}

################################################################################
# Agones
################################################################################

variable "enable_agones" {
  description = "Controls if Agones addon should be created"
  type        = bool
  default     = false
}

variable "agones_config" {
  description = "Agones wrapper variable around Helm release configuration values"
  type        = any
  default     = {}
}
