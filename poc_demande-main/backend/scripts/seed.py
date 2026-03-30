import asyncio
import os
import sys
import random
from datetime import datetime, timedelta

from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession
from sqlalchemy import text

# Ajoute le projet au sys.path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.config import settings
from app.core.security import hash_password
from app.models.utilisateur import Utilisateur
from app.models.droit import Droit
from app.models.demande import Demande
from app.db.base import Base

def random_date(start: datetime, end: datetime) -> datetime:
    return start + timedelta(
        seconds=random.randint(0, int((end - start).total_seconds()))
    )

async def seed_data():
    engine = create_async_engine(settings.DATABASE_URL, echo=False)
    AsyncSessionLocal = async_sessionmaker(engine, expire_on_commit=False)

    async with AsyncSessionLocal() as session:
        # 1. Tronquer les tables
        print("Vidéage des tables...")
        await session.execute(text("TRUNCATE TABLE demande, droit, utilisateur RESTART IDENTITY CASCADE;"))
        await session.commit()

        # 2. Utilisateurs
        users = [
            Utilisateur(compte="approbat", hashed_password=hash_password("password123"), agent_ident="AG0001", agent="BENALI Mohamed"),
            Utilisateur(compte="lecteur", hashed_password=hash_password("password123"), agent_ident="AG0002", agent="KHELIFI Amina")
        ]
        session.add_all(users)
        
        # 3. Droits
        # L'approbateur chef du service RH, avec droits d'APPROBATEUR
        # Le lecteur assistant RH, dans le même service, mais avec rôle LECTEUR
        droits = [
            Droit(poste="P_RH_01", role="APPROBATEUR", designation="Chef de Service RH", structure="STR_RH", libell_structure="Service Ressources Humaines", direction="DRH", libell_direction="Direction des Ressources Humaines", agent_ident="AG0001", agent="BENALI Mohamed", compte="approbat"),
            Droit(poste="P_RH_02", role="LECTEUR", designation="Assistant RH", structure="STR_RH", libell_structure="Service Ressources Humaines", direction="DRH", libell_direction="Direction des Ressources Humaines", agent_ident="AG0002", agent="KHELIFI Amina", compte="lecteur")
        ]
        session.add_all(droits)

        # 4. Demandes
        now = datetime.now()
        lieux = ["Alger", "Oran", "Constantine", "Annaba", "Sétif", "Batna", "Djelfa", "Biskra"]
        objets = ["Formation", "Audit", "Réunion", "Congrès", "Intervention technique", "Supervision"]
        agents_demandeur = [("AG0100", "KADDOUR Fatima"), ("AG0101", "BOUZID Salim"), ("AG0102", "CHIKH Yassine"), ("AG0103", "MADI Sara")]
        
        demandes = []
        for i in range(25):
            # Dates aléatoires logiques
            date_etab = random_date(now - timedelta(days=30), now)
            date_dep = random_date(date_etab + timedelta(days=1), date_etab + timedelta(days=20))
            date_ret = random_date(date_dep + timedelta(days=1), date_dep + timedelta(days=10))
            
            agent_id, agent_nom = random.choice(agents_demandeur)
            lieu = random.choice(lieux)
            objet = random.choice(objets)
            
            # Statut aléatoire: 60% en attente (0), 30% approuvées (1), 10% rejetées (2)
            rand_statut = random.randint(1, 100)
            if rand_statut <= 60:
                approbation = 0
                traitement = 0
                date_action = None
                acteur = None
            elif rand_statut <= 90:
                approbation = 1
                traitement = 1
                date_action = random_date(date_etab, now)
                acteur = "AG0001" # L'approbateur
            else:
                approbation = 2
                traitement = 1
                date_action = random_date(date_etab, now)
                acteur = "AG0001" # L'approbateur
                
            demandes.append(Demande(
                date_etablissement=date_etab,
                approbation=approbation,
                traitement=traitement,
                date_depart=date_dep,
                date_retour=date_ret,
                lieu=lieu,
                objet=objet,
                agent=agent_nom,
                agent_ident=agent_id,
                agent_structure="STR_RH",
                date_action=date_action,
                acteur_ident=acteur
            ))

        session.add_all(demandes)
        await session.commit()
        
        print(f"✅ Seed terminé avec succès !")
        print(f"   → {len(users)} utilisateurs insérés (approbateur / lecteur)")
        print(f"   → {len(droits)} droits insérés")
        print(f"   → {len(demandes)} demandes aléatoires générées sur STR_RH")

    await engine.dispose()

if __name__ == "__main__":
    asyncio.run(seed_data())
