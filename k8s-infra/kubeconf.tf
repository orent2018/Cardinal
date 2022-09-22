locals {
  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${data.aws_eks_cluster.CardinalDemo.endpoint}
    certificate-authority-data: ${data.aws_eks_cluster.CardinalDemo.certificate_authority[0].data}
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
