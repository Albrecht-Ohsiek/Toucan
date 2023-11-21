
# Install Operating system and dependencies
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update 
RUN apt-get install -y curl 
RUN apt-get install -y git
RUN apt-get install -y wget
RUN apt-get install -y unzip
RUN apt-get install -y libgconf-2-4
RUN apt-get install -y gdb
RUN apt-get install -y libglu1-mesa
RUN apt-get install -y fonts-droid-fallback
RUN apt-get install -y python3
RUN apt-get clean

RUN apt update
RUN apt install -y openjdk-11-jdk
RUN apt install -y git-core
RUN apt install -y gnupg
RUN apt install -y flex
RUN apt install -y bison
RUN apt install -y gperf
RUN apt install -y build-essential
RUN apt install -y zip
RUN apt install -y curl
RUN apt install -y zlib1g-dev
RUN apt install -y x11proto-core-dev
RUN apt install -y libx11-dev
RUN apt install -y ccache
RUN apt install -y libgl1-mesa-dev
RUN apt install -y libxml2-utils
RUN apt install -y xsltproc
RUN apt install -y unzip
RUN apt install -y bc
RUN apt install -y liblz4-tool
RUN apt install -y vboot-utils
RUN apt install -y vim
RUN apt install -y u-boot-tools
RUN apt install -y device-tree-compiler
RUN apt install -y wget
RUN apt install -y zsh
RUN apt install -y tmux
RUN git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 -b o-preview /toolchain/o/
RUN apt-get install -y clang
RUN apt-get install -y cmake
RUN apt-get install -y ninja-build
RUN apt-get install -y pkg-config
RUN apt-get install -y libgtk-3-dev

# download Flutter SDK from Flutter Github repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter


# Create a non-root user
RUN groupadd -r myuser && useradd -r -g myuser myuser

# Switch to the non-root user
USER myuser

# Set the working directory and ownership
WORKDIR /usr/web
COPY --chown=myuser:myuser . .

# Change ownership and permissions of /usr
USER root
RUN chown myuser:myuser /usr && chmod 755 /usr

# Switch back to the non-root user
USER myuser

# Set flutter environment path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run flutter doctor
RUN flutter doctor

# Enable flutter web
RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

# Copy files to container and build
RUN mkdir /app/
COPY . /app/
WORKDIR /app/
RUN flutter build web
