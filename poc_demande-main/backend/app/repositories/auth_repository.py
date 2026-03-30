from sqlalchemy import select
from app.repositories.base import BaseRepository
from app.models.utilisateur import Utilisateur

class AuthRepository(BaseRepository):
    async def get_by_compte(self, compte: str) -> Utilisateur | None:
        stmt = select(Utilisateur).where(Utilisateur.compte == compte)
        result = await self.db.execute(stmt)
        return result.scalar_one_or_none()
