branch=$(git rev-parse --abbrev-ref HEAD | awk -F '/' '{print $NF}')
docker build -t akel/phalcon:${branch} .
