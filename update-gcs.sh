#!/usr/bin/env sh

# Scores should placed at `s2-quiz-{dev|prod}/production/score/{project}.json`

set -e

PROJECT=${1:-"lotteries"}

CDN_AUTH=$(echo $CDN_AUTH | base64 --decode)
BUCKET=${BUCKET:-"production"}

CDN_SPACE="gs://delaware-online/storytelling-embeds/$BUCKET/projects"
PUBLIC_PATH="https://www.gannett-cdn.com/delaware-online/storytelling-embeds/$BUCKET/projects"
CDN_PATH="https://$CDN_AUTH@www.gannett-cdn.com/delaware-online/storytelling-embeds/$BUCKET/projects"
FILENAME="2021-08-lotteries"

gsutil cp "lotteries.csv" "$CDN_SPACE/$FILENAME"
gsutil acl set public-read "$CDN_SPACE/$FILENAME"

curl -X PURGE --user "$CDN_AUTH" "$PUBLIC_PATH/$FILENAME"
