from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config import settings
from app.db.session import engine
from app.db.base import Base
from app.api.v1.router import api_router
from app.core.exceptions import register_exception_handlers

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup : en mode DEBUG, créer les tables automatiquement
    # En production → utiliser Alembic uniquement
    if settings.DEBUG:
        async with engine.begin() as conn:
            await conn.run_sync(Base.metadata.create_all)
    yield
    # Shutdown : libérer le pool de connexions
    await engine.dispose()

app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION,
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan,
)

# CORS — permissif pour le POC, à restreindre en production
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

register_exception_handlers(app)
app.include_router(api_router, prefix=settings.API_V1_PREFIX)

@app.get("/health", tags=["Monitoring"])
async def health_check():
    return {"status": "ok", "version": settings.APP_VERSION}


