# Cardinal
EKS and container registry
--------------------------

In order to create the infrastructure for the EKS cluster a github actions workflow has been created that is configured to run the terraform files under k8s-infra
directory. Due to lack of access to S3 the intended backend has been disabled and the terraform files have been run manually from the command line.

The infrastructure created consists of a VPC which has 2 private subnets in 2 different AZs and one public subnet. It includes that NAT GW in the private subnets, 
the Internet GW in the public subnet and routing to allow outgoing access to the nodes in the private subnet.

The EKS cluster with k8s version 1.21 has been created using the terraform eks module. It has the public access endpoint enabled to allow external interactions with the cluster.  It has 2 worker nodes one in each of the 2 private subnets.

The cluster is named Cardinal-EKS:

    > kubectl cluster-info

Kubernetes control plane is running at https://FA4A671FB6E29E678BC0313AEE968B3E.gr7.eu-west-3.eks.amazonaws.com
CoreDNS is running at https://FA4A671FB6E29E678BC0313AEE968B3E.gr7.eu-west-3.eks.amazonaws.com/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy


The external ip of the cluster/API server:
    >  nslookup FA4A671FB6E29E678BC0313AEE968B3E.gr7.eu-west-3.eks.amazonaws.com

Non-authoritative answer:

Server:  Box.Home
Address:  fe80::16ae:dbff:fecf:4888

Name:    FA4A671FB6E29E678BC0313AEE968B3E.gr7.eu-west-3.eks.amazonaws.com

Addresses:  13.36.31.169
          13.39.40.135
          

    > kubectl get nodes -o wide

NAME                                      STATUS   ROLES    AGE     VERSION                INTERNAL-IP   EXTERNAL-IP   OS-IMAGE         KERNEL-VERSION CONTAINER-RUNTIME

ip-10-0-1-88.eu-west-3.compute.internal   Ready    <none>   2d15h   v1.21.14-eks-ba74326   10.0.1.88     <none>        Amazon Linux 2   5.4.209-116.367.amzn2.x86_64   docker://20.10.17
          
ip-10-0-2-13.eu-west-3.compute.internal   Ready    <none>   2d15h   v1.21.14-eks-ba74326   10.0.2.13     <none>        Amazon Linux 2   5.4.209-116.367.amzn2.x86_64   docker://20.10.17
  
Container Regsitry
------------------

  The container registry was installed as a deployment exposed out by a loadbalancer service. The details are to be found in the README under the containerRegistry directory.
  
