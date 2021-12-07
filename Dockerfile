# Use an Ubuntu LTS base image
FROM ubuntu:20.04 as builder

MAINTAINER NicklasXYZ

# Set SUMO environment variables
ENV SUMO_HOME /usr/src/home
ENV SUMO_VERSION 1.11.0

# Set additional environment variables
# Disable the commandline prompt for the tzdata package
ENV DEBIAN_FRONTEND "noninteractive"
# Set the timezone for the tzdata package
ENV TZ "Europe/London"

# Set the working directory
WORKDIR ${SUMO_HOME}

# Install SUMO dependencies and build SUMO
# Afterwards remove unnecessary files
RUN apt-get update && apt-get install -qq git \
    wget \
    cmake \
    python3 \
    python3-setuptools \
    g++ \
    libxerces-c-dev \
    libfox-1.6-dev \
    libgdal-dev \
    libproj-dev \
    libgl2ps-dev && \
    wget https://sumo.dlr.de/releases/${SUMO_VERSION}/sumo-src-${SUMO_VERSION}.tar.gz && \
    tar xzf sumo-src-${SUMO_VERSION}.tar.gz && \
    rm sumo-src-$SUMO_VERSION.tar.gz && \
    cd sumo-${SUMO_VERSION} && \
    cmake . && \
    make -j$(nproc) && \
    make install && \
    make clean && \
    cd .. && \
    rm -rf sumo-$SUMO_VERSION