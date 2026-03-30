from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.db.session import get_db
from app.schemas.auth import TokenData
from app.schemas.droit import DroitResponse
from app.dependencies import get_current_user
from app.repositories.droit_repository import DroitRepository
from app.services.droit_service import DroitService

router = APIRouter()

@router.get("/mes-profils", response_model=list[DroitResponse], summary="Récupérer les profils de l'utilisateur")
async def get_mes_profils(
    current_user: TokenData = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """
    Renvoie la liste des droits/profils pour l'utilisateur actuellement connecté.
    """
    repository = DroitRepository(db)
    service = DroitService(repository)
    return await service.get_mes_profils(current_user.compte)
