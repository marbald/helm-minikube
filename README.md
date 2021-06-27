# Helm / Minikube project

This repository allows to spin up a multi-environment (prod / dev) minikube cluster. The applications deployed can be accessed from the browser and will return a customized Hello World string depending on the URL used.

The URLs configured in our code that we're going to use in our browser are

- `http://app.k8s.ppro-prod-local.com` for the prod environment, and
- `http://app.k8s.ppro-dev-local.com` for the dev environment

Beside a valid git installation, the software required needed to run the app on the host machine are

1. Docker
2. Helm
3. Minikube

### Implementation

For details about the content of this repository, please take a look at the README.md files in each sub-directory of the main folder.

## Install & configure

### Docker

First of all, download and install [Docker](https://docs.docker.com/get-docker/). This will be used locally to build the images for our Node.js app and PostgreSQL database.

Once you finish installing Docker, check its version by running the following command

```bash
> docker --version
Docker version 20.10.5, build 55c4c88
```

### Helm

Helm will be our infrastructure-as-a-code and will deploy our app in the installed minikube cluster. You can install Helm [from here](https://helm.sh/docs/intro/install/).

Once the installation is complete, you can check it by running the following command

```bash
> helm version
version.BuildInfo{Version:"v3.6.1", GitCommit:"61d8e8c4a6f95540c15c6a65f36a6dd0a45e7a2f", GitTreeState:"dirty", GoVersion:"go1.16.5"}
```

Since we're using a default Helm chart for the ingress of our minikube cluster, run the following command to let Helm add the necessary repository for our NGIX ingress

```bash
> helm repo add nginx-stable https://helm.nginx.com/stable && helm repo update
```

### Minikube

Minikube will be our cluster manager, you can install the most recent version [following this link](https://minikube.sigs.k8s.io/docs/start/).

Run the following command to verify the installation

```bash
> minikube version
minikube version: v1.21.0
commit: 76d74191d82c47883dc7e1319ef7cebd3e00ee11
```

Now we need to start our cluster and then install our ingress addon

```bash
> minikube start --vm=true
```

The `--vm-true` parameter is needed only if you are installing this on a Mackbook, [check this link](https://github.com/kubernetes/minikube/issues/7332) for further info.

Once your cluster is started, we need to install our ingress addon

```bash
> minikube addons enable ingress
```

The last thing to do is to add a new line in the local hosts file to add our minikube cluster ip with the two DNS we're going to use

```bash
echo -e "$(minikube ip)\tapp.k8s.ppro-prod-local.com app.k8s.ppro-dev-local.com" | sudo tee -a /etc/hosts
```

## Prepare

### Checkout

Run the following command to checkout the code on your local machine and to enter the folder

```bash
> git checkout https://github.com/marbald/helm-minikube.git && cd helm-minikube
```

### Add file permissions

Now we need to make our shell scripts executable by running this command

```bash
> chmod +x build-install.sh cleanup.sh
```

And we're done!

## Run

### Build and install

The `./build-install.sh` script will spin up your environment, here's an example of its execution

```bash
> ./build-install.sh

Enter the environment you want to deploy your stack, accepted values are 'prod' or 'dev' (case sensitive):
prod

Enter the database name:
myproddatabase

Enter the database user:
produsername

Enter the database password for the user 'produsername':
_hidden password_
```

After all the inputs have been provided, the script will 

- create the Docker images for our Postgres instance and our Node.js app. The images will be called `ppro/postgres-${env}` and `ppro/app-${env}` where `${env}` is the `prod` / `dev` value provided as input
- install all our components with `helm install` commands. This will create the necessary minikube configuration and will deploy our code

### Check your resources

Once the script finishes running, all the necessary resources are available in minikube. Depending on the environment you decided to deploy (`prod` / `dev`), you will find your resources in a Kubernetes `namespace` with the same name.

For example, in case of a `dev` deploy, you will have the following

```bash
> kubectl get svc --namespace=dev
NAME                                        TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
ingress-dev-nginx-ingress-controller        LoadBalancer   10.100.143.87   <pending>     80:31460/TCP,443:30022/TCP   7h21m
ingress-dev-nginx-ingress-default-backend   ClusterIP      10.103.87.78    <none>        80/TCP                       7h21m
pproapp                                     ClusterIP      10.96.92.176    <none>        3000/TCP                     7h21m
pprodb                                      ClusterIP      10.98.84.207    <none>        5432/TCP                     7h21m
```

Same applies if you want for example check the pods

```bash
> kubectl get pods --namespace=dev
NAME                                                         READY   STATUS    RESTARTS   AGE
ingress-dev-nginx-ingress-controller-5c8976cf95-c8kxt        1/1     Running   7          7h21m
ingress-dev-nginx-ingress-default-backend-6fdf86f9d7-gtmxk   1/1     Running   4          7h21m
pproapp-7d768f9c9b-v46nq                                     1/1     Running   1          7h21m
pprodb-86986c47f9-rtsm7                                      1/1     Running   1          7h22m
```

### Hello world pages

Once your resources are deployed correctly, the Hello World page is already available to be displayed. As mentioned at the beginning, the two URLs are

```bash
http://app.k8s.ppro-prod-local.com/app  >  prod deploy
http://app.k8s.ppro-dev-local.com/app   >  dev deploy
```

and opening them from a browser will return the following strings

```bash
Hello World from 'prod`' environment!
Hello World from 'dev' environment!
```

## Cleanup

The main folder also contains a cleanup script to stop / uninstall the existing Helm resources on the local minikube instance. The script looks for a bash parameter and, if not provided 

By default, the `./build-install.sh` script runs a `./cleanup ${env}` as soon as the `prod` or `dev` environment is provided as target.