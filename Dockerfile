# checkov:skip=CKV_DOCKER_2:Healthcheck instructions have not been added to container images
# checkov:skip=CKV_DOCKER_3:"Ensure that a user for the container has been created"
# hadolint global ignore=DL3008

FROM docker.io/rocker/r-ver:4.6.1@sha256:780bc87219250a6dfffef6c812999731986fd94d8d5f7e572d1157c923d1b4bb

ARG shinyserver=1.5.24.1035
ENV SHINY_SERVER_VERSION=${shinyserver}
ENV PANDOC_VERSION=3.10

# Retry flaky Ubuntu mirrors instead of failing the build on one timeout
RUN printf 'Acquire::Retries "5";\nAcquire::http::Timeout "30";\nAcquire::https::Timeout "30";\n' \
      > /etc/apt/apt.conf.d/80-retries

RUN /rocker_scripts/install_shiny_server.sh

ENV STRINGI_DISABLE_PKG_CONFIG=true \
  AWS_DEFAULT_REGION=eu-west-1 \
  TZ=Etc/UTC \
  LC_ALL=C.UTF-8

WORKDIR /srv/shiny-server

# Cleanup shiny-server dir
RUN rm -rf ./*

# Make sure the directory for individual app logs exists
RUN mkdir -p /var/log/shiny-server

# Ensure Python venv is installed (used by reticulate).
RUN apt-get update -y && \
  apt-get install -y --no-install-recommends \
  python3 \
  python3-pip \
  python3-venv \
  python3-dev \
  libxml2-dev \
  libssl-dev \
  libudunits2-dev \
  libgdal-dev \
  libgeos-dev \
  libproj-dev \
  linux-libc-dev \
  gdal-bin \
  git \
  libssl-dev \
  libsqlite3-dev \
  python3-boto \
  xtail \
  libncursesw6=6.4+20240113-1ubuntu2.2 \
  libtinfo6=6.4+20240113-1ubuntu2.2 \
  ncurses-base=6.4+20240113-1ubuntu2.2 \
  ncurses-bin=6.4+20240113-1ubuntu2.2 \
  gzip=1.12-1ubuntu3.2 \
  libc6=2.39-0ubuntu8.12 \
  libc-bin=2.39-0ubuntu8.12 \
  libc-dev-bin=2.39-0ubuntu8.12 \
  libc6-dev=2.39-0ubuntu8.12 \
  locales=2.39-0ubuntu8.12 \
  apt=2.8.4ubuntu0.1 \
  libapt-pkg6.0t64=2.8.4ubuntu0.1


# APT Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/

COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY shiny-server.sh /usr/bin/shiny-server.sh
COPY gather_env_vars.py .

# Patch the shiny server to allow custom headers
RUN sed -i 's/createWebSocketClient(pathInfo)/createWebSocketClient(pathInfo, conn.headers)/' /opt/shiny-server/lib/proxy/sockjs.js
RUN sed -i "s/'referer'/'referer', 'cookie', 'user_email'/" /opt/shiny-server/node_modules/sockjs/lib/transport.js

# Shiny runs as 'shiny' user, adjust app directory permissions
RUN userdel --force systemd-network
RUN groupmod -g 998 shiny
RUN usermod -u 998 -g 998 shiny
RUN chown -R 998:998 .
RUN chown -R 998:998 /etc/shiny-server
RUN chown -R 998:998 /var/lib/shiny-server

RUN chown -R 998:998 /opt/shiny-server
RUN chown -R 998:998 /var/log/shiny-server
RUN chown -R 998:998 /etc/init.d/shiny-server
RUN chown -R 998:998 /usr/local/lib/R/etc
RUN chown -R 998:998 /usr/local/lib/R/site-library
RUN chown 998:998 /usr/bin/shiny-server.sh
RUN chmod +x /usr/bin/shiny-server.sh

RUN chown 998:998 /etc/profile

EXPOSE 9999

CMD ["/usr/bin/shiny-server.sh"]
