locals {
  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${module.eks.endpoint}
    certificate-authority-data: ${module.eks.certificate_authority[0].data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${data.aws_eks_cluster.CardinalDemo.name}"
KUBECONFIG
}

output "kubeconfig" {
  value = local.kubeconfig
}
