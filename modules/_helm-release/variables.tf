variable "create" {
  description = "Controls if resources should be created (affects all resources)"
  type        = bool
  default     = true
}

################################################################################
# Helm Release
################################################################################

variable "name" {
  description = "Release name"
  type        = string
}

variable "namespace" {
  description = "Default namespace to use on all resources created"
  type        = string
  default     = "default"
}

variable "create_namespace" {
  description = "Controls if namespace should be created"
  type        = bool
  default     = true
}

variable "description" {
  description = "Default description to use on all resources created"
  type        = string
  default     = ""
}

variable "chart" {
  description = "Chart name to be installed. The chart name can be local path, a URL to a chart, or the name of the chart if `repository` is specified"
  type        = string
}

variable "version" {
  description = "Specify the exact chart version to install. If this is not specified, the latest version is installed"
  type        = string
  default     = null
}

variable "repository" {
  description = "Repository URL where to locate the requested chart"
  type        = string
  default     = null
}

variable "values" {
  description = "Default values to use on all resources created"
  type        = string
  default     = ""
}

variable "release_config" {
  description = "Default release config to use on all resources created"
  type        = string
  default     = ""
}
