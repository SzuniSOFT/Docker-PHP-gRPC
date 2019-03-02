# Docker PHP gRPC
This image has both **client** and **server** stub generator plugin. As it is known the server stub generation is not supported officially yet however based on the project [Road Runner gRPC PHP](https://github.com/spiral/php-grpc) we are able to do so.

## Build it
After you have pulled the repository you can specify the PHP version directly during the build time.
```text
docker build --build-arg PHP_VERSION=7.2.15 --build-arg PHP_DIST=cli -t php-grpc:7.2.15 .
```
The available build variables

| Name | Role | Default | Values |
| --- | --- | --- | --- |
| PHP_VERSION | Specifies the interpreter version | 7.2.15 | _any compatible php version_ 
| PHP_DIST | Specifies PHP distribution | cli | cli, fpm, zts, apache

Outcome ``php:${PHP_VERSION}-${PHP_DIST}-stretch``

## Use it

### Generate client stubs
```text
docker run php-grpc:7.2.15 -v <PROJECT_PATH>:<INSIDE_CONTAINER> protoc \
    --php_out=<CLASSES_OUT_PATH> \
    --php-grpc_out=<CLIENT_CLASSES_OUT_PATH> \
    --proto_path=<PATH_TO_LOCATE_PROTO_FILES> \
    --plugin=protoc-gen-php-grpc=/usr/local/bin/grpc_php_client_plugin \
    <NAME_OF_PROTO_FILE>
```

### Generate server stubs
```text
docker run php-grpc:7.2.15 -v <PROJECT_PATH>:<INSIDE_CONTAINER> protoc \
    --php_out=<CLASSES_OUT_PATH> \
    --php-grpc_out=<SERVER_CLASSES_OUT_PATH> \
    --proto_path=<PATH_TO_LOCATE_PROTO_FILES> \
    --plugin=protoc-gen-php-grpc=/usr/local/bin/grpc_php_server_plugin \
    <NAME_OF_PROTO_FILE>
```