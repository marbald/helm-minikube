# Helm / Minikube project

## Overview
This folder contains the Docker definition of our Node.js application and PostgreSQL database.

## Node.js

### Node.js app

The app itself is available in this small [Node.js script](https://github.com/marbald/helm-minikube/blob/master/docker/app/app.js): when the pod is started, the app starts listening on the port `3000` for `HTTP GET` in the `/app` context.

### Dockerfile

The [Dockerfile](https://github.com/marbald/helm-minikube/blob/master/docker/app/Dockerfile) is built on top of an `alpine` image available on DockerHub and builds the app when the `docker build` command is executed (via the `./build-install.sh` script).

## PostgreSQL

### Database scripts

The database creation is done across two different files

- `docker-entrypoint.sh`
- `setup.sql`

The first one sets up the PostgreSQL filesystem preparing the instance, creates the database and assigns the ownership to the psql account that has been provided via `.build-install.sh` script.

Then, it runs the `setup.sql` script to populate our database with data.

### Dockerfile

The [Dockerfile](https://github.com/marbald/helm-minikube/blob/master/docker/database/Dockerfile) runs basic operation on the filesystem (folder creation, files copy). 

The `ENTRYPOINT` instruction calls the `docker-entrypoint.sh` in order to execute the script only when the container is actually created and not when the image is built.