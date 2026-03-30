from sqlalchemy import select
from app.repositories.base import BaseRepository
from app.models.droit import Droit

class DroitRepository(BaseRepository):
    async def get_by_compte(self, compte: str) -> list[Droit]:
        stmt = select(Droit).where(Droit.compte == compte)
        result = await self.db.execute(stmt)
        return list(result.scalars().all())
