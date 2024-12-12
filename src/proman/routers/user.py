from fastapi import APIRouter, HTTPException, status
from sqlmodel import select

from proman.database import SessionDep
from proman.models import User

router = APIRouter(
    prefix="/users",
    tags=["users"],
    responses={404: {"description": "Not found"}},
)

@router.post("/", status_code=status.HTTP_201_CREATED)
async def create_user(user: User, session: SessionDep):
    session.add(user)
    session.commit()
    session.refresh(user)
    return user

@router.get("/", status_code=status.HTTP_200_OK)
async def read_user(session: SessionDep):
    users = session.exec(select(User)).all()
    return users

@router.get("/{user_id}", status_code=status.HTTP_200_OK)
async def read_user(user_id: int, session: SessionDep):
    user = session.get(User, user_id)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    return user

@router.patch("/{user_id}", status_code=status.HTTP_200_OK)
async def update_user(user_id: int, user: User, session: SessionDep):
    user_db = session.get(User, user_id)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    user_data = user.model_dump(exclude_unset=True)
    user_db.sqlmodel_update(user_data)
    session.add(user_db)
    session.commit()
    session.refresh(user_db)
    return user_db

@router.delete("/{user_id}", status_code=status.HTTP_200_OK)
async def delete_user(user_id: int, session: SessionDep):
    user = session.get(User, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    session.delete(user)
    session.commit()
    return {"ok": True}
