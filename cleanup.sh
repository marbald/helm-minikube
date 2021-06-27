#!/bin/bash

# read first parameter - build.sh scenario
envs_to_clean=$1

# if parameter is empty, then treat all envs
if [ -z "$envs_to_clean" ];
then
	envs_to_clean="prod,dev"
fi

# loop and uninstall env
for env in ${envs_to_clean//,/ }
do
	echo "" && echo "	- Helm '$env' environment is being cleaned up..."

	helm uninstall --namespace=$env ingress-$env &>/dev/null
	helm uninstall --namespace=$env pprodb-$env &>/dev/null
	helm uninstall --namespace=$env pproapp-$env &>/dev/null
	
	echo "	- Helm '$env' environment has been cleaned up..."
	echo ""
done
