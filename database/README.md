# Helm / Minikube project - "database" directory

## Overview
This folder contains the necessary Helm configuration to deploy our instance of a PostgreSQL database. The database definition itself is available in the [/docker](https://github.com/marbald/helm-minikube/tree/master/docker) folder.

The configuration is pretty much standard: there are two main "Values" files

- `values-prod.yaml`
- `values-dev.yaml`

that define the main (and only) difference between the two versions of the database instance in the parameters `pprodb.namespace` and `pprodb.container.image`

The rest of the files available describe the core definition of our Kubernetes deploy.