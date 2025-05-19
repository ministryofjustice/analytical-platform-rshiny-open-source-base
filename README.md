# Analytical Platform RShiny Open Source Base

[![Ministry of Justice Repository Compliance Badge](https://github-community.service.justice.gov.uk/repository-standards/api/analytical-platform-rshiny-open-source-base/badge)](https://github-community.service.justice.gov.uk/repository-standards/analytical-platform-rshiny-open-source-base)

[![Open in Dev Container](https://raw.githubusercontent.com/ministryofjustice/.devcontainer/refs/heads/main/contrib/badge.svg)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/ministryofjustice/analytical-platform-rshiny-open-source-base)

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/ministryofjustice/analytical-platform-rshiny-open-source-base)


This repository contains the RShiny Open Source Base container image for use on the Analytical Platform.

## Running Locally

### Build

```bash
docker build --platform linux/amd64 --file Dockerfile --tag analytical-platform.service.justice.gov.uk/rshiny-open-source-base:local .
```

### Run

```bash
docker run -it --rm \
  --platform linux/amd64 \
  --name analytical-platform-rshiny-open-source-base \
  analytical-platform.service.justice.gov.uk/rshiny-open-source-base:local
```

## Versions

### Ubuntu

Generally Dependabot does this, but the following command will return the digest:

```bash
docker pull --platform linux/amd64 rocker/r-ver:{R_VERSION}

docker image inspect --format='{{index .RepoDigests 0}}' rocker/r-ver:{R_VERSION}
```

### APT Packages

To find latest APT package versions, you can run the following:

```bash
docker run -it --rm --platform linux/amd64 rocker/r-ver:{R_VERSION}

apt-get update

apt-cache policy ${PACKAGE} # for example curl, git or gpg
```
