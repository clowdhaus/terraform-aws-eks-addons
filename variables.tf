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

variable "cluster_id" {
  description = "The EKS cluster ID"
  type        = string
  default     = ""
}

variable "cluster_endpoint" {
  description = "The EKS cluster endpoint"
  type        = string
  default     = ""
}

variable "cluster_oidc_provider_arn" {
  description = "The OIDC provider ARN"
  type        = string
  default     = ""
}

################################################################################
# Agones
################################################################################

variable "enable_agones" {
  description = "Controls if Agones addon is be created"
  type        = bool
  default     = false
}

variable "agones_config" {
  description = "Agones wrapper variable around Helm release configuration values"
  type        = any
  default     = {}
}

################################################################################
# Agones
################################################################################

variable "enable_karpenter" {
  description = "Controls if Karpenter addon is be created"
  type        = bool
  default     = false
}

variable "karpenter_config" {
  description = "Karpenter wrapper variable around Helm release configuration values"
  type        = any
  default     = {}
}
