#!/bin/bash

# Appliquer le namespace d'abord
kubectl apply -f output/k8s/namespace.yaml

# Appliquer le reste des manifests
kubectl apply -f output/k8s/networkpolicy.yaml
kubectl apply -f output/k8s/service.yaml
kubectl apply -f output/k8s/deployment.yaml

