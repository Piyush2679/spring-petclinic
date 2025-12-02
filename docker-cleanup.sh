#!/usr/bin/env bash
set -euo pipefail
AGGRESSIVE=false
if [[ "${1:-}" == "--aggressive" ]]; then AGGRESSIVE=true; fi
echo "Removing exited containers..."
docker ps -a -f "status=exited" -q | xargs -r docker rm
echo "Removing dangling images..."
docker images -f "dangling=true" -q | xargs -r docker rmi || true
if $AGGRESSIVE; then
  docker image prune -a -f
  docker volume prune -f
  docker network prune -f
else
  docker system prune -f
fi
echo "Done."
