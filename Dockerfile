ARG ALPINE_VER="3.10"
ARG PYTHON_VER="3.7"
ARG BASEIMAGE_ARCH="amd64"

FROM ${BASEIMAGE_ARCH}/python:${PYTHON_VER}-alpine${ALPINE_VER}

LABEL Description="Multiarch Alpine-flavored Python with Jemalloc library"

ARG ALPINE_VER
ARG QEMU_ARCH

ARG BRANCH="none"
ARG COMMIT="local-build"
ARG BUILD_DATE="1970-01-01T00:00:00Z"
ARG NAME="kurapov/alpine-python-jemalloc"
ARG VCS_URL="https://github.com/2sheds/alpine-python-jemalloc"

ARG MAKEFLAGS=-j4
ARG VERSION="5.2.1"

LABEL \
  org.opencontainers.image.authors="Oleg Kurapov <oleg@kurapov.com>" \
  org.opencontainers.image.title="${NAME}" \
  org.opencontainers.image.created="${BUILD_DATE}" \
  org.opencontainers.image.revision="${COMMIT}" \
  org.opencontainers.image.version="${VERSION}" \
  org.opencontainers.image.source="${VCS_URL}"

#__CROSS_COPY qemu-${QEMU_ARCH}-static /usr/bin/
ADD "https://raw.githubusercontent.com/home-assistant/home-assistant/${VERSION}/requirements_all.txt" /tmp

RUN apk add --no-cache --virtual=build-dependencies build-base linux-headers && \
    wget -O - https://github.com/jemalloc/jemalloc/releases/download/${JEMALLOC_VER}/jemalloc-${JEMALLOC_VER}.tar.bz2 | tar -xjf - -C /usr/src && \
    cd /usr/src/jemalloc-${JEMALLOC_VER} && \
    ./configure && \
    make && \
    make install && \
    apk del build-dependencies && \
    rm -rf /tmp/* /var/tmp/* /usr/src/*

ENV LD_PRELOAD=/usr/local/lib/libjemalloc.so.2

