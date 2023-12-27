import uuid

from beanie import Document
from datetime import date, datetime


class User(Document):
    created_at: date = datetime.now()
    updated_at: date = datetime.now()
    email: str = None
    email_verified_at: date = None
    password_salt: str = None
    name: str = None
    is_active: bool = True
    team_id: uuid.UUID = None
