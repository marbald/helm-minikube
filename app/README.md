# Helm / Minikube project - "app" directory

## Overview
This folder contains the necessary Helm configuration to deploy our Node.js app. The app definition itself is available in the [/docker](https://github.com/marbald/helm-minikube/tree/master/docker) folder.

The configuration is pretty much standard: there are two main "Values" files

- `values-prod.yaml`
- `values-dev.yaml`

that define the main (and only) difference between the two versions of the app in the parameters `pproapp.namespace` and `pproapp.container.image`

The rest of the files available describe the core definition of our Kubernetes deploy.