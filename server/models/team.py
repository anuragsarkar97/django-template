import uuid

from beanie import Document
from datetime import date, datetime


class Team(Document):
    created_at: date = datetime.now()
    updated_at: date = datetime.now()
    name: str = None
    is_active: bool = True
    team_id: uuid.UUID = None
    parent_user_id: uuid.UUID = None
