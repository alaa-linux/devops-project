# DevOps Project — Plateforme Cloud Native DevSecOps sur AWS EKS

---

# Présentation du projet

Ce projet est une plateforme complète DevOps / DevSecOps déployée sur AWS avec Kubernetes (Amazon EKS).

L’objectif du projet était de construire une infrastructure cloud moderne et sécurisée intégrant :

- Infrastructure as Code avec Terraform
- Déploiement Kubernetes sur Amazon EKS
- CI/CD automatisé avec GitHub Actions
- Sécurité DevSecOps complète
- Monitoring et observabilité
- Runtime Security
- Service Mesh / Zero Trust
- Logging centralisé
- Backend Terraform sécurisé
- Architecture modulaire Terraform

Le projet a été entièrement réalisé, sécurisé, monitoré et debuggé dans un environnement AWS réel.

---

# Architecture globale

```text
Développeur
    │
    ▼
GitHub Repository
    │
    ▼
GitHub Actions CI/CD
    │
    ▼
AWS ECR
    │
    ▼
Amazon EKS Cluster
    │
    ├── Frontend React
    ├── Backend Node.js
    ├── Istio Service Mesh
    ├── OPA Gatekeeper
    ├── Falco Runtime Security
    ├── Prometheus
    ├── Grafana
    ├── Loki
    └── Promtail
Stack technique
Domaine	Technologies
Cloud	AWS
Infrastructure as Code	Terraform
Containers	Docker
Orchestration	Kubernetes (EKS)
CI/CD	GitHub Actions
Monitoring	Prometheus + Grafana
Logging	Loki + Promtail
Runtime Security	Falco
Policy as Code	OPA Gatekeeper
Service Mesh	Istio
SAST	Semgrep
SCA	Snyk
Scan containers	Trivy
Scan IaC	Checkov
DAST	OWASP ZAP
Registry	AWS ECR
Backend Terraform	AWS S3 + DynamoDB
Système	Ubuntu WSL2
Fonctionnalités implémentées
Infrastructure AWS
Création du VPC
Création des subnets publics et privés
Internet Gateway
Route Tables
Security Groups
Cluster Amazon EKS
Node Groups Kubernetes
Instance EC2 Ansible
Repositories AWS ECR
Backend Terraform distant
Kubernetes
Applications déployées
Frontend
React
Nginx
Docker
Kubernetes Deployment
Backend
Node.js / Express
Docker
Kubernetes Deployment
CI/CD GitHub Actions

Pipeline complète automatisée :

Checkout GitHub
Installation dépendances
Lint frontend
Scan SAST Semgrep
Scan Trivy
Scan Checkov
Scan Snyk
Build Docker
Push AWS ECR
Déploiement Kubernetes
Scan DAST OWASP ZAP
Upload rapports sécurité
Sécurité DevSecOps
SAST — Semgrep

Analyse statique du code source.

SCA — Snyk

Analyse des dépendances vulnérables.

Trivy

Analyse des images Docker.

Checkov

Analyse sécurité Terraform / IaC.

OWASP ZAP

Scan DAST automatisé.

OPA Gatekeeper

Policy as Code Kubernetes.

Falco

Détection runtime des comportements suspects.

Istio

Service Mesh + mTLS + Zero Trust.

Monitoring et observabilité
Prometheus

Collecte des métriques Kubernetes.

Grafana

Dashboards de supervision.

Loki

Centralisation des logs.

Promtail

Collecte des logs Kubernetes.

Structure du projet
.
├── terraform/
├── modules/
├── kubernetes/
├── backend/
├── frontend/
├── opa/
├── screenshots/
├── .github/workflows/
├── README.md
├── TECHNICAL_GUIDE.md
├── ARCHITECTURE.md
├── SECURITY.md
└── TROUBLESHOOTING.md
Étapes principales réalisées
1. Déploiement Infrastructure AWS
Terraform
Commandes principales
terraform init
terraform plan
terraform apply
Infrastructure créée
VPC AWS
Subnets publics / privés
Security Groups
Internet Gateway
EKS Cluster
Node Groups
ECR
2. Déploiement Kubernetes
Commandes principales
kubectl get nodes
kubectl get pods -A
kubectl apply -f
kubectl rollout restart deployment
Déploiement
Frontend React
Backend Node.js
Services Kubernetes
LoadBalancers AWS
3. Mise en place CI/CD
GitHub Actions

Pipeline automatisée avec :

Build Docker
Push ECR
Déploiement EKS
Scans sécurité
4. Modularisation Terraform
Réorganisation Terraform
modules/
├── network/
├── security/
├── eks/
├── compute/
└── ecr/
Migration du state sans destruction
terraform state mv
Validation
terraform plan
Résultat
No changes. Your infrastructure matches the configuration.
5. Backend Terraform sécurisé
AWS S3 + DynamoDB
Mise en place
bucket S3
versioning
chiffrement AES256
DynamoDB locking
Commandes
aws s3api create-bucket
aws dynamodb create-table
terraform init
6. Logging centralisé
Loki + Promtail + Grafana
Fonctionnalités
centralisation logs Kubernetes
LogQL
dashboards Grafana
logs backend Node.js
Commande exemple
kubectl logs deployment/backend-deployment
Requête LogQL
{job="default/backend-node"}
7. OPA Gatekeeper — Policy as Code
Règle implémentée
interdiction des images Docker :latest
Test
kubectl run test-latest --image=nginx:latest --restart=Never
Résultat
denied by Gatekeeper
8. Falco — Runtime Security

Détection temps réel des comportements suspects.

Test effectué
kubectl exec -it falco-test -- sh
Résultat Falco
A shell was spawned in a container
9. Istio — Zero Trust / mTLS
Fonctionnalités
injection sidecar
mTLS
Service Mesh
Zero Trust
Validation
frontend 2/2 Running
backend  2/2 Running
10. OWASP ZAP — DAST
Scan automatisé DAST
docker run --rm -t \
  ghcr.io/zaproxy/zaproxy:stable \
  zap-baseline.py
Résultats sécurité
Avant
WARN : 9
Après correction
WARN : 3
FAIL : 0
Principaux problèmes rencontrés
Kubernetes Scheduling
Erreur
Too many pods
Insufficient memory
Cause
saturation cluster EKS
nodes t3.micro limités
Solution
augmentation nombre de nodes Terraform
optimisation scheduling
nodeSelector
labels Kubernetes
Loki Pending
Cause
problème NodeAffinity
labels absents
Solution
kubectl label node
Promtail ne collectait plus les logs
Cause
backend et promtail sur nodes différents
Solution
déplacement labels log-node=true
redémarrage backend
OPA bloquait Istio
Erreur
Image tag latest interdit
Cause
règle OPA active
Solution
suppression temporaire contrainte OPA
migration images immuables
Erreur ECR immutable images
Erreur
The image tag 'latest' already exists
Cause
ECR en mode IMMUTABLE
utilisation latest
Solution
IMAGE_TAG=${GITHUB_SHA::7}
Istio mTLS STRICT bloquait ELB
Cause
ELB AWS hors mesh Istio
Solution
STRICT -> PERMISSIVE
Compétences démontrées
DevOps
CI/CD
Terraform
Kubernetes
Docker
AWS
DevSecOps
SAST
SCA
DAST
Runtime Security
Policy as Code
Zero Trust
Cloud
AWS EKS
AWS ECR
AWS S3
DynamoDB
IAM
Troubleshooting
Kubernetes Scheduling
CI/CD failures
Service Mesh debugging
Infrastructure debugging
Runtime debugging
Documentation complète
TECHNICAL_GUIDE.md
ARCHITECTURE.md
SECURITY.md
TROUBLESHOOTING.md
Conclusion

Ce projet représente une plateforme Cloud Native DevSecOps complète déployée sur AWS avec Kubernetes.

Il intègre :

Infrastructure as Code
CI/CD sécurisé
Monitoring
Logging
Runtime Security
Zero Trust
Policy as Code
Observabilité
Sécurité automatisée

Le projet a été entièrement réalisé dans un environnement AWS réel avec gestion des incidents, troubleshooting avancé et sécurisation complète de l’infrastructure.

Auteur

Alaa Kaid Ahmed
