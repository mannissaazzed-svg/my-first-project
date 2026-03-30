from sqlalchemy import Column, Integer, String
from app.db.base import Base

class Droit(Base):
    __tablename__ = "droit"

    id               = Column(Integer, primary_key=True, index=True)
    num              = Column(Integer)
    poste            = Column(String(12), nullable=False)
    role             = Column(String(15), nullable=False)
    designation      = Column(String(80), nullable=False)
    structure        = Column(String(9), nullable=False, index=True)
    libell_structure = Column(String(100), nullable=False)
    direction        = Column(String(4), nullable=False)
    libell_direction = Column(String(100), nullable=False)
    agent_ident      = Column(String(6), nullable=False)
    agent            = Column(String(40), nullable=False)
    poste_parent     = Column(String(12))
    compte           = Column(String(10), nullable=False, index=True)
