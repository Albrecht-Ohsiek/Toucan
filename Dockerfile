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

# Set HOME environment variable
ENV HOME /opt/web

# Create Flutter directory
RUN mkdir -p /opt/flutter && chown -R myuser:myuser /opt/flutter

# Clone the flutter repo
RUN git clone https://github.com/flutter/flutter.git /opt/flutter

# Set flutter path
ENV PATH="${PATH}:/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin"

# Enable web capabilities
RUN flutter config --enable-web && \
    flutter upgrade && \
    flutter pub global activate webdev && \
    flutter doctor

# Switch back to root to perform cleanup
USER root

# Cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*