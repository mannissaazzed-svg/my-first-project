import pytest
from httpx import AsyncClient
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from app.models.demande import Demande

@pytest.mark.asyncio
async def test_get_en_attente(client: AsyncClient, seed_db, auth_headers):
    response = await client.get("/api/v1/demandes/en-attente?structure=STR_RH", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert data["total"] >= 1
    assert len(data["items"]) >= 1
    assert data["items"][0]["approbation"] == 0

@pytest.mark.asyncio
async def test_get_en_attente_wrong_structure(client: AsyncClient, seed_db, auth_headers):
    response = await client.get("/api/v1/demandes/en-attente?structure=STR_UNKNOWN", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert data["total"] == 0
    assert len(data["items"]) == 0

@pytest.mark.asyncio
async def test_get_en_attente_no_auth(client: AsyncClient, seed_db):
    response = await client.get("/api/v1/demandes/en-attente?structure=STR_RH")
    assert response.status_code == 401

@pytest.mark.asyncio
async def test_approuver_success(client: AsyncClient, db_session: AsyncSession, seed_db, auth_headers):
    response = await client.put("/api/v1/demandes/1/approuver", headers=auth_headers)
    assert response.status_code == 200
    assert response.json()["message"] == "Demande approuvée avec succès"
    
    # Vérification en base
    stmt = select(Demande).where(Demande.num == 1)
    result = await db_session.execute(stmt)
    demande = result.scalar_one()
    assert demande.approbation == 1
    assert demande.traitement == 1
    assert demande.acteur_ident == "AG0001"
    assert demande.date_action is not None

@pytest.mark.asyncio
async def test_approuver_already_treated(client: AsyncClient, seed_db, auth_headers):
    response = await client.put("/api/v1/demandes/2/approuver", headers=auth_headers)
    assert response.status_code == 409
    assert response.json()["detail"] == "La demande a déjà été traitée."

@pytest.mark.asyncio
async def test_approuver_not_found(client: AsyncClient, seed_db, auth_headers):
    response = await client.put("/api/v1/demandes/999/approuver", headers=auth_headers)
    assert response.status_code == 404
    assert response.json()["detail"] == "Demande introuvable."

@pytest.mark.asyncio
async def test_rejeter_success(client: AsyncClient, db_session: AsyncSession, seed_db, auth_headers):
    # Réinitialiser la db fixture demandée au mode "en attente" si on l'a approuvée dans le test d'avant ?
    # Chaque test tourne sur une BDD propre grâce au seed_db qui est scoped sur function (mais on modifie en base, et sqlite in-memory garde parfois les choses si pas bien rollbacké. Le setup drop_all recreate_all gère cela).
    response = await client.put("/api/v1/demandes/1/rejeter", headers=auth_headers)
    assert response.status_code == 200
    assert response.json()["message"] == "Demande rejetée avec succès"
    
    stmt = select(Demande).where(Demande.num == 1)
    result = await db_session.execute(stmt)
    demande = result.scalar_one()
    assert demande.approbation == 2
    assert demande.traitement == 1

@pytest.mark.asyncio
async def test_rejeter_with_motif(client: AsyncClient, seed_db, auth_headers):
    response = await client.put(
        "/api/v1/demandes/1/rejeter", 
        json={"motif": "Pas de budget"},
        headers=auth_headers
    )
    assert response.status_code == 200
    assert response.json()["message"] == "Demande rejetée avec succès"
