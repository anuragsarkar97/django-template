from fastapi import APIRouter

router = APIRouter(
    prefix="/users",
    tags=["users"],
    responses={404: {"description": "Not found"}},
)


@router.get("/", tags=["users"])
async def get_users():
    return [{"name": "Harry"}, {"name": "Ron"}]
