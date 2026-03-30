from app.repositories.droit_repository import DroitRepository
from app.schemas.droit import DroitResponse

class DroitService:
    def __init__(self, repository: DroitRepository):
        self.repository = repository

    async def get_mes_profils(self, compte: str) -> list[DroitResponse]:
        droits = await self.repository.get_by_compte(compte)
        return [DroitResponse.model_validate(droit) for droit in droits]
