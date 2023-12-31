output "vpc_id" {
  value = module.k8s_vpc.vpc_id
}
output "Subnet_ip" {
  value = [module.k8s_public_subnet[*].public_ip]
  
}
output "eks_endpoint" {
  value = module.eks_cluster.eks_cluster_endpoint
}
output "db_address" {
  value = module.db_server.db_address
  
}
output "db_endpoint" {
  value = module.db_server.db_endpoint
}