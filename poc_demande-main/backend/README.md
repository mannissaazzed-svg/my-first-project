# API Backend — Demandes de Mission (POC)

Bienvenue sur le backend FastAPI servant le POC de l'application mobile de traitement des demandes de mission. Ce projet est structuré pour vous permettre de démarrer immédiatement sans configuration complexe.

## 🚀 Démarrage Rapide (Recommandé)

L'environnement complet de l'API (avec base de données, exécution des migrations et insertion des données de test) est encapsulé dans **Docker**. C'est la méthode idéale pour lancer le projet rapidement.

### 1. Prérequis

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installé et démarré sur votre machine.

### 2. Démarrer le Projet

Ouvrez un terminal, placez-vous dans ce dossier `backend`, et exécutez la commande suivante :

```bash
docker-compose up --build
```
> **Note :** La toute première exécution prendra un peu de temps (téléchargement des images système, installation des dépendances, création des tables et initialisation des données algorithmiques). 

### 3. Tester l'API

L'application est maintenant en ligne ! 
Accédez à la documentation interactive **Swagger UI** :
👉 **http://localhost:8000/docs**

Depuis cette interface, vous pouvez :
- Cliquer sur le bouton vert **Authorize**.
- Vous connecter avec l'un des comptes de test (voir liste ci-dessous).
- Tester tous les endpoints de l'application sans écrire de code ou utiliser d'outils tiers.

---

## 👥 Comptes de Test Pré-configurés

La base de données est automatiquement initialisée avec 2 profils, ainsi qu'une vingtaine de demandes aléatoires assignées à la structure `STR_RH`. Le mot de passe est toujours identique.

| Identifiant (`compte`) | Mot de passe | Rôle | Description |
|------------------------|-------------|------|-------------|
| `approbat` | password123 | **APPROBATEUR** | Chef de Service RH. Peut voir et approuver/rejeter les demandes de sa structure. |
| `lecteur` | password123 | **LECTEUR** | Assistant RH. Peut consulter les demandes, mais l'approbation lui sera refusée. |

---

## 🛠 Commandes et Maintenance

### Arrêter le serveur

Si vous n'en avez plus besoin ou souhaitez libérer le port bloqué :
```bash
# Dans le terminal qui exécute Docker Compose, pressez [CTRL + C]
# OU exécutez depuis un autre terminal :
docker-compose down
```

### Réinitialiser complètement la Base de Données

Si vous avez fait trop de tests et souhaitez revenir aux 25 demandes propres du début, c'est très simple grâce à Docker. Il suffit de supprimer les "Volumes" (les disques durs virtuels) de votre stack :

```bash
docker-compose down -v
docker-compose up --build
```

### Exemples d'appels `curl` (Pour comprendre les requêtes HTTP pures)

**1. Récupérer un Token (Login avec `approbat`)**
```bash
curl -X POST "http://localhost:8000/api/v1/auth/login" \
     -H "Content-Type: application/json" \
     -d '{"compte": "approbat", "password": "password123"}'
```
*(Vous devez copier `"access_token"` pour la suite)*

**2. Récupérer la liste des demandes en attente de traitement**
```bash
curl -X GET "http://localhost:8000/api/v1/demandes/en-attente?structure=STR_RH" \
     -H "Authorization: Bearer VOTRE_TOKEN"
```

**3. Approuver la demande n°1**
```bash
curl -X PUT "http://localhost:8000/api/v1/demandes/1/approuver" \
     -H "Authorization: Bearer VOTRE_TOKEN"
```

---

## 📖 (Optionnel) Installation Manuelle (Sans Docker)

*Si pour une raison quelconque vous ne pouvez/voulez pas utiliser Docker, voici la démarche.*

1. Installez `Python 3.10+` et `PostgreSQL 14+`.
2. Créez une base de données PostgreSQL native nommée `demandes_db` (`createdb -U postgres demandes_db`).
3. Créez un environnement virtuel Python et installez les dépendances :
   ```bash
   python -m venv venv
   # Activer venv (Windows): venv\Scripts\activate | (Linux/Mac): source venv/bin/activate
   pip install -r requirements.txt
   ```
4. Copiez `.env.example` en `.env` (et modifiez les accès BD).
5. Jouez les migrations et les données :
   ```bash
   alembic upgrade head
   python scripts/seed.py
   ```
6. Lancez le serveur avec uvicorn :
   ```bash
   uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
   ```
