output "eks_vpc_id" {
    value       = data.aws_vpc.cluster_vpc.id
}

output "eks_subnet_ids" {
    value       = data.aws_subnet_ids.cluster_subnet_ids.ids
}

output "endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}