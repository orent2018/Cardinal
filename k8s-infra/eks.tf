locals {
  cluster_name = "Cardinal-EKS"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.2.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.21"

  subnet_ids      = aws_subnet.CardinalPrvSubnet.id
  vpc_id          = aws_vpc.CardinalVPC.id

  node_groups = {
    first = {
      desired_capacity = 2
      max_capacity     = 4
      min_capacity     = 2

      instance_type = "t2.small"
    }
  }

  write_kubeconfig   = true
  config_output_path = "./"
}
