import urllib
from typing import Annotated

from fastapi import Depends
from sqlmodel import Session, create_engine

user = "root"
password = "%vU9OGA8$^TmI!Ot"
host = "localhost"
port = "3306"
database = "proman"
databse_url = f"mysql+pymysql://{user}:{password}@{host}:{port}/{database}"

engine = create_engine(databse_url, echo=True)

def get_session():
    with Session(engine) as session:
        yield session

SessionDep = Annotated[Session, Depends(get_session)]
