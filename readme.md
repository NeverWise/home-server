
# Overview

This project contains several scripts and Docker services that run on a home server using Docker Compose. There are two Docker Compose files: `docker-compose.yml`, which is used to run services in a development and test environment, and `docker-compose.deploy.yml`, which is used to run services in a production environment.


# Projects

- [email-notifier](email-notifier/readme.md)
- [storage-health-check](storage-health-check/readme.md)


# `build-images.sh`

This is a shell script used to build some critical images that require security attention.
This script can be used in several different ways:
- Run `build-images.sh` to build all the images.
- Run `build-images.sh email-notifier` to build the specified image.
- Use the `-f` and `--file` options to specify a Docker Compose file and build all the images or the specified one with another environment (for example, `docker-compose.deploy.yml` for the production environment).

The options `-h` or `--help` display help for the `build-images.sh` command.
Currently, the script can build only one image that requires a password to be typed inside it. This image is `email-notifier`.
