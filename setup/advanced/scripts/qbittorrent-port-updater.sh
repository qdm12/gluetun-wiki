#!/bin/sh

LISTEN_PORT="$1"
QBIT_PROTOCOL="${QBIT_PROTOCOL:-http}"
QBIT_HOST="${QBIT_HOST:-127.0.0.1}"
QBIT_PORT="${QBIT_PORT:-8080}"

# add curl if not already installed
apk info | grep -q ^curl || apk add curl

# syntax specific to sh
for run in $(seq 1 10)
do
  echo "Try $run/10 to set port to $LISTEN_PORT"
  curl -ks --data 'json={"listen_port": "'"$LISTEN_PORT"'"}' ${QBIT_PROTOCOL}://${QBIT_HOST}:${QBIT_PORT}/api/v2/app/setPreferences
  if [ $? -eq 0 ]; then
      echo "Port $LISTEN_PORT set successfully"
      break
  fi
  echo "Failed to set port, retrying in 5 seconds"
  sleep 5
done
