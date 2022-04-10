output "chart" {
  description = "The name of the chart"
  value       = try(helm_release.this[0].metadata[0].chart, null)
}

output "name" {
  description = "Name is the name of the release"
  value       = try(helm_release.this[0].metadata[0].name, null)
}

output "namespace" {
  description = "Namespace is the kubernetes namespace of the release"
  value       = try(helm_release.this[0].metadata[0].namespace, null)
}

output "revision" {
  description = "Version is an int32 which represents the version of the release"
  value       = try(helm_release.this[0].metadata[0].revision, null)
}

# output "status" {
#   description = "Status of the release"
#   value       = try(helm_release.this[0].metadata[0].status, null)
# }

output "version" {
  description = "A SemVer 2 conformant version string of the chart"
  value       = try(helm_release.this[0].metadata[0].version, null)
}

output "app_version" {
  description = "The version number of the application being deployed"
  value       = try(helm_release.this[0].metadata[0].app_version, null)
}

output "values" {
  description = "The compounded values from `values` and `set*` attributes"
  value       = try(helm_release.this[0].metadata[0].values, null)
}
