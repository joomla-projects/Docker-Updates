FROM golang:1.16-bullseye@sha256:35fa3cfd4ec01a520f6986535d8f70a5eeef2d40fb8019ff626da24989bdd4f1

ENV TUF_VERSION=v0.1.0
ENV GIT_URL=https://github.com/joomla/updates.git
ENV GITHUB_CLI_VERSION=2.6.0
ENV GIT_ASKPASS=/go/git_env_password.sh

RUN echo "=> Running apt-get udpate" && \
    apt-get update && \
    apt-get install git jq -y && \
    echo "=> Install Github CLI" && \
    wget -O github-cli.deb https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/gh_${GITHUB_CLI_VERSION}_linux_amd64.deb && \
    dpkg -i github-cli.deb && \
    apt-get install -f && \
    echo "=> Cleanup apt" && \
    rm -rf /var/cache/apt /var/lib/apt/lists github-cli.deb

RUN echo "=> Install go-tuf" && \
    go get github.com/theupdateframework/go-tuf/cmd/tuf@$TUF_VERSION

COPY docker-entrypoint.sh /go/docker-entrypoint.sh
COPY git_env_password.sh /go/git_env_password.sh
RUN chmod +x /go/docker-entrypoint.sh

ENTRYPOINT ["/go/docker-entrypoint.sh"]
CMD ["/go/docker-entrypoint.sh"]
