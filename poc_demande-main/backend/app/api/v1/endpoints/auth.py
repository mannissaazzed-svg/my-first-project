from fastapi import APIRouter, Depends
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession
from app.db.session import get_db
from app.schemas.auth import LoginSchema, Token
from app.repositories.auth_repository import AuthRepository
from app.services.auth_service import AuthService

router = APIRouter()

@router.post("/login", response_model=Token, summary="Authentification utilisateur")
async def login(login_data: LoginSchema, db: AsyncSession = Depends(get_db)):
    """
    Endpoint pour authentifier un utilisateur et obtenir un token JWT.
    """
    repository = AuthRepository(db)
    service = AuthService(repository)
    return await service.login(login_data)

@router.post("/login/swagger", response_model=Token, summary="Authentification pour Swagger UI", include_in_schema=False)
async def login_swagger(form_data: OAuth2PasswordRequestForm = Depends(), db: AsyncSession = Depends(get_db)):
    """
    Endpoint caché, utilisé nativement par le bouton 'Authorize' de Swagger UI
    qui n'envoie que du format Form Data (username/password).
    """
    repository = AuthRepository(db)
    service = AuthService(repository)
    login_schema = LoginSchema(compte=form_data.username, password=form_data.password)
    return await service.login(login_schema)
