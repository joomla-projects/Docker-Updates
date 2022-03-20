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
git config --global credential.https://github.com.username git

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
  git commit -am "Update timestamp"
  git push
elif [[ $1 == "release" ]]; then
  /go/bin/tuf snapshot
  /go/bin/tuf timestamp
  /go/bin/tuf commit
  git add .; git commit -m "Release: ${GIT_BRANCH_NAME}"
  git push
  PR_URL=$(/usr/bin/gh pr create --base main --title "Release: ${GIT_BRANCH_NAME}")
  /usr/bin/gh pr merge "${PR_URL}"
elif [[ $1 == "gen-template" ]]; then
  sed "s/\$VERSION/${UPDATE_VERSION}/g" /go/updates/templates/update-info-4.json | tee /go/update-info.json
  cat <<< $(jq '.["description"] = "'"${UPDATE_DESCRIPTION}"'"' /go/update-info.json) > /go/update-info.json
  cat <<< $(jq '.["infourl"]["url"] = "'"${UPDATE_INFO_URL}"'"' /go/update-info.json) > /go/update-info.json
  cat <<< $(jq '.["infourl"]["title"] = "'"${UPDATE_INFO_TITLE}"'"' /go/update-info.json) > /go/update-info.json
  cat <<< $(jq '.["name"] = "'"${UPDATE_NAME}"'"' /go/update-info.json) > /go/update-info.json
  cat <<< $(jq '.["version"] = "'"${UPDATE_VERSION}"'"' /go/update-info.json) > /go/update-info.json
  /go/bin/tuf add --custom="$(jq -c '.' /go/update-info.json)"
  git add .
  git commit -m "Prepare ${UPDATE_VERSION}"
  git push
else
  /go/bin/tuf "$1"
fi
