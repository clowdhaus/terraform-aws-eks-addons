output "agones_helm_release" {
  description = "Agones helm chart release attributes"
  value       = module.eks_addons.agones_helm_release
}

output "karpenter_helm_release" {
  description = "Karpenter helm chart release attributes"
  value       = module.eks_addons.karpenter_helm_release
}
