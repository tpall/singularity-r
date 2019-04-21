#!/bin/bash

if [ -z "$2" ]; then
  echo -e "WARNING!!\nYou need to pass the WEBHOOK_URL environment variable as the second argument to this script." && exit
fi

WEBHOOK_DATA='{
  "ref": "master",
  "payload": {
    "deploy": "migrate"
  },
  "description": "Deploy request from travis-ci"
}'

(curl --fail --progress-bar -A "TravisCI-Webhook" -H Content-Type:application/json -d "$WEBHOOK_DATA" "$2" \
  && echo -e "\\n[Webhook]: Successfully sent the webhook.") || echo -e "\\n[Webhook]: Unable to send webhook."
