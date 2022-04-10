################################################################################
# Helm Release
################################################################################

resource "helm_release" "this" {
  count = var.create ? 1 : 0

  name                       = var.name
  namespace                  = var.namespace
  create_namespace           = try(var.release_config.create_namespace, true)
  description                = var.description
  chart                      = var.chart
  version                    = var.version
  repository                 = var.repository
  values                     = var.values
  timeout                    = try(var.release_config.timeout, 1200)
  repository_key_file        = try(var.release_config.repository_key_file, null)
  repository_cert_file       = try(var.release_config.repository_cert_file, null)
  repository_ca_file         = try(var.release_config.repository_ca_file, null)
  repository_username        = try(var.release_config.repository_username, null)
  repository_password        = try(var.release_config.repository_password, null)
  devel                      = try(var.release_config.devel, null)
  verify                     = try(var.release_config.verify, null)
  keyring                    = try(var.release_config.keyring, null)
  disable_webhooks           = try(var.release_config.disable_webhooks, null)
  reuse_values               = try(var.release_config.reuse_values, null)
  reset_values               = try(var.release_config.reset_values, null)
  force_update               = try(var.release_config.force_update, null)
  recreate_pods              = try(var.release_config.recreate_pods, null)
  cleanup_on_fail            = try(var.release_config.cleanup_on_fail, null)
  max_history                = try(var.release_config.max_history, null)
  atomic                     = try(var.release_config.atomic, null)
  skip_crds                  = try(var.release_config.skip_crds, null)
  render_subchart_notes      = try(var.release_config.render_subchart_notes, null)
  disable_openapi_validation = try(var.release_config.disable_openapi_validation, null)
  wait                       = try(var.release_config.wait, null)
  wait_for_jobs              = try(var.release_config.wait_for_jobs, null)
  dependency_update          = try(var.release_config.dependency_update, null)
  replace                    = try(var.release_config.replace, null)
  lint                       = try(var.release_config.lint, null)

  dynamic "postrender" {
    for_each = can(var.release_config.postrender_binary_path) ? [1] : []

    content {
      binary_path = var.release_config.postrender_binary_path
    }
  }

  dynamic "set" {
    for_each = try(var.release_config.set, {})

    content {
      name  = set.value.name
      value = set.value.value
      type  = try(set.value.type, null)
    }
  }

  dynamic "set_sensitive" {
    for_each = try(var.release_config.set_sensitive, {})

    content {
      name  = set_sensitive.value.name
      value = set_sensitive.value.value
      type  = try(set_sensitive.value.type, null)
    }
  }
}
