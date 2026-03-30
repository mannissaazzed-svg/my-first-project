from app.repositories.demande_repository import DemandeRepository
from app.schemas.demande import PaginatedDemandesResponse, DemandeResponse, DemandeActionResponse
from app.core.exceptions import DemandeNotFoundException, DemandeAlreadyTreatedException

class DemandeService:
    def __init__(self, repository: DemandeRepository):
        self.repository = repository

    async def get_en_attente(self, structure: str, page: int, size: int) -> PaginatedDemandesResponse:
        items, total = await self.repository.get_en_attente(structure, page, size)
        
        return PaginatedDemandesResponse(
            total=total,
            page=page,
            size=size,
            items=[DemandeResponse.model_validate(item) for item in items]
        )

    async def approuver(self, num: int, acteur_ident: str) -> DemandeActionResponse:
        demande = await self.repository.get_by_num(num)
        if not demande:
            raise DemandeNotFoundException("Demande introuvable.")
        
        if demande.approbation != 0:
            raise DemandeAlreadyTreatedException("La demande a déjà été traitée.")
            
        await self.repository.approuver(num, acteur_ident)
        return DemandeActionResponse(message="Demande approuvée avec succès", num=num)

    async def rejeter(self, num: int, acteur_ident: str, motif: str | None = None) -> DemandeActionResponse:
        demande = await self.repository.get_by_num(num)
        if not demande:
            raise DemandeNotFoundException("Demande introuvable.")
        
        if demande.approbation != 0:
            raise DemandeAlreadyTreatedException("La demande a déjà été traitée.")
            
        await self.repository.rejeter(num, acteur_ident)
        return DemandeActionResponse(message="Demande rejetée avec succès", num=num)
