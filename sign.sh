#!/bin/bash
echo "=> Reading local git environment"
GIT_USER_NAME=$(git config user.name)
GIT_USER_EMAIL=$(git config user.email)
echo "=> Asking for needed User inputs"
read -rp "Branch to use for signage: " GIT_BRANCH_NAME
read -srp "Github Personall Access Token: " ACCESS_TOKEN
echo ""
read -rp "Paramters to be passed to TUF: " TUF_PARAMS

echo "=> Run signing process"

if [[ $TUF_PARAMS = "bash" ]]; then
    docker run -ti --entrypoint /bin/bash \
        -e ACCESS_TOKEN="${ACCESS_TOKEN}"\
        -e GIT_BRANCH_NAME="${GIT_BRANCH_NAME}" \
        -e GIT_USER_NAME="${GIT_USER_NAME}" \
        -e GIT_USER_EMAIL="${GIT_USER_EMAIL}" \
        -v "$(pwd)/updates:/go/updates" joomla-tuf:latest
else
    docker run -e ACCESS_TOKEN="${ACCESS_TOKEN}"\
        -e GIT_BRANCH_NAME="${GIT_BRANCH_NAME}"\
        -e GIT_USER_NAME="${GIT_USER_NAME}"\
        -e GIT_USER_EMAIL="${GIT_USER_EMAIL}"\
        -e DEBUG=True \
        -v "$(pwd)/updates:/go/updates" joomla-tuf:latest "${TUF_PARAMS}"
fi