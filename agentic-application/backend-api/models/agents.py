from pydantic import BaseModel


class ChatRequest(BaseModel):
    agent_id: str