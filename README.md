## Environment variables:

`BLACKFIRE_ENABLE` - set `true` for enable blackfire php probe

`BLACKFIRE_AGENT_URL` - set fqdn name or ip address of blackfire agent. Default: `127.0.0.1`

`BLACKFIRE_AGENT_PORT` - set port of blackfire agent. Default: `8707`

## Build new Docker image

### Get current branch

branch=$(git rev-parse --abbrev-ref HEAD | awk -F '/' '{print $NF}')

### Build Docker image

sudo docker build -t akel/phalcon:${branch} .

### Push new docker image to registry

sudo docker push akel/phalcon:${branch}
