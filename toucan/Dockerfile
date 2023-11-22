# Stage 1: Install Operating system and dependencies
FROM debian:latest AS build-env

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update 
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3 sed
RUN apt-get clean

ENV DEBIAN_FRONTEND=dialog
ENV PUB_HOSTED_URL=https://pub.flutter-io.cn
ENV FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# download Flutter SDK from Flutter Github repo
# RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
COPY --from=build-env /usr/local/flutter /usr/local/flutter

# Set flutter environment path
ENV PATH="${PATH}:/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin"

# Run flutter doctor
RUN flutter doctor -v

# Enable flutter web
RUN flutter version v3.13.9
RUN flutter upgrade
# Copy a pre-downloaded Flutter SDK into the image
RUN flutter config --enable-web

# Stage 2: Build the Flutter web application
FROM build-env as builder

RUN mkdir /app/
COPY . /app/
WORKDIR /app/
RUN flutter build web

# Stage 3: Create the final image
FROM nginx:1.21.1-alpine

COPY --from=builder /app/build/web /usr/share/nginx/html

# make server startup script executable and start the web server
RUN ["chmod", "+x", "/app/server/server.sh"]
ENTRYPOINT [ "/app/server/server.sh"]
