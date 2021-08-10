#!/usr/bin/env sh

# Scores should placed at `s2-quiz-{dev|prod}/production/score/{project}.json`

set -e

CDN_AUTH=$(echo $CDN_AUTH | base64 --decode)

CDN_SPACE="gs://delaware-online/datasets/"
PUBLIC_PATH="https://www.gannett-cdn.com/delaware-online/datasets"
CDN_PATH="https://$CDN_AUTH@www.gannett-cdn.com/delaware-online/datasets"

FILENAME="lotteries.csv"
PROJECT="lotteries"

gsutil cp "$FILENAME" "$CDN_SPACE/$PROJECT"
gsutil acl set public-read "$CDN_SPACE/$PROJECT"

curl -X PURGE --user "$CDN_AUTH" "$PUBLIC_PATH/$PROJECT"
