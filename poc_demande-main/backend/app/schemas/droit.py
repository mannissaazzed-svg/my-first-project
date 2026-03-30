from typing import Optional
from pydantic import BaseModel

class DroitResponse(BaseModel):
    id: int
    num: Optional[int] = None
    poste: str
    role: str
    designation: str
    structure: str
    libell_structure: str
    direction: str
    libell_direction: str
    agent_ident: str
    agent: str
    poste_parent: Optional[str] = None
    compte: str

    model_config = {"from_attributes": True}
