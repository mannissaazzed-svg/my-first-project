from pydantic import BaseModel

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    compte: str
    agent_ident: str

class LoginSchema(BaseModel):
    compte: str
    password: str
