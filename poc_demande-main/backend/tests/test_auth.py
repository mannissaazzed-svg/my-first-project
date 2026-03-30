import pytest
from httpx import AsyncClient
from app.core.security import verify_password
from app.models.utilisateur import Utilisateur

@pytest.mark.asyncio
async def test_login_success(client: AsyncClient, seed_db):
    response = await client.post(
        "/api/v1/auth/login",
        json={"compte": "user01", "password": "password123"}
    )
    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert data["token_type"] == "bearer"

@pytest.mark.asyncio
async def test_login_wrong_password(client: AsyncClient, seed_db):
    response = await client.post(
        "/api/v1/auth/login",
        json={"compte": "user01", "password": "wrongpassword"}
    )
    assert response.status_code == 401
    assert response.json()["detail"] == "Identifiants invalides"

@pytest.mark.asyncio
async def test_login_unknown_compte(client: AsyncClient, seed_db):
    response = await client.post(
        "/api/v1/auth/login",
        json={"compte": "unknown", "password": "password123"}
    )
    assert response.status_code == 401

@pytest.mark.asyncio
async def test_token_contains_valid_claims(client: AsyncClient, seed_db):
    response = await client.post(
        "/api/v1/auth/login",
        json={"compte": "user01", "password": "password123"}
    )
    token = response.json()["access_token"]
    
    from app.core.security import decode_token
    payload = decode_token(token)
    assert payload["compte"] == "user01"
    assert payload["agent_ident"] == "AG0001"
    assert "exp" in payload
