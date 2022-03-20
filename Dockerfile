FROM golang:1.16-bullseye@sha256:35fa3cfd4ec01a520f6986535d8f70a5eeef2d40fb8019ff626da24989bdd4f1

ENV TUF_VERSION=v0.1.0

RUN echo "=> Running apt-get udpate" && \
    apt-get update && \
    apt-get install git && \
    echo "=> Cleanup apt" && \
    rm -rf /var/cache/apt /var/lib/apt/lists

RUN echo "=> Install go-tuf" && \
    go get github.com/theupdateframework/go-tuf/cmd/tuf@$TUF_VERSION
