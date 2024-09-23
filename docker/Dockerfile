FROM ubuntu:22.04
ARG FFMPEG_BUILD_PATH='/stream/ffmpeg_build'
ARG FFMPEG_BIN_PATH="${FFMPEG_BUILD_PATH}/bin"
ARG FFMPEG_LIB_PATH="${FFMPEG_BUILD_PATH}/lib/pkgconfig"
ARG DEBIAN_FRONTEND=noninteractive
RUN mkdir -p ${FFMPEG_BUILD_PATH} && mkdir -p ${FFMPEG_BIN_PATH} && mkdir -p ${FFMPEG_LIB_PATH}
RUN apt update -y && apt-get -y install \
  autoconf \
  google-perftools \
  libgoogle-perftools-dev \
  automake \
  build-essential \
  cmake \
  git-core \
  libass-dev \
  libfreetype6-dev \
  libgnutls28-dev \
  libmp3lame-dev \
  libsdl2-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  meson \
  ninja-build \
  pkg-config \
  texinfo \
  wget \
  yasm \
  zlib1g-dev

RUN cd ${FFMPEG_BIN_PATH} && \
  wget https://www.nasm.us/pub/nasm/releasebuilds/2.16.01/nasm-2.16.01.tar.bz2 && \
  tar xjvf nasm-2.16.01.tar.bz2 && \
  cd nasm-2.16.01 && \
  ./autogen.sh && \
  PATH="${FFMPEG_BIN_PATH}:$PATH" ./configure --prefix="${FFMPEG_BUILD_PATH}" --bindir="${FFMPEG_BIN_PATH}" --enable-static && \
  make && \
  make install && \
  cd ../ && \
  rm -rf nasm-2.16.01

RUN git -C x264 pull 2> /dev/null || git clone --depth 1 https://code.videolan.org/videolan/x264.git && \
  cd x264 && \
  PATH="${FFMPEG_BIN_PATH}:$PATH" && \
  PKG_CONFIG_PATH="${FFMPEG_LIB_PATH}" && \
  ./configure --prefix="${FFMPEG_BUILD_PATH}" --bindir="${FFMPEG_BIN_PATH}" --enable-static --enable-pic && \
  PATH="${FFMPEG_BIN_PATH}:$PATH" make && \
  make install && \
  cd ../ && \
  rm -rf x264

RUN git -C fdk-aac pull 2> /dev/null || git clone --depth 1 https://github.com/mstorsjo/fdk-aac && \
  cd fdk-aac && \
  autoreconf -fiv && \
  ./configure --prefix="${FFMPEG_BUILD_PATH}" --disable-shared --enable-static && \
  make && \
  make install && \
  cd ../ && \
  rm -rf fdk-aac

RUN wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
  tar xjvf ffmpeg-snapshot.tar.bz2 && \
  cd ffmpeg && \
  PATH="${FFMPEG_BUILD_PATH}:$PATH" PKG_CONFIG_PATH="${FFMPEG_LIB_PATH}" ./configure \
  --prefix="${FFMPEG_BUILD_PATH}" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I${FFMPEG_BUILD_PATH}/include" \
  --extra-ldflags="-L${FFMPEG_BUILD_PATH}/lib" \
  --extra-libs="-lpthread -lm -ltcmalloc" \
  --custom-allocator="tcmalloc" \
  --ld="g++" \
  --bindir="${FFMPEG_BIN_PATH}" \
  --enable-gpl \
  --enable-libfdk-aac \
  --enable-libx264 \
  --enable-nonfree && \
  PATH="${FFMPEG_BIN_PATH}:$PATH" make && \
  make install && \
  hash -r

#    --enable-libfreetype \
#      --enable-libmp3lame \
#      --enable-libopus \
#      --enable-libsvtav1 \
#      --enable-libdav1d \
#      --enable-libvorbis \
#      --enable-libvpx \
#      --enable-libx265 \
#      --enable-libaom \
#      --enable-libass \
#  --enable-gnutls \

FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /app

RUN apt update -y && \
  apt install -y \
  software-properties-common \
  chromium-browser \
  # chromium-l10n \
  xvfb \
  pulseaudio \
  google-perftools \
  libgoogle-perftools-dev \
  libsdl2-dev \
  git-core \
  libass-dev \
  libfreetype6-dev \
  libgnutls28-dev \
  libmp3lame-dev \
  libsdl2-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  meson \
  ninja-build \
  pkg-config \
  texinfo \
  wget \
  yasm \
  zlib1g-dev \
  gnupg build-essential libmariadb-dev vim less locales dialog apt-utils curl g++ gcc autoconf automake bison libc6-dev libffi-dev libgdbm-dev libncurses5-dev libsqlite3-dev libtool libyaml-dev make pkg-config sqlite3 zlib1g-dev libgmp-dev libreadline-dev libssl-dev tzdata wget net-tools \
  gpg

COPY ./ /app
COPY --from=0 /stream/ffmpeg_build/bin/ffmpeg /usr/bin/ffmpeg

RUN useradd -ms /bin/bash streamer
# ENTRYPOINT ["/app/docker/entrypoint.sh"]
USER root

RUN RUBY_VERSION="3.1.0" && gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \
  curl -sSL https://get.rvm.io | bash && \
  # echo 'export PATH="$PATH:$HOME/.rvm/bin"' >> ~/.bahrc
  # echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"' >> ~/.profile
  /usr/local/rvm/bin/rvm pkg install openssl && \
  /usr/local/rvm/bin/rvm install $RUBY_VERSION && \
  ln -s /usr/local/rvm/gems/ruby-$RUBY_VERSION/wrappers/bundle   /usr/local/bin/bundle \
  && ln -s /usr/local/rvm/gems/ruby-$RUBY_VERSION/wrappers/bundler   /usr/local/bin/bundler \
  && ln -s /usr/local/rvm/gems/ruby-$RUBY_VERSION/wrappers/erb   /usr/local/bin/erb \
  && ln -s /usr/local/rvm/gems/ruby-$RUBY_VERSION/wrappers/executable-hooks-uninstaller   /usr/local/bin/executable-hooks-uninstaller \
  && ln -s /usr/local/rvm/gems/ruby-$RUBY_VERSION/wrappers/gem   /usr/local/bin/gem \
  && ln -s /usr/local/rvm/gems/ruby-$RUBY_VERSION/wrappers/irb   /usr/local/bin/irb \
  && ln -s /usr/local/rvm/gems/ruby-$RUBY_VERSION/wrappers/racc   /usr/local/bin/racc \
  && ln -s /usr/local/rvm/gems/ruby-$RUBY_VERSION/wrappers/rake   /usr/local/bin/rake \
  && ln -s /usr/local/rvm/gems/ruby-$RUBY_VERSION/wrappers/rbs   /usr/local/bin/rbs \
  && ln -s /usr/local/rvm/gems/ruby-$RUBY_VERSION/wrappers/rdbg   /usr/local/bin/rdbg \
  && ln -s /usr/local/rvm/gems/ruby-$RUBY_VERSION/wrappers/rdoc   /usr/local/bin/rdoc \
  && ln -s /usr/local/rvm/gems/ruby-$RUBY_VERSION/wrappers/ri   /usr/local/bin/ri \
  && ln -s /usr/local/rvm/gems/ruby-$RUBY_VERSION/wrappers/ruby   /usr/local/bin/ruby \
  && ln -s /usr/local/rvm/gems/ruby-$RUBY_VERSION/wrappers/ruby_executable_hooks   /usr/local/bin/ruby_executable_hooks \
  && ln -s /usr/local/rvm/gems/ruby-$RUBY_VERSION/wrappers/typeprof   /usr/local/bin/typeprof