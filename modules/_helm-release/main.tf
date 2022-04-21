locals {
  create_namespace = var.create && try(var.config.create_namespace, true)
  namespace        = local.create_namespace ? kubernetes_namespace_v1.this[0].metadata[0].name : try(var.config.namespace.name, null)

  create_service_account = var.create && try(var.config.create_service_account, false)
  service_account        = local.create_service_account ? kubernetes_service_account_v1.this[0].metadata[0].name : try(var.config.service_account.name, null)
}

################################################################################
# Helm Release
################################################################################

resource "helm_release" "this" {
  count = var.create ? 1 : 0

  name             = var.config.name
  namespace        = local.namespace
  create_namespace = false # creating below with K8s namespace resource
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
    for_each = try(var.config.set, [])

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

################################################################################
# Namespace
################################################################################

resource "kubernetes_namespace_v1" "this" {
  count = var.create && local.create_namespace ? 1 : 0

  metadata {
    name        = var.config.namespace.name
    labels      = try(var.config.namespace.labels, null)
    annotations = try(var.config.namespace.annotations, null)
  }

  timeouts {
    delete = try(var.config.namespace.timeouts.delete, null)
  }
}

################################################################################
# Service Account
################################################################################

resource "kubernetes_service_account_v1" "this" {
  count = var.create && local.create_service_account ? 1 : 0

  automount_service_account_token = try(var.config.automount_service_account_token, false)

  metadata {
    name        = var.config.service_account.name
    namespace   = local.namespace
    annotations = try(var.config.service_account.annotations, null)
    labels      = try(var.config.service_account.labels, null)
  }

  dynamic "image_pull_secret" {
    for_each = try(var.config.service_account.image_pull_secret, [])

    content {
      name = try(image_pull_secret.value.name, null)
    }
  }

  dynamic "secret" {
    for_each = try(var.config.service_account.secret, [])

    content {
      name = try(secret.value.name, null)
    }
  }
}
