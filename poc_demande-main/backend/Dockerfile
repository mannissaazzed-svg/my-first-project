FROM python:3.12-slim

WORKDIR /app

# Installation de utilitaires systèmes basiques et dépendances PostgreSQL
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copier le fichier des prérequis
COPY requirements.txt .

# Installation des dépendances optimisée et sans cache
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copier le code local dans le conteneur
COPY . .

# Exposer le port de FastAPI
EXPOSE 8000

# Commande par défaut pour lancer l'application (uvicorn)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
