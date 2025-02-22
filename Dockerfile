ARG NEXTCLOUD_VERSION

FROM nextcloud:${NEXTCLOUD_VERSION}

RUN apt-get update
RUN apt-get install -y \
  wget gnupg2 unzip

# =====================
# Memories extension
# =====================
RUN apt-get install -y \
  ffmpeg imagemagick

# ==========================
# Face recognition extension
# ==========================
RUN echo "deb https://repo.delellis.com.ar bullseye bullseye" > /etc/apt/sources.list.d/20-pdlib.list && \
  wget -qO - https://repo.delellis.com.ar/repo.gpg.key | apt-key add -

RUN apt-get update
RUN apt-get install -y \
      libbz2-dev libx11-dev libopenblas-dev liblapack-dev cmake git

RUN git clone https://github.com/davisking/dlib.git && \
  mkdir dlib/dlib/build && \
  cd dlib/dlib/build && \
  cmake -DBUILD_SHARED_LIBS=ON .. && \
  make && \
  make install && \
  cd && rm -rf dlib

RUN wget https://github.com/goodspb/pdlib/archive/master.zip \
  && mkdir -p /usr/src/php/ext/ \
  && unzip -d /usr/src/php/ext/ master.zip \
  && rm master.zip

RUN docker-php-ext-install pdlib-master bz2

# Set PHP memory limit
RUN echo "memory_limit=1024M" > /usr/local/etc/php/conf.d/memory-limit.ini

RUN ls -al /usr/src/php/ext

# ============
# === RRON ===
# ============
RUN curl -fsSL https://github.com/DataHearth/rron/releases/download/v0.2.1/rron-amd64-gnu \
    --output /usr/local/bin/rron
RUN chmod +x /usr/local/bin/rron
