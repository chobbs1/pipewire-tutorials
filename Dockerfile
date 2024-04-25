FROM ubuntu:22.04 AS pw_build

LABEL description="Ubuntu-based stage for building pipewire" \
    maintainer="Walker Griggs <walker@walkergriggs.com>"

RUN apt-get update \
    && apt-get install -y \
    debhelper-compat \
    findutils        \
    git              \
    libasound2-dev   \
    libdbus-1-dev    \
    libglib2.0-dev   \
    libsbc-dev       \
    libsdl2-dev      \
    libudev-dev      \
    libva-dev        \
    libv4l-dev       \
    libx11-dev       \
    ninja-build      \
    pkg-config       \
    python3-docutils \
    python3-pip      \
    meson            \
    pulseaudio       \
    dbus-x11         \
    rtkit            \
    xvfb

ARG PW_VERSION=1.0.5
ENV PW_ARCHIVE_URL="https://gitlab.freedesktop.org/pipewire/pipewire/-/archive"
ENV PW_TAR_FILE="pipewire-${PW_VERSION}.tar"
ENV PW_TAR_URL="${PW_ARCHIVE_URL}/${PW_VERSION}/${PW_TAR_FILE}"

ENV BUILD_DIR_BASE="/root"
ENV BUILD_DIR="${BUILD_DIR_BASE}/build-$PW_VERSION"

RUN curl -LJO $PW_TAR_URL \
    && tar -C $BUILD_DIR_BASE -xvf $PW_TAR_FILE

WORKDIR $BUILD_DIR_BASE/pipewire-${PW_VERSION}
RUN meson setup $BUILD_DIR
RUN meson configure $BUILD_DIR -Dprefix=/usr
RUN meson compile -C $BUILD_DIR
RUN meson install -C $BUILD_DIR

COPY entrypoint.sh /root/entrypoint.sh

WORKDIR /root
CMD ["/bin/bash", "entrypoint.sh"]