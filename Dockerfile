FROM docker.io/jlesage/baseimage-gui:ubuntu-24.04-v4.7

ARG BISQ_VERSION=2.1.7

ENV BISQ_DEBFILE Bisq-$BISQ_VERSION.deb
ENV BISQ_DOL_URL https://github.com/bisq-network/bisq2/releases/download/v$BISQ_VERSION/$BISQ_DEBFILE
ENV BISQ_ASC_URL https://github.com/bisq-network/bisq2/releases/download/v$BISQ_VERSION/$BISQ_DEBFILE.asc
ENV BISQ_PGP_KEY1 B493319106CC3D1F252E19CBF806F422E222AA02
ENV BISQ_PGP_KEY2 B8A5D214ADFAA387A14C8BCF02AA2BAE387C8307 # not available in keyserver.ubuntu.com

WORKDIR /tmp

RUN \
    apt update \
    && apt install -y \
        java-common \
        openjdk-8-jre \
        libgtk-3-dev \
        openjfx \
        fonts-dejavu \
        wget \
        curl \
        binutils \
        gpg \
        gpg-agent \
        ca-certificates \
        xdg-utils \
        tor

RUN mkdir -p ~/.gnupg && \
    echo "pinentry-mode loopback" >> ~/.gnupg/gpg.conf && \
    echo "allow-loopback-pinentry" >> ~/.gnupg/gpg-agent.conf

RUN \
    APP_ICON_URL="https://avatars.githubusercontent.com/u/6928048?s=256&v=4" && \
    install_app_icon.sh "$APP_ICON_URL"

# this will result in usless stuff inside the layer but help us to debug problems more easy
RUN mkdir bisq-install \
    && cd bisq-install \
    && wget -qO $BISQ_DEBFILE "$BISQ_DOL_URL" \
    && wget -qO Bisq.asc "$BISQ_ASC_URL"

# download BISQ_PGP_KEY2
RUN curl https://bisq.network/pubkey/387C8307.asc | gpg --import || true

RUN cd bisq-install \
    && gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys "$BISQ_PGP_KEY1" \
    && gpg --digest-algo SHA256 --verify Bisq.asc $BISQ_DEBFILE \
    && mkdir -p /usr/share/desktop-directories /usr/share/applications

RUN cd bisq-install \
    && dpkg -i $BISQ_DEBFILE \
    && cd .. \
    && rm -rf bisq-install

RUN \
    set-cont-env APP_NAME "Bisq 2" && \
    set-cont-env DOCKER_IMAGE_VERSION "$BISQ_VERSION" && \
    true

LABEL \
  org.label-schema.name="bisq-2" \
  org.label-schema.description="A peer-to-peer bitcoin exchange system" \
  org.label-schema.version="${BISQ_VERSION:-dev}" \
  org.label-schema.vcs-url="https://github.com/bisq-network/bisq2" \
  org.label-schema.schema-version="1.0"

COPY rootfs/ /

RUN mkdir -p /data && chown 1000:1000 /data

VOLUME ["/data"]

RUN chmod +x /startapp.sh

