from typing import Any

import jwt
from datetime import datetime, timedelta


class JWTUtils:

    def __init__(self, jwt_secret: str):
        self.jwt_secret = jwt_secret
        self.algorithm = "HS256"

    def encode_token(self, payload: dict[str, Any]):
        jwt_token = jwt.encode(payload, self.jwt_secret, algorithm=self.algorithm)
        return jwt_token

    def decode_token(self, token: str):
        payload = jwt.decode(token, self.jwt_secret, algorithms=self.algorithm)
        return payload

    def generate_gk_credentials(self, user_id: str, name: str, username: str, email: str, membership='explorers'):

        payload = {
            "sub": user_id,
            "name": name,
            "username": username,
            "email": email,
            "membership": membership,
            "exp": datetime.utcnow() + timedelta(hours=7)
        }

        return self.encode_token(payload)
