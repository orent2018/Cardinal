Manifests for building private container registry in registry namespace
-----------------------------------------------------------------------

Use openssl to create a private key and certificate for the registry service:

    > openssl req -x509 -newkey rsa:4096 -days 365 -nodes -sha256 -keyout certs/tls.key -out certs/tls.crt
   
Uses a secret built from the private key and certificate created:

   > kubectl create secret tls certs-secret --cert=certs/tls.crt --key=certs/tls.key

1) Create PV and PVC for images.

2) Create deployment that uses the PV created above, the secret containing the regsitry private key and certificate and using the registry image from dockerhub.

3) Create a service to allow access to the private docker registry
