# 🚀 Générateur de Profil → OCI → Kubernetes + NetworkPolicies

> Automatisez la création et le déploiement d'applications conteneurisées à partir d'un simple profil YAML déclaratif.

---

## 📋 Description

Ce projet fournit une chaîne d'outils complète pour générer et déployer des applications conteneurisées sur Kubernetes à partir d'un profil YAML. En partant d'une description déclarative de l'application, le système génère automatiquement :

- 🐳 **Un Dockerfile** pour construire l'image OCI
- ☸️ **Les manifests Kubernetes** : Namespace, Deployment, Service, NetworkPolicies
- 📜 **Un script de déploiement** prêt à appliquer sur un cluster Kubernetes

---

## 📁 Structure du projet

```
.
├── generator/
│   ├── generate_dockerfile.sh     # Génère le Dockerfile à partir du profil
│   ├── generate_k8s.sh            # Génère les manifests Kubernetes
│   └── build_and_push.sh          # Construit et publie l'image OCI
├── output/
│   ├── docker/
│   │   └── Dockerfile             # Dockerfile généré
│   └── k8s/
│       ├── namespace.yaml         # Manifest Namespace
│       ├── deployment.yaml        # Manifest Deployment
│       ├── service.yaml           # Manifest Service
│       └── networkpolicy.yaml     # Règles NetworkPolicy
├── profiles/
│   └── web-debian.yaml            # Exemple de profil applicatif
├── deploy.sh                      # Script de déploiement global
└── README.md
```

---

## ✅ Prérequis

Avant de commencer, assurez-vous d'avoir les outils suivants installés et configurés :

| Outil | Usage |
|-------|-------|
| [Docker](https://docs.docker.com/) | Construction et publication des images OCI |
| [kubectl](https://kubernetes.io/docs/tasks/tools/) | Interaction avec le cluster Kubernetes |
| [Kind](https://kind.sigs.k8s.io/) / [Minikube](https://minikube.sigs.k8s.io/) ou cluster distant | Environnement Kubernetes |
| Accès au [GitHub Container Registry](https://ghcr.io) | Hébergement de l'image OCI (si image privée) |

---

## 🛠️ Utilisation

### Étape 1 — Créer le profil YAML

Décrivez votre application dans un fichier `profiles/<app>.yaml` en spécifiant les packages à installer et les règles réseau souhaitées.

```bash
# Exemple de profil disponible
profiles/web-debian.yaml
```

### Étape 2 — Générer le Dockerfile

```bash
bash generator/generate_dockerfile.sh profiles/web-debian.yaml
```

Le Dockerfile sera généré dans `output/docker/Dockerfile`.

### Étape 3 — Générer les manifests Kubernetes

```bash
bash generator/generate_k8s.sh profiles/web-debian.yaml
```

Les manifests seront générés dans `output/k8s/`.

### Étape 4 — Construire et publier l'image OCI

```bash
bash generator/build_and_push.sh output/docker/Dockerfile ghcr.io/<username>/web-debian:debian12-v1
```

> ⚠️ Remplacez `<username>` par votre identifiant GitHub Container Registry.

### Étape 5 — Déployer sur Kubernetes

```bash
bash deploy.sh
```

> Le script applique d'abord le Namespace, puis l'ensemble des manifests dans l'ordre.

### Étape 6 — Vérifier le déploiement

```bash
# Vérifier l'état des pods et du service
kubectl get pods -n web-debian
kubectl get svc -n web-debian

# Tester le serveur nginx depuis un pod
kubectl exec -it <pod-name> -n web-debian -- curl http://localhost
```

---

## 🎯 Résultat attendu

Une fois le déploiement terminé avec succès :

- ✅ Un **pod fonctionnel** avec l'image OCI déployée
- ✅ Le **service nginx** opérationnel et accessible sur le port configuré
- ✅ Les **NetworkPolicies** appliquées pour sécuriser le trafic réseau entre les pods

---

## ⚠️ Remarques importantes

- Le script `deploy.sh` applique les ressources dans l'ordre suivant : Namespace → Deployment → Service → NetworkPolicies.
- L'image Docker doit être **accessible publiquement** ou disponible via un `imagePullSecret` pour que Kubernetes puisse la récupérer.
- Vérifiez que `kubectl` est bien configuré sur le bon contexte avant de lancer le déploiement (`kubectl config current-context`).

---

## 📚 Références

- [Kubernetes NetworkPolicies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [Documentation Docker](https://docs.docker.com/)
- [Kind — Kubernetes in Docker](https://kind.sigs.k8s.io/)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)

---

## 👥 Auteurs

**Groupe 03 — Master 2 IRS**
- Amine KACHOU
- Kamelia Hamadene
- Safa Lazreg
