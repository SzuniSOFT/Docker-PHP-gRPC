ARG PHP_VERSION=7.2.15
ARG PHP_DIST=cli
FROM grpc/php AS grpc
MAINTAINER Forgács Bence <bence.forgacs@szunisoft.hu>
FROM php:${PHP_VERSION}-${PHP_DIST}-stretch AS build

# Please note that this is an unofficial release of PHP gRPC server plugin
ARG PROTOC_SERVER_PLUGIN_VERSION="v1.0.1"
# The official client stub generator plugin of gRPC
ARG PROTOC_CLIENT_PLUGIN_VERSION="v1.0.1"
# Mandatory libs to install stuff
ARG BUILD_DEPENDENCIES="${PHPIZE_DEPS} zlib1g-dev libtool git automake wget"

# Copy protoc executable
COPY --from=grpc /usr/local/bin/protoc /usr/local/bin/protoc

RUN apt-get update \
    # Install php build deps
    && apt-get -y install ${BUILD_DEPENDENCIES} \
    # Install gRPC and protobuf
    && pecl install grpc && docker-php-ext-enable grpc \
    && pecl install protobuf && docker-php-ext-enable protobuf \
    # ==========================================================================================================
    # Install client stub generator protoc plugin
    # ==========================================================================================================
    && cd / \
    && git clone -b $(curl -L https://grpc.io/release) https://github.com/grpc/grpc \
    && cd grpc && git submodule update --init \
    && make grpc_php_plugin \
    && cp bins/opt/grpc_php_plugin /usr/local/bin/grpc_php_client_plugin \
    # ==========================================================================================================
    # Install server stub generator protoc plugin
    # ==========================================================================================================
    && wget -qO- https://github.com/spiral/php-grpc/releases/download/v1.0.1/protoc-gen-php-grpc-1.0.1-linux-amd64.tar.gz | tar -xvz \
    && cp protoc-gen-php-grpc-1.0.1-linux-amd64/protoc-gen-php-grpc /usr/local/bin/grpc_php_server_plugin \
    # ==========================================================================================================
    # Install road runner runtime
    # more details:
    # ==========================================================================================================
    && wget -qO- https://github.com/spiral/php-grpc/releases/download/v1.0.1/rr-grpc-1.0.1-linux-amd64.tar.gz | tar -xvz \
    && cp rr-grpc-1.0.1-linux-amd64/rr-grpc /usr/local/bin/rr-grpc \
    # Finally clean up space
    && apt-get remove -y ${BUILD_DEPENDENCIES}
