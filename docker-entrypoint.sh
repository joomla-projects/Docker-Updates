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

echo "=> Configure git"
git config --global user.name "${GIT_USER_NAME}"
git config --global user.email "${GIT_USER_EMAIL}"
git config --global pull.rebase false;

if [[ -d updates/.git ]]; then
  cd updates; \
  git checkout "${GIT_BRANCH_NAME}"; \
  git pull; \
  git fetch origin/main || true; \
  git rebase main || true
else
  /usr/bin/gh repo clone "${GIT_URL}"
  cd updates; \
  git checkout "${GIT_BRANCH_NAME}"; \
  git fetch origin/main || true; \
  git rebase main || true
fi

if [[ $1 == "update-timestamp" ]]; then
  echo "=> TUF Updation timestamp"
  /go/bin/tuf timestamp
  /go/bin/tuf commit
else
  /go/bin/tuf "$1"
fi
