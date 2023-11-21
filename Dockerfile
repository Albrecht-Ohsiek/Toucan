FROM ubuntu:20.04

# Prerequisites
RUN apt-get update && \
    apt-get install -y unzip xz-utils git openssh-client curl && \
    apt-get upgrade -y && \
    rm -rf /var/cache/apt

# Create a non-root user
RUN groupadd -r myuser && useradd -r -g myuser myuser

# Switch to the non-root user
USER myuser

# Set the working directory and ownership
WORKDIR /opt/web
COPY --chown=myuser:myuser . .

# Change ownership and permissions of /opt
USER root
RUN chown myuser:myuser /opt && chmod 755 /opt

# Switch back to the non-root user
USER myuser

# Create Flutter directory
RUN mkdir -p /opt/flutter && chown -R myuser:myuser /opt/flutter

# Install flutter beta
RUN curl -L https://storage.googleapis.com/flutter_infra/releases/beta/linux/flutter_linux_1.22.0-12.1.pre-beta.tar.xz | tar -C /opt/flutter -xJ

# Add Flutter to the PATH
ENV PATH="/opt/flutter/bin:${PATH}"

# Enable web capabilities
RUN flutter config --enable-web && \
    flutter upgrade && \
    flutter pub global activate webdev && \
    flutter doctor

# Cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
