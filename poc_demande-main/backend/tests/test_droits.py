import pytest
from httpx import AsyncClient

@pytest.mark.asyncio
async def test_get_profils_authenticated(client: AsyncClient, seed_db, auth_headers):
    response = await client.get("/api/v1/droits/mes-profils", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)
    assert len(data) > 0
    assert data[0]["compte"] == "user01"
    assert data[0]["role"] == "APPROBATEUR"

@pytest.mark.asyncio
async def test_get_profils_no_token(client: AsyncClient, seed_db):
    response = await client.get("/api/v1/droits/mes-profils")
    assert response.status_code == 401
    assert response.json()["detail"] == "Not authenticated"

@pytest.mark.asyncio
async def test_get_profils_invalid_token(client: AsyncClient, seed_db):
    response = await client.get(
        "/api/v1/droits/mes-profils", 
        headers={"Authorization": "Bearer invalid_token_here"}
    )
    assert response.status_code == 401
    assert response.json()["detail"] == "Token invalide ou expiré"
