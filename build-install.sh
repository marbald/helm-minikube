#!/bin/bash

# use the docker env in minikube
eval $(minikube docker-env)

# set up app names
DB_NAME=pprodb
APP_NAME=pproapp

# read vars
echo "" && echo "Enter the environment you want to deploy your stack, accepted values are 'prod' or 'dev' (case sensitive):";
read HELM_NAMESPACE

while [[ "${HELM_NAMESPACE}" != "prod" ]] && [[ "${HELM_NAMESPACE}" != "dev" ]]
do
	echo "	- '${HELM_NAMESPACE}' is not a valid value, accepted values are 'prod' or 'dev' (case sensitive):";
	read HELM_NAMESPACE
done

# cleanup
./cleanup.sh ${HELM_NAMESPACE}

# read params
echo && echo "Enter the database name:";
read PG_DB

echo && echo "Enter the database user:";
read PG_USER

echo && echo "Enter the database password:";
read -s PG_PASS


# build database image
docker build docker/database/ \
		--build-arg PG_DB_VAR=$PG_DB --build-arg PG_USER_VAR=$PG_USER --build-arg PG_PASS_VAR=$PG_PASS --build-arg PG_ENV_VAR=$HELM_NAMESPACE \
		-t ppro/postgres-$HELM_NAMESPACE

# build node.js app image
docker build docker/app/ \
		--build-arg PGHOST_VAR=$DB_NAME --build-arg PG_DB_VAR=$PG_DB --build-arg PG_USER_VAR=$PG_USER --build-arg PG_PASS_VAR=$PG_PASS --build-arg PGPORT_VAR=5432 \
		-t ppro/app-$HELM_NAMESPACE


# helm install database
helm install --create-namespace=true --namespace=${HELM_NAMESPACE} \
	-f database/values-${HELM_NAMESPACE}.yaml $DB_NAME-${HELM_NAMESPACE} ./database

# helm install node.js app
helm install --create-namespace=true  --namespace=${HELM_NAMESPACE} \
	-f app/values-${HELM_NAMESPACE}.yaml $APP_NAME-${HELM_NAMESPACE} ./app

# helm install ingress
helm install --create-namespace=true  --namespace=${HELM_NAMESPACE} \
	-f ingress/values-${HELM_NAMESPACE}.yaml ingress-${HELM_NAMESPACE} ./ingress

