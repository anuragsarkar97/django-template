from beanie import init_beanie
import motor.motor_asyncio

from models.team import Team
from models.user import User
from settings import settings


async def init_db():
    client = motor.motor_asyncio.AsyncIOMotorClient(
        settings.mongo_url
    )

    await init_beanie(database=client.db_name,
                      document_models=[
                          User,
                          Team
                      ])
