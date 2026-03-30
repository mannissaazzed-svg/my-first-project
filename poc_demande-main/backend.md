# PROMPT AGENT CURSOR — Backend FastAPI REST · Approbation de Demandes (POC)

---

## 🎯 CONTEXTE ET OBJECTIF

Tu es un expert Python/FastAPI. Tu dois générer un backend RESTful **complet, propre et prêt à l'emploi** pour un POC (Proof of Concept) d'application mobile d'approbation de demandes de mission/déplacement.

Ce backend est développé dans un contexte académique/POC. Il sera consommé par une application mobile développée par des étudiants. La base de données est **PostgreSQL** (choix pour sa simplicité d'installation et de mise en place), avec une **couche d'abstraction SQLAlchemy** pour permettre une migration future vers Oracle sans réécriture majeure.

---

## 🗄️ MODÈLE DE DONNÉES

Le schéma reproduit fidèlement la structure Oracle d'origine, traduite en PostgreSQL.

### Table `demande`
```sql
CREATE TABLE demande (
  num                        SERIAL PRIMARY KEY,
  "group"                    INTEGER,
  date_etablissement         TIMESTAMP,
  approbation                SMALLINT DEFAULT 0,   -- 0=en attente, 1=approuvé, 2=rejeté
  date_depart                TIMESTAMP,
  date_retour                TIMESTAMP,
  mode_transport             VARCHAR(30),
  lieu                       VARCHAR(70),
  objet                      VARCHAR(300),
  parcours                   VARCHAR(150),
  agent                      VARCHAR(70),
  agent_ident                VARCHAR(6),
  agent_structure            VARCHAR(9),
  agent_direction            VARCHAR(9),
  date_lecture               TIMESTAMP,
  date_action                TIMESTAMP,
  acteur_ident               VARCHAR(6),
  acteur                     VARCHAR(70),
  acteur_poste               VARCHAR(50),
  acteur_poste_structure     VARCHAR(150),
  destinataire_ident         VARCHAR(6),
  destinataire               VARCHAR(70),
  destinataire_poste         VARCHAR(50),
  destinataire_poste_structure VARCHAR(150),
  traitement                 SMALLINT DEFAULT 0
);
```

### Table `droit`
```sql
CREATE TABLE droit (
  id                 SERIAL PRIMARY KEY,
  num                INTEGER,
  poste              VARCHAR(12) NOT NULL,
  role               VARCHAR(15) NOT NULL,        -- ex: APPROBATEUR, LECTEUR
  designation        VARCHAR(80) NOT NULL,
  structure          VARCHAR(9)  NOT NULL,
  libell_structure   VARCHAR(100) NOT NULL,
  direction          VARCHAR(4)  NOT NULL,
  libell_direction   VARCHAR(100) NOT NULL,
  agent_ident        VARCHAR(6)  NOT NULL,
  agent              VARCHAR(40) NOT NULL,
  poste_parent       VARCHAR(12),
  compte             VARCHAR(10) NOT NULL          -- login utilisateur
);
```

### Table `utilisateur` *(nouvelle table pour l'auth POC)*
```sql
CREATE TABLE utilisateur (
  id             SERIAL PRIMARY KEY,
  compte         VARCHAR(10) UNIQUE NOT NULL,      -- login (= DROIT.compte)
  hashed_password VARCHAR(255) NOT NULL,
  agent_ident    VARCHAR(6) NOT NULL,
  agent          VARCHAR(70),
  is_active      BOOLEAN DEFAULT TRUE
);
```

> **Note architecture** : La table `utilisateur` est spécifique au POC. En production Oracle, l'authentification serait déléguée à l'annuaire LDAP/AD de l'entreprise. Le Repository Pattern garantit que ce changement n'impacte que `auth_repository.py`.

---

## 🏗️ ARCHITECTURE DU PROJET

Applique une **architecture en couches (Layered Architecture)** stricte, combinée avec le **Repository Pattern** et le **Service Layer Pattern**.

**Règle absolue** : chaque couche ne connaît que la couche immédiatement inférieure.
```
Endpoint (API) → Service (Métier) → Repository (Données) → DB (PostgreSQL)
```

### Structure des dossiers

```
backend/
├── app/
│   ├── __init__.py
│   ├── main.py                        # Point d'entrée FastAPI, lifespan
│   ├── config.py                      # Settings via pydantic-settings
│   ├── dependencies.py                # Dépendances FastAPI globales
│   │
│   ├── api/
│   │   ├── __init__.py
│   │   └── v1/
│   │       ├── __init__.py
│   │       ├── router.py              # Agrégation des routers v1
│   │       └── endpoints/
│   │           ├── __init__.py
│   │           ├── auth.py            # POST /auth/login
│   │           ├── droits.py          # GET  /droits/mes-profils
│   │           └── demandes.py        # GET, PUT demandes
│   │
│   ├── core/
│   │   ├── __init__.py
│   │   ├── security.py                # Hash password, JWT create/verify
│   │   └── exceptions.py             # Exceptions métier + handlers
│   │
│   ├── db/
│   │   ├── __init__.py
│   │   ├── session.py                 # Engine async SQLAlchemy + SessionLocal
│   │   └── base.py                    # Base déclarative SQLAlchemy
│   │
│   ├── models/                        # Couche ORM SQLAlchemy (tables)
│   │   ├── __init__.py
│   │   ├── demande.py
│   │   ├── droit.py
│   │   └── utilisateur.py
│   │
│   ├── repositories/                  # Couche Repository (accès données)
│   │   ├── __init__.py
│   │   ├── base.py                    # BaseRepository abstrait
│   │   ├── auth_repository.py
│   │   ├── droit_repository.py
│   │   └── demande_repository.py
│   │
│   ├── services/                      # Couche Service (logique métier)
│   │   ├── __init__.py
│   │   ├── auth_service.py
│   │   ├── droit_service.py
│   │   └── demande_service.py
│   │
│   └── schemas/                       # DTOs Pydantic (Request/Response)
│       ├── __init__.py
│       ├── auth.py
│       ├── droit.py
│       └── demande.py
│
├── alembic/                           # Migrations base de données
│   ├── env.py
│   ├── script.py.mako
│   └── versions/
│       └── 0001_initial_schema.py     # Migration initiale (toutes les tables)
│
├── scripts/
│   └── seed.py                        # Script de données de test (POC)
│
├── tests/
│   ├── __init__.py
│   ├── conftest.py                    # Fixtures pytest, DB de test
│   ├── test_auth.py
│   ├── test_droits.py
│   └── test_demandes.py
│
├── alembic.ini
├── .env.example
├── .gitignore
├── requirements.txt
└── README.md
```

---

## 📦 DÉPENDANCES (requirements.txt)

```
# Web framework
fastapi==0.111.0
uvicorn[standard]==0.29.0

# Validation & settings
pydantic==2.7.1
pydantic-settings==2.2.1

# Base de données
sqlalchemy==2.0.30
asyncpg==0.29.0             # Driver PostgreSQL async
alembic==1.13.1             # Migrations

# Sécurité & Auth
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4

# Dev & Tests
python-dotenv==1.0.1
pytest==8.2.0
httpx==0.27.0
pytest-asyncio==0.23.6
anyio==4.3.0
```

---

## ⚙️ CONFIGURATION (app/config.py)

```python
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", case_sensitive=True)

    # PostgreSQL
    POSTGRES_USER: str = "postgres"
    POSTGRES_PASSWORD: str = "postgres"
    POSTGRES_HOST: str = "localhost"
    POSTGRES_PORT: int = 5432
    POSTGRES_DB: str = "demandes_db"

    @property
    def DATABASE_URL(self) -> str:
        return (
            f"postgresql+asyncpg://{self.POSTGRES_USER}:{self.POSTGRES_PASSWORD}"
            f"@{self.POSTGRES_HOST}:{self.POSTGRES_PORT}/{self.POSTGRES_DB}"
        )

    # JWT
    SECRET_KEY: str = "CHANGE_THIS_IN_PRODUCTION_USE_OPENSSL_RAND"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60

    # App
    APP_NAME: str = "Demandes API"
    APP_VERSION: str = "1.0.0"
    DEBUG: bool = True
    API_V1_PREFIX: str = "/api/v1"

settings = Settings()
```

---

## 🔌 BASE DE DONNÉES (app/db/session.py)

Utilise **SQLAlchemy 2.0 en mode async** avec `asyncpg` :

```python
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession
from app.config import settings

engine = create_async_engine(
    settings.DATABASE_URL,
    echo=settings.DEBUG,
    pool_size=10,
    max_overflow=20,
    pool_pre_ping=True,       # Vérification de la connexion avant usage
)

AsyncSessionLocal = async_sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autocommit=False,
    autoflush=False,
)

async def get_db() -> AsyncSession:
    async with AsyncSessionLocal() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
        finally:
            await session.close()
```

---

## 🧩 MODÈLES ORM SQLALCHEMY (app/models/)

### app/models/utilisateur.py
```python
from sqlalchemy import Column, Integer, String, Boolean
from app.db.base import Base

class Utilisateur(Base):
    __tablename__ = "utilisateur"

    id              = Column(Integer, primary_key=True, index=True)
    compte          = Column(String(10), unique=True, nullable=False, index=True)
    hashed_password = Column(String(255), nullable=False)
    agent_ident     = Column(String(6), nullable=False)
    agent           = Column(String(70))
    is_active       = Column(Boolean, default=True)
```

### app/models/droit.py
```python
from sqlalchemy import Column, Integer, String
from app.db.base import Base

class Droit(Base):
    __tablename__ = "droit"

    id               = Column(Integer, primary_key=True, index=True)
    num              = Column(Integer)
    poste            = Column(String(12), nullable=False)
    role             = Column(String(15), nullable=False)
    designation      = Column(String(80), nullable=False)
    structure        = Column(String(9), nullable=False, index=True)
    libell_structure = Column(String(100), nullable=False)
    direction        = Column(String(4), nullable=False)
    libell_direction = Column(String(100), nullable=False)
    agent_ident      = Column(String(6), nullable=False)
    agent            = Column(String(40), nullable=False)
    poste_parent     = Column(String(12))
    compte           = Column(String(10), nullable=False, index=True)
```

### app/models/demande.py
```python
from sqlalchemy import Column, Integer, String, SmallInteger, DateTime
from app.db.base import Base

class Demande(Base):
    __tablename__ = "demande"

    num                          = Column(Integer, primary_key=True, index=True)
    group                        = Column(Integer)
    date_etablissement           = Column(DateTime)
    approbation                  = Column(SmallInteger, default=0, index=True)
    date_depart                  = Column(DateTime)
    date_retour                  = Column(DateTime)
    mode_transport               = Column(String(30))
    lieu                         = Column(String(70))
    objet                        = Column(String(300))
    parcours                     = Column(String(150))
    agent                        = Column(String(70))
    agent_ident                  = Column(String(6))
    agent_structure              = Column(String(9), index=True)
    agent_direction              = Column(String(9))
    date_lecture                 = Column(DateTime)
    date_action                  = Column(DateTime)
    acteur_ident                 = Column(String(6))
    acteur                       = Column(String(70))
    acteur_poste                 = Column(String(50))
    acteur_poste_structure       = Column(String(150))
    destinataire_ident           = Column(String(6))
    destinataire                 = Column(String(70))
    destinataire_poste           = Column(String(50))
    destinataire_poste_structure = Column(String(150))
    traitement                   = Column(SmallInteger, default=0)
```

---

## 🔐 SÉCURITÉ (app/core/security.py)

```python
from datetime import datetime, timedelta, timezone
from jose import JWTError, jwt
from passlib.context import CryptContext
from app.config import settings

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain: str, hashed: str) -> bool:
    return pwd_context.verify(plain, hashed)

def create_access_token(data: dict) -> str:
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)

def decode_token(token: str) -> dict:
    try:
        return jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
    except JWTError:
        raise UnauthorizedException("Token invalide ou expiré")
```

**`TokenData` schema** (dans `app/schemas/auth.py`) :
```python
class TokenData(BaseModel):
    compte: str
    agent_ident: str
```

---

## 🧱 REPOSITORY PATTERN (app/repositories/)

### app/repositories/base.py
```python
from abc import ABC
from sqlalchemy.ext.asyncio import AsyncSession

class BaseRepository(ABC):
    def __init__(self, db: AsyncSession):
        self.db = db
```

### app/repositories/auth_repository.py
Méthodes à implémenter :
- `async get_by_compte(compte: str) -> Utilisateur | None`

### app/repositories/droit_repository.py
Méthodes à implémenter :
- `async get_by_compte(compte: str) -> list[Droit]`

### app/repositories/demande_repository.py
Méthodes à implémenter :
- `async get_en_attente(structure: str, page: int, size: int) -> tuple[list[Demande], int]`
- `async get_by_num(num: int) -> Demande | None`
- `async approuver(num: int, acteur_ident: str) -> Demande`
- `async rejeter(num: int, acteur_ident: str) -> Demande`

> **Important** : Utiliser **uniquement des expressions SQLAlchemy** (`select()`, `update()`, `func.now()`). Zéro SQL brut. Cela garantit la portabilité PostgreSQL → Oracle.

---

## 🔁 ENDPOINTS ET LOGIQUE MÉTIER

### Auth — POST /api/v1/auth/login

**Request body** :
```json
{ "compte": "user01", "password": "motdepasse" }
```
**Réponse 200** :
```json
{
  "access_token": "eyJhbGci...",
  "token_type": "bearer",
  "expires_in": 3600
}
```
**Réponse 401** : `{ "detail": "Identifiants invalides" }`

**Flux** : `AuthService.login()` → `AuthRepository.get_by_compte()` → `verify_password()` → `create_access_token()`

---

### Droits — GET /api/v1/droits/mes-profils

- **Auth** : Bearer JWT requis
- **Logique** : `DroitService` → `DroitRepository.get_by_compte(compte)` → filtre sur `droit.compte`

**Réponse 200** :
```json
[
  {
    "id": 1,
    "poste": "P_RH_01",
    "role": "APPROBATEUR",
    "designation": "Chef de Service RH",
    "structure": "STR_RH",
    "libell_structure": "Service Ressources Humaines",
    "direction": "DRH",
    "libell_direction": "Direction des Ressources Humaines",
    "agent_ident": "AG0001",
    "agent": "BENALI Mohamed",
    "poste_parent": null,
    "compte": "user01"
  }
]
```

---

### Demandes — GET /api/v1/demandes/en-attente

**Query params** :
- `structure` (string, **obligatoire**) — issu du profil sélectionné par l'utilisateur
- `page` (int, défaut: 1)
- `size` (int, défaut: 20, max: 100)

**Filtre appliqué** : `approbation = 0 AND agent_structure = :structure AND traitement = 0`

**Réponse 200** :
```json
{
  "total": 12,
  "page": 1,
  "size": 20,
  "items": [
    {
      "num": 1,
      "date_etablissement": "2024-03-01T08:00:00",
      "approbation": 0,
      "date_depart": "2024-03-10T07:00:00",
      "date_retour": "2024-03-12T18:00:00",
      "mode_transport": "Véhicule de service",
      "lieu": "Alger",
      "objet": "Participation à une formation FastAPI",
      "parcours": "Oran - Alger - Oran",
      "agent": "KADDOUR Fatima",
      "agent_ident": "AG0042",
      "agent_structure": "STR_RH",
      "agent_direction": "DRH",
      "destinataire": "BENALI Mohamed",
      "destinataire_poste": "Chef de Service RH"
    }
  ]
}
```

---

### Demandes — PUT /api/v1/demandes/{num}/approuver

- **Auth** : Bearer JWT requis
- **Logique** :
  1. Vérifier que la demande existe → sinon `404`
  2. Vérifier que `approbation == 0` → sinon `409 Demande déjà traitée`
  3. `UPDATE demande SET approbation=1, date_action=NOW(), acteur_ident=:ident, traitement=1`
- **Réponse 200** : `{ "message": "Demande approuvée avec succès", "num": 1 }`

---

### Demandes — PUT /api/v1/demandes/{num}/rejeter

- **Auth** : Bearer JWT requis
- **Body optionnel** : `{ "motif": "Budget insuffisant" }`
- **Logique** :
  1. Vérifier existence → `404`
  2. Vérifier `approbation == 0` → `409`
  3. `UPDATE demande SET approbation=2, date_action=NOW(), acteur_ident=:ident, traitement=1`
- **Réponse 200** : `{ "message": "Demande rejetée avec succès", "num": 1 }`

---

## 🚨 GESTION DES EXCEPTIONS (app/core/exceptions.py)

Définir les exceptions métier et les enregistrer comme handlers globaux dans `main.py` :

```python
class DemandeNotFoundException(Exception):
    """Levée quand une demande n'existe pas"""

class DemandeAlreadyTreatedException(Exception):
    """Levée quand on tente de traiter une demande déjà approuvée ou rejetée"""

class InvalidCredentialsException(Exception):
    """Levée en cas d'identifiants invalides"""

class UnauthorizedException(Exception):
    """Levée quand le token est absent, invalide ou expiré"""

# Mapping codes HTTP :
# DemandeNotFoundException       → 404
# DemandeAlreadyTreatedException → 409
# InvalidCredentialsException    → 401
# UnauthorizedException          → 401
```

---

## 📝 MAIN APP (app/main.py)

Utilise le **lifespan** (remplace les dépréciés `on_event`) :

```python
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup : en mode DEBUG, créer les tables automatiquement
    # En production → utiliser Alembic uniquement
    if settings.DEBUG:
        async with engine.begin() as conn:
            await conn.run_sync(Base.metadata.create_all)
    yield
    # Shutdown : libérer le pool de connexions
    await engine.dispose()

app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION,
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan,
)

# CORS — permissif pour le POC, à restreindre en production
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

register_exception_handlers(app)
app.include_router(api_router, prefix=settings.API_V1_PREFIX)

@app.get("/health", tags=["Monitoring"])
async def health_check():
    return {"status": "ok", "version": settings.APP_VERSION}
```

---

## 🌱 SCRIPT DE DONNÉES DE TEST (scripts/seed.py)

**Ce script est critique pour le POC** — il permet aux étudiants de tester l'app mobile immédiatement.

Générer un script Python async exécutable via `python scripts/seed.py` qui :

1. **Tronque** les tables dans l'ordre (respecter les FK) : `demande`, `droit`, `utilisateur`
2. **Insère** les données suivantes :

### 3 utilisateurs
| compte | password | agent_ident | agent |
|--------|----------|-------------|-------|
| user01 | password123 | AG0001 | BENALI Mohamed |
| user02 | password123 | AG0002 | KHELIFI Amina |
| user03 | password123 | AG0003 | MEZIANE Karim |

> Les mots de passe doivent être **hashés avec bcrypt** avant insertion.

### 4 droits (profils)
- `user01` → APPROBATEUR sur `STR_RH` (Chef Service RH, direction DRH)
- `user01` → APPROBATEUR sur `STR_FIN` (Chef Section Finances, direction DFI)
- `user02` → APPROBATEUR sur `STR_IT` (Responsable SI, direction DSI)
- `user03` → LECTEUR sur `STR_RH` (Assistant RH, direction DRH)

### 15 demandes variées
- 10 demandes `approbation=0, traitement=0` (en attente) :
  - 4 sur `STR_RH`, 3 sur `STR_FIN`, 3 sur `STR_IT`
- 3 demandes `approbation=1, traitement=1` (approuvées)
- 2 demandes `approbation=2, traitement=1` (rejetées)

Utiliser des destinations algériennes réalistes : Alger, Constantine, Annaba, Tlemcen, Béjaïa, Sétif.
Utiliser des dates 2024-2025 cohérentes (date_depart < date_retour, date_etablissement <= date_depart).

3. **Affiche** en fin d'exécution :
```
✅ Seed terminé avec succès !
   → 3 utilisateurs insérés
   → 4 droits insérés
   → 15 demandes insérées (10 en attente, 3 approuvées, 2 rejetées)
```

---

## 🔁 FLUX COMPLET (pour la documentation étudiants)

```
Application Mobile
      │
      │ 1. Authentification
      ├──► POST /api/v1/auth/login
      │    Body: { "compte": "user01", "password": "password123" }
      │    ◄─── { "access_token": "eyJ...", "token_type": "bearer" }
      │
      │ 2. Récupération des profils
      ├──► GET /api/v1/droits/mes-profils
      │    Header: Authorization: Bearer eyJ...
      │    ◄─── [ { "structure": "STR_RH", "role": "APPROBATEUR", ... }, ... ]
      │
      │ 3. L'utilisateur choisit le profil "STR_RH"
      │
      │ 4. Liste des demandes à approuver
      ├──► GET /api/v1/demandes/en-attente?structure=STR_RH&page=1&size=20
      │    Header: Authorization: Bearer eyJ...
      │    ◄─── { "total": 4, "items": [ { "num": 1, ... }, ... ] }
      │
      │ 5a. Approuver la demande n°1
      ├──► PUT /api/v1/demandes/1/approuver
      │    Header: Authorization: Bearer eyJ...
      │    ◄─── { "message": "Demande approuvée avec succès", "num": 1 }
      │
      │ 5b. Rejeter la demande n°2
      └──► PUT /api/v1/demandes/2/rejeter
           Header: Authorization: Bearer eyJ...
           Body: { "motif": "Justificatifs manquants" }
           ◄─── { "message": "Demande rejetée avec succès", "num": 2 }
```

---

## 🧪 TESTS (tests/)

### tests/conftest.py
- `event_loop` : asyncio loop pour pytest-asyncio
- `engine_test` : engine SQLite async en mémoire (pas besoin de PostgreSQL installé)
- `db_session` : session DB de test avec rollback automatique
- `client` : `AsyncClient` httpx avec override de `get_db`
- `auth_headers` : headers avec token JWT valide pour `user01`

### tests/test_auth.py
- `test_login_success` : bons credentials → 200 + token présent
- `test_login_wrong_password` → 401
- `test_login_unknown_compte` → 401
- `test_token_contains_valid_claims` : décoder le JWT et vérifier `compte` + `agent_ident`

### tests/test_droits.py
- `test_get_profils_authenticated` → 200 + liste non vide
- `test_get_profils_no_token` → 401
- `test_get_profils_invalid_token` → 401

### tests/test_demandes.py
- `test_get_en_attente` → 200 + items en attente uniquement
- `test_get_en_attente_wrong_structure` → 200 + liste vide
- `test_get_en_attente_no_auth` → 401
- `test_approuver_success` → 200, vérifier `approbation=1` en DB
- `test_approuver_already_treated` → 409
- `test_approuver_not_found` → 404
- `test_rejeter_success` → 200, vérifier `approbation=2` en DB
- `test_rejeter_with_motif` → 200

---

## 📄 FICHIERS COMPLÉMENTAIRES

### .env.example
```env
# PostgreSQL
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=demandes_db

# JWT — Générer avec: python -c "import secrets; print(secrets.token_hex(32))"
SECRET_KEY=CHANGE_THIS_TO_A_RANDOM_64_CHAR_HEX_STRING
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=60

# App
DEBUG=True
APP_NAME=Demandes API
```

### README.md — Sections obligatoires

**1. Prérequis**
- Python 3.10+
- PostgreSQL 14+ (lien d'installation Windows/Linux/Mac)
- Optionnel : pgAdmin ou DBeaver pour visualiser les données

**2. Installation**
```bash
git clone <repo> && cd backend
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
cp .env.example .env   # puis éditer les variables
```

**3. Base de données**
```bash
createdb demandes_db
alembic upgrade head
python scripts/seed.py
```

**4. Lancement**
```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
# Swagger UI → http://localhost:8000/docs
```

**5. Comptes de test**

| Compte | Mot de passe | Rôle | Structures |
|--------|-------------|------|------------|
| user01 | password123 | APPROBATEUR | STR_RH, STR_FIN |
| user02 | password123 | APPROBATEUR | STR_IT |
| user03 | password123 | LECTEUR | STR_RH |

**6. Exemples curl** pour chaque endpoint (avec token réel)

---

## ✅ CHECKLIST FINALE CURSOR

**Architecture**
- [ ] Aucune expression SQLAlchemy en dehors des repositories
- [ ] Aucune logique métier dans les endpoints
- [ ] Aucun import SQLAlchemy dans les services
- [ ] Chaque endpoint a `summary`, `description`, `response_model` et `responses` documentés

**Base de données**
- [ ] Le `lifespan` initialise et ferme proprement le pool
- [ ] La migration Alembic `0001_initial_schema.py` crée les 3 tables
- [ ] `get_db()` gère commit/rollback/close dans un try/except/finally
- [ ] `pool_pre_ping=True` activé sur l'engine

**Sécurité**
- [ ] Mots de passe hashés bcrypt — jamais en clair en DB
- [ ] Token JWT contient `compte`, `agent_ident` et `exp`
- [ ] Toutes les routes sauf `/auth/login` et `/health` requièrent Bearer token

**POC / Qualité**
- [ ] `scripts/seed.py` fonctionne et affiche un résumé clair
- [ ] Les dates sont sérialisées en ISO 8601 dans les réponses JSON
- [ ] Variables sensibles dans `.env` — jamais hardcodées
- [ ] Code PEP8 avec type hints sur toutes les fonctions
- [ ] Tests tournent avec `pytest` sans requérir PostgreSQL installé (SQLite en mémoire)
