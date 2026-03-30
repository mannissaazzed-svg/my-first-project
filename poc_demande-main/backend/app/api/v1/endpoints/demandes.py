from fastapi import APIRouter, Depends, Query, Path
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.session import get_db
from app.schemas.auth import TokenData
from app.schemas.demande import (
    PaginatedDemandesResponse,
    DemandeActionResponse,
    RejeterRequestMode
)
from app.dependencies import get_current_user
from app.repositories.demande_repository import DemandeRepository
from app.services.demande_service import DemandeService

router = APIRouter()

def get_demande_service(db: AsyncSession = Depends(get_db)) -> DemandeService:
    repository = DemandeRepository(db)
    return DemandeService(repository)

@router.get("/en-attente", response_model=PaginatedDemandesResponse, summary="Lister les demandes en attente")
async def get_demandes_en_attente(
    structure: str = Query(..., description="La structure issue du profil sélectionné par l'utilisateur"),
    page: int = Query(1, ge=1),
    size: int = Query(20, ge=1, le=100),
    current_user: TokenData = Depends(get_current_user),
    service: DemandeService = Depends(get_demande_service)
):
    return await service.get_en_attente(structure, page, size)

@router.put("/{num}/approuver", response_model=DemandeActionResponse, summary="Approuver une demande")
async def approuver_demande(
    num: int = Path(..., description="Numéro de la demande"),
    current_user: TokenData = Depends(get_current_user),
    service: DemandeService = Depends(get_demande_service)
):
    return await service.approuver(num=num, acteur_ident=current_user.agent_ident)

@router.put("/{num}/rejeter", response_model=DemandeActionResponse, summary="Rejeter une demande")
async def rejeter_demande(
    num: int = Path(..., description="Numéro de la demande"),
    request: RejeterRequestMode | None = None,
    current_user: TokenData = Depends(get_current_user),
    service: DemandeService = Depends(get_demande_service)
):
    motif = request.motif if request else None
    return await service.rejeter(num=num, acteur_ident=current_user.agent_ident, motif=motif)
