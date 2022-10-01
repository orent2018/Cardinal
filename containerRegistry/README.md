Manifests for building private container registry in registry namespace
-----------------------------------------------------------------------

Create a dedicated namespace called registry:

    > kubectl create namespace registry
    
Use openssl to create a (self signed) private key and certificate for the registry service:

    > openssl req -x509 -newkey rsa:4096 -days 365 -nodes -sha256 -keyout certs/tls.key -out certs/tls.crt
   
Uses a secret built from the private key and certificate created:

    > kubectl create secret tls certs-secret --cert=certs/tls.crt --key=certs/tls.key -n registry

1) Create PV and PVC for images.

2) Create deployment that uses the PV created above, the secret containing the regsitry private key and certificate and using the registry image from dockerhub.

3) Create a loadbalancer service to allow access to the private docker registry

The created service:

    > kubectl get service -n registry
    
    NAME                TYPE           CLUSTER-IP      EXTERNAL-IP                                                               PORT(S)          AGE
    cardinal-registry   LoadBalancer   172.20.181.17   a8df898d9439d47f192b12f0fd82561c-1015703581.eu-west-3.elb.amazonaws.com   5000:32757/TCP   9s
    
The external IP of the docker regsitry is: 

    > nslookup a8df898d9439d47f192b12f0fd82561c-1015703581.eu-west-3.elb.amazonaws.com
    
    Non-authoritative answer:
    Server:  Box.Home
    Address:  fe80::16ae:dbff:fecf:4888
    
    Name:    a8df898d9439d47f192b12f0fd82561c-1015703581.eu-west-3.elb.amazonaws.com
    Address:  15.237.15.239
    
    
Additional steps to be carried out
----------------------------------
    
    1) The ceritificate for the registry needs to be copied to all the nodes or made available through a daemonset.
    
    2) Authentication needs to be added to the registry to restrict access to it at least through the use of user and passwd (e.g. htpasswd).
