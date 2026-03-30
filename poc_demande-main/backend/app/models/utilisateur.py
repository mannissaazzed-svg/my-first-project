from sqlalchemy import Column, Integer, String, Boolean
from app.db.base import Base

class Utilisateur(Base):
    __tablename__ = "utilisateur"

    id              = Column(Integer, primary_key=True, index=True)
    compte          = Column(String(10), unique=True, nullable=False, index=True)
    hashed_password = Column(String(255), nullable=False)
    agent_ident     = Column(String(6), nullable=False)
    agent           = Column(String(70))
    is_active       = Column(Boolean, default=True)
