locals {
  cluster_name = "Cardinal-EKS"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.2.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.21"

  subnet_ids = [aws_subnet.CardinalPrvSubnet1.id, aws_subnet.CardinalPrvSubnet2.id]
  vpc_id     = aws_vpc.CardinalVPC.id
  eks_managed_node_groups = {
    main = {
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
}

# Define the data sources

data "aws_eks_cluster" "CardinalEKS" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "CardinalEKS" {
  name = module.eks.cluster_id
}


# Output the Cluster endpoint and certificate

output "endpoint" {
  value = data.aws_eks_cluster.CardinalEKS.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = data.aws_eks_cluster.CardinalEKS.certificate_authority[0].data
}

#output "eks-cluster-token" {
#  value = base64decode(data.aws_eks_cluster_auth.CardinalEKS.token)
#}
