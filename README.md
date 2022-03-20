# Joomla! TUF Docker

## VARS

| ⚠️ REQUIRED | VAR | DEFAULT | COMMENT |
| -- | ------------------ | -------- | -------------------------------------------------- |
| ⚠️ | GIT_BRANCH_NAME    |          | The Branch name to checkout in the Container       |
|    | TUF_VERSION        | `v0.1.0` | The go-tuf version insalled                        |
| ⚠️ | ACCESS_TOKEN       |          | Github Access token with access to the `GIT_RUL`   |
|    | GIT_URL            | <https://github.com/joomla/updates.git> | The Github Repo URL |
|    | GITHUB_CLI_VERSION | `2.6.0`  | The Github CLI Version to install                  |
| ⚠️ | GIT_USER_NAME      | ``       | git usernname for the gitconfig runtime |
| ⚠️ | GIT_USER_EMAIL     | ``       | git user.email for the gitconfig runtime |

## Setup

Build the Image

```bash
docker build -t joomla-tuf:latest -f Dockerfile .
```

Run your commands directly against tuf.
Use `-e` in `docker run` to pass ENV variables.

```bash
docker run -e ACCESS_TOKEN=REDACTED_TOKEN -e GIT_BRANCH_NAME=main joomla-tuf "help"
usage: tuf [-h|--help] [-d|--dir=<dir>] [--insecure-plaintext] <command> [<args>...]
```

## TODO

- Github CLI create MR from sign
- local volume/folder for joomla packages to singn

- Einen Command für:
  - sign von timestamp
  - sign von snapshot + commit
  
- command: update-timestamp
- command: bash