from fastapi import APIRouter
from app.api.v1.endpoints import auth, droits, demandes

api_router = APIRouter()

api_router.include_router(auth.router, prefix="/auth", tags=["Authentification"])
api_router.include_router(droits.router, prefix="/droits", tags=["Droits & Profils"])
api_router.include_router(demandes.router, prefix="/demandes", tags=["Demandes"])
