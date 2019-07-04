FROM mariort/php-nginx:2.0

ENV LIBRDKAFKA_VERSION v0.9.5

ENV RDKAFKA_DEPS \
    build-essential \
    libsasl2-dev \
    python-minimal \
    zlib1g-dev

# install system dependencies
RUN apt-get update \
&& apt-get install -y --no-install-recommends ${RDKAFKA_DEPS} \
&& rm -rf /var/lib/apt/lists/*

# build lib rdkafka
RUN cd /tmp \
&& git clone \
    --branch ${LIBRDKAFKA_VERSION} \
    --depth 1 \
    https://github.com/edenhill/librdkafka.git \
&& cd librdkafka \
&& ./configure \
&& make \
&& make install

# install php extensions
RUN pecl install rdkafka-3.1.0 \
&& docker-php-ext-enable rdkafka \
&& rm -rf /tmp/librdkafka