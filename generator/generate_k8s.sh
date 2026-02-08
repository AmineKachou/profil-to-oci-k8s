#!/bin/bash
set -e

PROFILE=$1
OUTPUT_DIR="output/k8s"
mkdir -p $OUTPUT_DIR

# Extraction des valeurs depuis le YAML
APP_NAME=$(yq e '.profile_id' $PROFILE)
NAMESPACE=$APP_NAME
IMAGE="ghcr.io/aminekachou/$APP_NAME:debian12-v1"
PORT=$(yq e '.network.ingress[0].ports[0].port' $PROFILE)
REPLICAS=1
IMAGE_SECRET="ghcr-secret"   # Nom du secret que tu as créé pour GHCR

# Namespace
cat > $OUTPUT_DIR/namespace.yaml <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NAMESPACE
EOF

# Deployment avec imagePullSecrets
cat > $OUTPUT_DIR/deployment.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $APP_NAME
  namespace: $NAMESPACE
spec:
  replicas: $REPLICAS
  selector:
    matchLabels:
      app: $APP_NAME
  template:
    metadata:
      labels:
        app: $APP_NAME
    spec:
      imagePullSecrets:
        - name: $IMAGE_SECRET
      containers:
        - name: nginx
          image: $IMAGE
          ports:
            - containerPort: $PORT
EOF

# Service
cat > $OUTPUT_DIR/service.yaml <<EOF
apiVersion: v1
kind: Service
metadata:
  name: $APP_NAME
  namespace: $NAMESPACE
spec:
  selector:
    app: $APP_NAME
  ports:
    - protocol: TCP
      port: $PORT
      targetPort: $PORT
EOF
# NetworkPolicies
cat > $OUTPUT_DIR/networkpolicy.yaml <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all-ingress
  namespace: $NAMESPACE
spec:
  podSelector:
    matchLabels:
      app: $APP_NAME
  policyTypes:
    - Ingress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-http
  namespace: $NAMESPACE
spec:
  podSelector:
    matchLabels:
      app: $APP_NAME
  ingress:
    - from:
        - namespaceSelector:
            matchLabels:
              role: ingress
      ports:
        - protocol: TCP
          port: $PORT
EOF

echo "Manifests Kubernetes générés dans $OUTPUT_DIR avec imagePullSecrets"
