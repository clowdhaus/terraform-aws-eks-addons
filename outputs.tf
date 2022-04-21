output "agones_helm_release" {
  description = "Agones helm chart release attributes"
  value       = var.enable_agones ? module.agones : null
}

output "karpenter_helm_release" {
  description = "Karpenter helm chart release attributes"
  value       = var.enable_karpenter ? module.karpenter : null
}
