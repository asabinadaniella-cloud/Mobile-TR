from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.errors import RateLimitExceeded
from slowapi.middleware import SlowAPIMiddleware
from slowapi.util import get_remote_address

from .core.config import get_settings
from .routers import auth, chat, files, push, reports, responses, survey, users

settings = get_settings()
limiter = Limiter(key_func=get_remote_address, default_limits=[
    f"{settings.rate_limit_requests}/{settings.rate_limit_window_seconds} seconds"
])

app = FastAPI(title=settings.app_name, debug=settings.debug)
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)
app.add_middleware(SlowAPIMiddleware)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(users.router)
app.include_router(survey.router)
app.include_router(responses.router)
app.include_router(reports.router)
app.include_router(chat.router)
app.include_router(files.router)
app.include_router(push.router)


@app.get("/health", tags=["system"])
@limiter.limit("10/60 seconds")
async def healthcheck():
    return {"status": "ok"}
