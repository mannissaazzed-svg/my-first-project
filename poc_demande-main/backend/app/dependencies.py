from fastapi import Depends
from fastapi.security import OAuth2PasswordBearer
from app.core.security import decode_token
from app.core.exceptions import UnauthorizedException
from app.schemas.auth import TokenData

from app.config import settings

# OAuth2 logic using standard /auth/login route
# We point Swagger to the dedicated form-data login route.
oauth2_scheme = OAuth2PasswordBearer(tokenUrl=f"{settings.API_V1_PREFIX}/auth/login/swagger")

async def get_current_user(token: str = Depends(oauth2_scheme)) -> TokenData:
    payload = decode_token(token)
    compte: str = payload.get("compte")
    agent_ident: str = payload.get("agent_ident")
    if compte is None or agent_ident is None:
        raise UnauthorizedException("Token invalide ou expiré")
    return TokenData(compte=compte, agent_ident=agent_ident)
