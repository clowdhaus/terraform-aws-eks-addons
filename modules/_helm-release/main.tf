################################################################################
# Helm Release
################################################################################

resource "helm_release" "this" {
  count = var.create ? 1 : 0

  name             = var.config.name
  namespace        = var.config.namespace
  create_namespace = try(var.config.create_namespace, true)
  description      = try(var.config.description, null)
  chart            = var.config.chart
  version          = try(var.config.version, null)
  repository       = var.config.repository
  values           = try(var.config.values, [])

  timeout                    = try(var.config.timeout, 1200)
  repository_key_file        = try(var.config.repository_key_file, null)
  repository_cert_file       = try(var.config.repository_cert_file, null)
  repository_ca_file         = try(var.config.repository_ca_file, null)
  repository_username        = try(var.config.repository_username, null)
  repository_password        = try(var.config.repository_password, null)
  devel                      = try(var.config.devel, null)
  verify                     = try(var.config.verify, null)
  keyring                    = try(var.config.keyring, null)
  disable_webhooks           = try(var.config.disable_webhooks, null)
  reuse_values               = try(var.config.reuse_values, null)
  reset_values               = try(var.config.reset_values, null)
  force_update               = try(var.config.force_update, null)
  recreate_pods              = try(var.config.recreate_pods, null)
  cleanup_on_fail            = try(var.config.cleanup_on_fail, null)
  max_history                = try(var.config.max_history, null)
  atomic                     = try(var.config.atomic, null)
  skip_crds                  = try(var.config.skip_crds, null)
  render_subchart_notes      = try(var.config.render_subchart_notes, null)
  disable_openapi_validation = try(var.config.disable_openapi_validation, null)
  wait                       = try(var.config.wait, null)
  wait_for_jobs              = try(var.config.wait_for_jobs, null)
  dependency_update          = try(var.config.dependency_update, null)
  replace                    = try(var.config.replace, null)
  lint                       = try(var.config.lint, null)

  dynamic "postrender" {
    for_each = can(var.config.postrender_binary_path) ? [1] : []

    content {
      binary_path = var.config.postrender_binary_path
    }
  }

  dynamic "set" {
    for_each = try(var.config.set, {})

    content {
      name  = set.value.name
      value = set.value.value
      type  = try(set.value.type, null)
    }
  }

  dynamic "set_sensitive" {
    for_each = try(var.config.set_sensitive, {})

    content {
      name  = set_sensitive.value.name
      value = set_sensitive.value.value
      type  = try(set_sensitive.value.type, null)
    }
  }
}
