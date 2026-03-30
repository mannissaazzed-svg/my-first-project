from typing import Optional, List
from datetime import datetime
from pydantic import BaseModel

class DemandeBase(BaseModel):
    num: int
    group: Optional[int] = None
    date_etablissement: Optional[datetime] = None
    approbation: int = 0
    date_depart: Optional[datetime] = None
    date_retour: Optional[datetime] = None
    mode_transport: Optional[str] = None
    lieu: Optional[str] = None
    objet: Optional[str] = None
    parcours: Optional[str] = None
    agent: Optional[str] = None
    agent_ident: Optional[str] = None
    agent_structure: Optional[str] = None
    agent_direction: Optional[str] = None
    date_lecture: Optional[datetime] = None
    date_action: Optional[datetime] = None
    acteur_ident: Optional[str] = None
    acteur: Optional[str] = None
    acteur_poste: Optional[str] = None
    acteur_poste_structure: Optional[str] = None
    destinataire_ident: Optional[str] = None
    destinataire: Optional[str] = None
    destinataire_poste: Optional[str] = None
    destinataire_poste_structure: Optional[str] = None
    traitement: int = 0

class DemandeResponse(DemandeBase):
    model_config = {"from_attributes": True}

class PaginatedDemandesResponse(BaseModel):
    total: int
    page: int
    size: int
    items: List[DemandeResponse]

class DemandeActionResponse(BaseModel):
    message: str
    num: int

class RejeterRequestMode(BaseModel):
    motif: Optional[str] = None
