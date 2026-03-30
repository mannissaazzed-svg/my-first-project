import pytest
import pytest_asyncio
from httpx import AsyncClient, ASGITransport
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession

from app.main import app
from app.db.base import Base
from app.db.session import get_db
from app.core.security import create_access_token
from app.models.utilisateur import Utilisateur
from app.core.security import hash_password
from app.models.droit import Droit
from app.models.demande import Demande

# Use SQLite in-memory for testing
SQLALCHEMY_DATABASE_URL = "sqlite+aiosqlite:///:memory:"

engine_test = create_async_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)
TestingSessionLocal = async_sessionmaker(autocommit=False, autoflush=False, bind=engine_test, class_=AsyncSession)

@pytest_asyncio.fixture(scope="session")
def event_loop():
    import asyncio
    loop = asyncio.get_event_loop_policy().new_event_loop()
    yield loop
    loop.close()

@pytest_asyncio.fixture(scope="function", autouse=True)
async def db_schema():
    async with engine_test.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)
        await conn.run_sync(Base.metadata.create_all)
    yield
    async with engine_test.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)

@pytest_asyncio.fixture(scope="function")
async def db_session():
    async with TestingSessionLocal() as session:
        yield session

@pytest_asyncio.fixture(scope="function")
async def client(db_session: AsyncSession):
    async def override_get_db():
        yield db_session

    app.dependency_overrides[get_db] = override_get_db
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://testserver") as c:
        yield c
    app.dependency_overrides.clear()

@pytest_asyncio.fixture(scope="function")
async def seed_db(db_session: AsyncSession):
    # Base user
    user = Utilisateur(compte="user01", hashed_password=hash_password("password123"), agent_ident="AG0001", agent="BENALI Mohamed")
    db_session.add(user)
    
    # Base droit
    droit = Droit(poste="P_RH_01", role="APPROBATEUR", designation="Chef", structure="STR_RH", libell_structure="Service RH", direction="DRH", libell_direction="DRH", agent_ident="AG0001", agent="BENALI Mohamed", compte="user01")
    db_session.add(droit)

    # Base demande en attente
    demande1 = Demande(num=1, approbation=0, traitement=0, agent_structure="STR_RH")
    # Base demande approuvée
    demande2 = Demande(num=2, approbation=1, traitement=1, agent_structure="STR_RH")

    db_session.add_all([demande1, demande2])
    await db_session.commit()

@pytest.fixture
def auth_headers() -> dict:
    access_token = create_access_token(data={"compte": "user01", "agent_ident": "AG0001"})
    return {"Authorization": f"Bearer {access_token}"}
