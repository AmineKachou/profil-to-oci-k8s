
Générateur Profil → Image OCI + Déploiement Kubernetes + NetworkPolicies (L3/L4)

=========================================================================

Description :

Ce projet permet de générer automatiquement :

- Une image Docker (OCI) à partir d'un profil YAML/JSON contenant la distribution et les logiciels à installer.
- Un déploiement Kubernetes utilisant cette image.
- Des NetworkPolicies appliquant les règles réseau L3/L4 spécifiées dans le profil.

L'objectif est d'automatiser la création et le déploiement d'une application conteneurisée tout en sécurisant les flux réseau.

=========================================================================

Structure du projet :

profil-to-oci-k8s/
├── profiles/               
│   └── web-debian.yaml
├── generator/              
│   ├── generate_dockerfile.sh
│   ├── generate_k8s.sh
│   └── build_and_push.sh
├── output/                 
│   ├── docker/
│   └── k8s/
├── deploy.sh               
└── README.txt

=========================================================================

Prérequis :

- Docker
- kubectl
- Cluster Kubernetes local ou distant
- yq (pour parser les fichiers YAML)

=========================================================================

Utilisation :

1. Choisir ou créer un profil dans "profiles/". Exemple `web-debian.yaml` :

profile_id: web-debian
os:
  distro: debian
  version: "12-slim"
software:
  - nginx
  - curl
network:
  defaultDeny: true
  ingress:
    - from:
        namespaceSelector:
          matchLabels:
            role: ingress
      ports:
        - protocol: TCP
          port: 80

2. Générer le Dockerfile :

bash generator/generate_dockerfile.sh profiles/web-debian.yaml

3. Construire et pousser l'image Docker :

bash generator/build_and_push.sh

4. Générer les manifests Kubernetes :

bash generator/generate_k8s.sh profiles/web-debian.yaml

5. Déployer l'application sur Kubernetes :

bash deploy.sh

6. Vérifier les ressources créées dans le cluster :

kubectl get namespace
kubectl get deployment -n web-debian
kubectl get service -n web-debian
kubectl get networkpolicy -n web-debian

=========================================================================

Fonctionnalités :

- Génération automatique d'une image Docker à partir d'un profil YAML/JSON.
- Déploiement d'un Deployment et d'un Service dans un namespace dédié.
- Création de NetworkPolicies avec default deny et exceptions.
- Automatisation complète via scripts Bash.
- Projet reproductible et prêt pour GitHub.

=========================================================================

Exemple de profil :

Le profil "web-debian.yaml" déploie une application nginx sur Debian 12
avec NetworkPolicy autorisant uniquement le trafic HTTP (TCP/80)
depuis les pods Ingress.

=========================================================================

Références :

- Kubernetes NetworkPolicies : https://kubernetes.io/docs/concepts/services-networking/network-policies/
- Docker Documentation : https://docs.docker.com/
- Kind - Kubernetes in Docker : https://kind.sigs.k8s.io/

=========================================================================

Auteur :

Groupe 1 - Master 2 IRS
Amine KACHOU, Kamelia Hamadene,Safa Lazreg
