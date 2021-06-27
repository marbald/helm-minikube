# Helm / Minikube project - "ingress" directory

## Overview
This folder contains the necessary Helm configuration to deploy our NGINX ingress. The proxy itself is available via a Helm-referenced Docker image and deployed directly by Helm.

The configuration is pretty much standard: there are two main "Values files

- `values-prod.yaml`
- `values-dev.yaml`

that define the main (and only) difference between the two versions of the ingress in the parameters `ingress.namespace` and `ingress.hosts.host`

This last section in particular, defines the entry point for our web page.