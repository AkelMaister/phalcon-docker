branch=$(git rev-parse --abbrev-ref HEAD | awk -F '/' '{print $NF}')
sudo docker build -t akel/phalcon:${branch} .
sudo docker push akel/phalcon:${branch}
