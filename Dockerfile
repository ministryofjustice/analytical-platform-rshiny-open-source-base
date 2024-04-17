# checkov:skip=CKV_DOCKER_2:Healthcheck instructions have not been added to container images
# This image is an example base image for this template and can be replaced to fit user needs
FROM public.ecr.aws/ubuntu/ubuntu@sha256:676f54056adb852b7fc9b42db4bc82fbd8fbab4bdc5027b1c30e0d53393ab602

LABEL org.opencontainers.image.vendor="Ministry of Justice" \
      org.opencontainers.image.authors="Analytical Platform (analytical-platform@digital.justice.gov.uk)"\
      org.opencontainers.image.title="{image title}" \
      org.opencontainers.image.description="{decription}" \
      org.opencontainers.image.url="{your repo url}"

ENV CONTAINER_USER="analyticalplatform" \
    CONTAINER_UID="1000" \
    CONTAINER_GROUP="analyticalplatform" \
    CONTAINER_GID="1000" \
    DEBIAN_FRONTEND="noninteractive"

SHELL ["/bin/bash", "-e", "-u", "-o", "pipefail", "-c"]

# User
RUN <<EOF
groupadd \
  --gid ${CONTAINER_GID} \
  ${CONTAINER_GROUP}

useradd \
  --uid ${CONTAINER_UID} \
  --gid ${CONTAINER_GROUP} \
  --create-home \
  --shell /bin/bash \
  ${CONTAINER_USER}
EOF

# Base
RUN <<EOF
apt-get update --yes

apt-get install --yes \
  "apt-transport-https=2.4.12" \
  "curl=7.81.0-1ubuntu1.16"

apt-get clean --yes

rm --force --recursive /var/lib/apt/lists/*
EOF

USER ${CONTAINER_USER}

WORKDIR /home/${CONTAINER_USER}

