FROM ruby:3.1.0

WORKDIR /app

RUN apt update -y && \
    apt install -y \
    software-properties-common \
    chromium \
    chromium-l10n \
    xvfb \
    pulseaudio \
    ffmpeg


COPY ../ /app
RUN chmod +x docker/entrypoint.sh

RUN useradd -ms /bin/bash streamer
ENTRYPOINT ["./docker/entrypoint.sh"]
USER root

