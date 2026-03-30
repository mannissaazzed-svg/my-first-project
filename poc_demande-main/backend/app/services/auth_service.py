from app.repositories.auth_repository import AuthRepository
from app.schemas.auth import LoginSchema, Token
from app.core.security import verify_password, create_access_token
from app.core.exceptions import InvalidCredentialsException

class AuthService:
    def __init__(self, repository: AuthRepository):
        self.repository = repository

    async def login(self, login_data: LoginSchema) -> Token:
        user = await self.repository.get_by_compte(login_data.compte)
        if not user or not user.is_active:
            raise InvalidCredentialsException()
        
        if not verify_password(login_data.password, user.hashed_password):
            raise InvalidCredentialsException()
        
        access_token = create_access_token(
            data={"compte": user.compte, "agent_ident": user.agent_ident}
        )
        return Token(access_token=access_token, token_type="bearer")
