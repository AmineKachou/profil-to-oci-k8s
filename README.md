PROJET GENERATEUR PROFIL → OCI → KUBERNETES + NETWORKPOLICIES

Description :
Ce projet automatise la création et le déploiement d’applications conteneurisées
à partir d’un profil YAML. À partir d’un profil déclaratif, le système génère automatiquement :
- Un Dockerfile pour construire l’image OCI.
- Les manifests Kubernetes (Namespace, Deployment, Service, NetworkPolicies).
- Le script de déploiement pour appliquer ces manifests sur un cluster Kubernetes.

Structure du projet :
profiles/           - Profils YAML décrivant les applications
generator/          - Scripts de génération automatique (Dockerfile, manifests)
output/
  docker/           - Dockerfile généré
  k8s/              - Manifests Kubernetes générés
scripts/            - Scripts utilitaires (deploy.sh, build_and_push.sh)
README.txt          - Ce fichier

Prérequis :
- Docker installé
- Kubernetes (kind, minikube ou cluster distant)
- kubectl configuré sur le cluster
- Accès au GitHub Container Registry pour l’image OCI (si privée)

Étapes d’utilisation :

1. Créer le profil YAML
   Décrire l’application, les packages à installer et les règles réseau
   dans profiles/<app>.yaml
   Exemple : profiles/web-debian.yaml

2. Générer le Dockerfile
   bash generator/generate_dockerfile.sh profiles/web-debian.yaml

3. Générer les manifests Kubernetes
   bash generator/generate_k8s.sh profiles/web-debian.yaml

4. Construire et publier l’image OCI
   bash scripts/build_and_push.sh output/docker/Dockerfile ghcr.io/<username>/web-debian:debian12-v1

5. Déployer l’application sur Kubernetes
   bash scripts/deploy.sh

6. Vérifier le déploiement
   kubectl get pods -n web-debian
   kubectl get svc -n web-debian

   Tester le serveur avec curl :
   kubectl exec -it <pod-name> -n web-debian -- curl http://localhost

Résultat attendu :
- Un pod fonctionnel avec l’image déployée.
- Le service nginx opérationnel et accessible sur le port configuré.
- Les NetworkPolicies appliquées pour sécuriser le trafic réseau.

Remarques :
- Le script deploy.sh applique d’abord le Namespace, puis le reste des manifests.
- L’image Docker doit être accessible (publique ou via un imagePullSecret)
  pour que Kubernetes puisse la récupérer.
