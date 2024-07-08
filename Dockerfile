ARG ALPINE_VER="3.20"
ARG BASEIMAGE_ARCH="amd64"

FROM ${BASEIMAGE_ARCH}/alpine:${ALPINE_VER}

LABEL Description="Multiarch Alpine base image with Jemalloc library"

ARG ALPINE_VER
ARG QEMU_ARCH

ARG BRANCH="none"
ARG COMMIT="local-build"
ARG BUILD_DATE="1970-01-01T00:00:00Z"
ARG NAME="kurapov/alpine-jemalloc"
ARG VCS_URL="https://github.com/2sheds/alpine-jemalloc"

ARG MAKEFLAGS=-j4
ARG VERSION="5.3.0"

LABEL \
  org.opencontainers.image.authors="Oleg Kurapov <oleg@kurapov.com>" \
  org.opencontainers.image.title="${NAME}" \
  org.opencontainers.image.created="${BUILD_DATE}" \
  org.opencontainers.image.revision="${COMMIT}" \
  org.opencontainers.image.version="${VERSION}" \
  org.opencontainers.image.source="${VCS_URL}"

#__CROSS_COPY qemu-${QEMU_ARCH}-static /usr/bin/

RUN apk add --no-cache --virtual=build-dependencies build-base linux-headers && \
    mkdir /usr/src && \
    wget -O - https://github.com/jemalloc/jemalloc/releases/download/${VERSION}/jemalloc-${VERSION}.tar.bz2 | tar -xjf - -C /usr/src && \
    cd /usr/src/jemalloc-${VERSION} && \
    ./configure --disable-cxx --disable-prof-libgcc && \
    make && \
    make install && \
    apk del build-dependencies && \
    rm -rf /tmp/* /var/tmp/* /usr/src/* /var/apk/cache/*

ENV LD_PRELOAD=/usr/local/lib/libjemalloc.so.2

