from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse

class DemandeNotFoundException(Exception):
    """Levée quand une demande n'existe pas"""

class DemandeAlreadyTreatedException(Exception):
    """Levée quand on tente de traiter une demande déjà approuvée ou rejetée"""

class InvalidCredentialsException(Exception):
    """Levée en cas d'identifiants invalides"""

class UnauthorizedException(Exception):
    """Levée quand le token est absent, invalide ou expiré"""

def register_exception_handlers(app: FastAPI):
    @app.exception_handler(DemandeNotFoundException)
    async def not_found_handler(request: Request, exc: DemandeNotFoundException):
        return JSONResponse(status_code=404, content={"detail": str(exc) or "Demande non trouvée"})
    
    @app.exception_handler(DemandeAlreadyTreatedException)
    async def already_treated_handler(request: Request, exc: DemandeAlreadyTreatedException):
        return JSONResponse(status_code=409, content={"detail": str(exc) or "Demande déjà traitée"})
    
    @app.exception_handler(InvalidCredentialsException)
    async def invalid_credentials_handler(request: Request, exc: InvalidCredentialsException):
        return JSONResponse(status_code=401, content={"detail": str(exc) or "Identifiants invalides"})
    
    @app.exception_handler(UnauthorizedException)
    async def unauthorized_handler(request: Request, exc: UnauthorizedException):
        return JSONResponse(status_code=401, content={"detail": str(exc) or "Token invalide ou expiré", "headers": {"WWW-Authenticate": "Bearer"}})
