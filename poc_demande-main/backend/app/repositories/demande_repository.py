from sqlalchemy import select, update, func
from app.repositories.base import BaseRepository
from app.models.demande import Demande

class DemandeRepository(BaseRepository):
    async def get_en_attente(self, structure: str, page: int, size: int) -> tuple[list[Demande], int]:
        # Count total
        count_stmt = select(func.count(Demande.num)).where(
            Demande.approbation == 0,
            Demande.agent_structure == structure,
            Demande.traitement == 0
        )
        total_result = await self.db.execute(count_stmt)
        total = total_result.scalar_one()

        # Get instances with pagination
        stmt = select(Demande).where(
            Demande.approbation == 0,
            Demande.agent_structure == structure,
            Demande.traitement == 0
        ).limit(size).offset((page - 1) * size)
        
        result = await self.db.execute(stmt)
        items = list(result.scalars().all())
        return items, total

    async def get_by_num(self, num: int) -> Demande | None:
        stmt = select(Demande).where(Demande.num == num)
        result = await self.db.execute(stmt)
        return result.scalar_one_or_none()

    async def approuver(self, num: int, acteur_ident: str) -> Demande:
        stmt = (
            update(Demande)
            .where(Demande.num == num)
            .values(
                approbation=1,
                date_action=func.now(),
                acteur_ident=acteur_ident,
                traitement=1
            )
            .returning(Demande)
        )
        result = await self.db.execute(stmt)
        return result.scalar_one()

    async def rejeter(self, num: int, acteur_ident: str) -> Demande:
        stmt = (
            update(Demande)
            .where(Demande.num == num)
            .values(
                approbation=2,
                date_action=func.now(),
                acteur_ident=acteur_ident,
                traitement=1
            )
            .returning(Demande)
        )
        result = await self.db.execute(stmt)
        return result.scalar_one()
