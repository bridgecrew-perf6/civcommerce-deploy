#!/bin/bash
# prerequisite for this script to run properly are 
#  - KUBECTL commandLine tool to access kubernetes cluster (more info on https://kubernetes.io/docs/tasks/tools/)
#  - HELM package manager for kubernetes (more info on https://helm.sh/docs/intro/install/)
#  - GIT version control (brew install install/ apt install git)

# usage info: sh deploy.sh -c <kube-config file dir>

while getopts c: flag
do
    case "${flag}" in
        c) config=${OPTARG};;
    esac
done

echo "kubernetes confg recieved: $config"
echo "retrieve infrastructure information..."
git clone git@github.com:civitops/civcommerce-deploy.git
echo "cloned repository successful..."
echo "applying infra changes ..."

# create namespace
kubectl create namespace ingress --kubeconfig $config

# adding nginx ingress controller using helm
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx && helm repo update

# installing nginx ingress controller
helm install nginx-ingress ingress-nginx/ingress-nginx \
     --namespace ingress \
     --set controller.replicaCount=2 \
     --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
     --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux

# create the api deployment and ingress service 
kubectl apply -f civcommerce-deploy/backend.yml --namespace --kubeconfig $config
kubectl apply -f civcommerce-deploy/ingress.yml --namespace ingress --kubeconfig $config