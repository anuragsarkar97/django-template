import os

from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    app_port: int = os.getenv("APP_PORT", 8000)
    app_env: str = os.getenv("APP_ENV", "development")
    app_debug: bool = os.getenv("APP_DEBUG", True)

    mongo_url: str = os.getenv("MONGO_URL", "mongodb://localhost:27017")


settings = Settings()
