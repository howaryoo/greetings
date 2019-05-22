import logging.config

import responder

from greetings.util import get_local_ip
from configuration.environment import API_PORT

logging.config.fileConfig("log.ini")

logger = logging.getLogger(__name__)

api = responder.API()


@api.route("/greetings")
@api.route("/greetings/{who}")
async def greetings(req, resp, *, who='Stranger'):
    logger.info("greeting: %s", who)

    resp.media = {"Hello": who, "server IP": await get_local_ip()}

if __name__ == "__main__":
    api.run(address="0.0.0.0", port=API_PORT)
