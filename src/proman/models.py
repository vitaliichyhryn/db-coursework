from enum import Enum

from sqlmodel import Field, SQLModel

class Status(str, Enum):
    ACTIVE = "ACTIVE"
    BANNED = "BANNED"


class User(SQLModel, table=True):
    id: int | None = Field(default=None, primary_key=True)
    name: str = Field(max_length=255)
    email: str = Field(max_length=255)
    password: str = Field(max_length=255)
    profile_picture: str | None = Field(default=None, max_length=255)
    status: Status = Field(default=Status.ACTIVE)
