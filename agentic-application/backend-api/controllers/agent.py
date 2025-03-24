import json
from logging import getLogger

import azure.functions as func
import pydantic_core
from azure.functions import AuthLevel
from azure.monitor.opentelemetry import configure_azure_monitor

from models.agents import ChatRequest
from utils.function_utils import APISuccessOK

configure_azure_monitor()
logger = getLogger(__name__)

agent_crud_controller = func.Blueprint()

@agent_crud_controller.function_name("agent_controller")
@agent_crud_controller.route(route="agents/chat", methods=["POST"],
                                  auth_level=AuthLevel.FUNCTION)
def agent_controller(req: func.HttpRequest) -> func.HttpResponse:
    logger.info('Python HTTP trigger function processed a request.')

    request_method = req.method.upper()

    logger.info(f"Agent Chant REST Service Request method: {request_method}")

    return handle_post_request(req)


def handle_post_request(request: func.HttpRequest) -> func.HttpResponse:
    request_body_bytes = request.get_body()

    chat_request = pydantic_core.from_json(request_body_bytes)
    chat_input = ChatRequest.model_validate_json(chat_request)


    response = json.dumps(chat_input)
    return APISuccessOK(response).build_response()