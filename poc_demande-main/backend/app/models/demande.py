from sqlalchemy import Column, Integer, String, SmallInteger, DateTime
from app.db.base import Base

class Demande(Base):
    __tablename__ = "demande"

    num                          = Column(Integer, primary_key=True, index=True)
    group                        = Column(Integer)
    date_etablissement           = Column(DateTime)
    approbation                  = Column(SmallInteger, default=0, index=True)
    date_depart                  = Column(DateTime)
    date_retour                  = Column(DateTime)
    mode_transport               = Column(String(30))
    lieu                         = Column(String(70))
    objet                        = Column(String(300))
    parcours                     = Column(String(150))
    agent                        = Column(String(70))
    agent_ident                  = Column(String(6))
    agent_structure              = Column(String(9), index=True)
    agent_direction              = Column(String(9))
    date_lecture                 = Column(DateTime)
    date_action                  = Column(DateTime)
    acteur_ident                 = Column(String(6))
    acteur                       = Column(String(70))
    acteur_poste                 = Column(String(50))
    acteur_poste_structure       = Column(String(150))
    destinataire_ident           = Column(String(6))
    destinataire                 = Column(String(70))
    destinataire_poste           = Column(String(50))
    destinataire_poste_structure = Column(String(150))
    traitement                   = Column(SmallInteger, default=0)
