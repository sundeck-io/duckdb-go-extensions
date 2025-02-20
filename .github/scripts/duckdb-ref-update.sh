#!/usr/bin/env bash

set -euo pipefail

fetch_latest_ref() {
  local REPO=$1
  local REF_TYPE=$2

  if [ "$REF_TYPE" = "release" ]; then
    local TAG=$(gh release -R "$REPO" list --json tagName,isLatest --jq '.[] | select(.isLatest).tagName')
    local LATEST_REF=$(gh api repos/"$REPO"/git/ref/tags/"$TAG" --jq '.object.sha')
  else
    local LATEST_REF=$(gh api repos/"$REPO"/git/refs/heads/main --jq '.object.sha')
  fi

  echo "$LATEST_REF"
}

update_makefile() {
  local REF_VAR_NAME="$1"
  local LATEST_REF="$2"

  if grep -q "^.*${REF_VAR_NAME} *= *${LATEST_REF}" Makefile; then
    return
  fi

  if [[ "$(uname)" == "Darwin" ]]; then
    sed -i '' "s|^\\(.*${REF_VAR_NAME} *\\)=.*|\\1=${LATEST_REF}|" Makefile
  else
    sed -i "s|^\\(.*${REF_VAR_NAME} *\\)=.*|\\1=${LATEST_REF}|" Makefile
  fi

  echo "\\n-Updated ${REF_VAR_NAME} to ${LATEST_REF}"
}
