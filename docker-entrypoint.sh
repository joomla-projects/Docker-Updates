#!/bin/bash
set -o nounset
set -o pipefail
set -o errexit


if [[ -n ${DEBUG:-} ]]; then
  echo "=> DEBUG is enabled"
  echo "=> Your passed args are: $1"
  echo "=> TUF_VERSION: ${TUF_VERSION}"
  echo "=> ACCESS_TOKEN: ${ACCESS_TOKEN}"
  echo "=> GIT_URL: ${GIT_URL}"
  set -o xtrace
fi

echo "=> Setup Github CLI"
#/usr/bin/gh
/usr/bin/gh auth login --with-token <<< "${ACCESS_TOKEN}"

if [[ -d updates/.git ]]; then
  cd updates; \
  git config pull.rebase false; \
  git checkout "${GIT_BRANCH_NAME}"; \
  git pull; \
  cd ..
else
  /usr/bin/gh repo clone "${GIT_URL}"
  cd updates; \
  git checkout "${GIT_BRANCH_NAME}"; \
  cd ..
fi

/go/bin/tuf "$1"