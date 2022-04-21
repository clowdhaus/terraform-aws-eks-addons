################################################################################
# Helm Release
################################################################################

resource "helm_release" "this" {
  count = var.create ? 1 : 0

  name             = var.release.name
  namespace        = try(var.release.namespace, null)
  create_namespace = try(var.release.create_namespace, true)
  description      = try(var.release.description, null)
  chart            = var.release.chart
  version          = try(var.release.version, null)
  repository       = var.release.repository
  values           = try(var.release.values, [])

  timeout                    = try(var.release.timeout, 1200)
  repository_key_file        = try(var.release.repository_key_file, null)
  repository_cert_file       = try(var.release.repository_cert_file, null)
  repository_ca_file         = try(var.release.repository_ca_file, null)
  repository_username        = try(var.release.repository_username, null)
  repository_password        = try(var.release.repository_password, null)
  devel                      = try(var.release.devel, null)
  verify                     = try(var.release.verify, null)
  keyring                    = try(var.release.keyring, null)
  disable_webhooks           = try(var.release.disable_webhooks, null)
  reuse_values               = try(var.release.reuse_values, null)
  reset_values               = try(var.release.reset_values, null)
  force_update               = try(var.release.force_update, null)
  recreate_pods              = try(var.release.recreate_pods, null)
  cleanup_on_fail            = try(var.release.cleanup_on_fail, null)
  max_history                = try(var.release.max_history, null)
  atomic                     = try(var.release.atomic, null)
  skip_crds                  = try(var.release.skip_crds, null)
  render_subchart_notes      = try(var.release.render_subchart_notes, null)
  disable_openapi_validation = try(var.release.disable_openapi_validation, null)
  wait                       = try(var.release.wait, null)
  wait_for_jobs              = try(var.release.wait_for_jobs, null)
  dependency_update          = try(var.release.dependency_update, null)
  replace                    = try(var.release.replace, null)
  lint                       = try(var.release.lint, null)

  dynamic "postrender" {
    for_each = can(var.release.postrender_binary_path) ? [1] : []

    content {
      binary_path = var.release.postrender_binary_path
    }
  }

  dynamic "set" {
    for_each = try(var.release.set, [])

    content {
      name  = set.value.name
      value = set.value.value
      type  = try(set.value.type, null)
    }
  }

  dynamic "set_sensitive" {
    for_each = try(var.release.set_sensitive, {})

    content {
      name  = set_sensitive.value.name
      value = set_sensitive.value.value
      type  = try(set_sensitive.value.type, null)
    }
  }
}
