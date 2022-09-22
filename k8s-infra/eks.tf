locals {
  cluster_name = "Cardinal-EKS"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.2.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.21"

  subnet_ids = [aws_subnet.CardinalPrvSubnet.id]
  vpc_id     = aws_vpc.CardinalVPC.id
  eks_managed_node_groups = {
    min_size     = 2
    max_size     = 4
    desired_size = 2

    instance_types = ["t2.small"]
    labels = {
      Environment = "Demo"
    }
    tags = {
      ExtraTag = "CardinalDemoWorkers"
    }
  }
}

# Output the Cluster endpoint and certificate
  
output "endpoint" {
  value = module.eks.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = module.eks.certificate_authority[0].data
}
