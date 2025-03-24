import azure.functions as func
from azure.monitor.opentelemetry import configure_azure_monitor

from controllers.agent import agent_crud_controller

configure_azure_monitor()

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

app.register_functions(agent_crud_controller)

