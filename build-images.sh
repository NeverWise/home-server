#!/bin/sh
#
# build-images.sh - For security reasons, some containers need to be built in a specific way before being used, even in a development environment.
#
# This script performs the following operations:
# - build a specific service for an optional environment (default in develop: docker-compose.yml);
# - build all the services for an optional environment (default in develop: docker-compose.yml).
#

usage() {
    # Create a string with services separated by pipes and spaces.
    service_list=''
    for service in $SERVICES; do
        service_list="$service_list $service |"
    done
    service_list=${service_list%|}       # Remove the last pipe
    service_list="$(echo $service_list)" # Trim whitespace

    echo 'Usage syntax:'
    echo "    $0 [-f|--file <file>] [-h|--help] [$service_list]"
    echo
    echo 'Options:'
    echo '    -f, --file    Compose configuration files'
    echo '    -h, --help    Show this help message'
    # echo
    # echo 'Parameters:'
    # echo '    service1  Enable option 1. This option does...'
    # echo '    service2  Enable option 1. This option does...'
    # echo '    service3  Display the help message for this script.'
    echo
    echo 'Usage examples:'
    echo "    $0 -f docker-compose.deploy.yml email-notifier"
    echo "    $0 email-notifier"
    echo "    $0"
}

build_service() {
    echo "Building $1..."
    case "$1" in
    email-notifier)
        stty -echo # Disable echo for password input
        echo "Please enter email password to build $1 docker image:"
        read -r EMAIL_PWD
        stty echo # Re-enable echo after read password
        docker compose -f "$COMPOSE_FILE" build "$1" --build-arg EMAIL_PWD=$EMAIL_PWD
        echo
        ;;
    esac
}

echo '\nbuild-images.sh version 1.0.0 for home server\n'

# Define valid options for the script
VALID_OPTS='f:h'
VALID_LONG_OPTS='file:,help'

# Define the default values and the allowed values
SERVICES='email-notifier'
COMPOSE_FILE="docker-compose.yml"
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Use `getopt` to parse the parameters
printf "$RED" >&2
OPTS=$(getopt --options "$VALID_OPTS" --longoptions "$VALID_LONG_OPTS" --name "$0" -- "$@")
if [ $? != 0 ]; then
    printf "$NC\n" >&2
    usage >&2
    exit 1
else
    printf "$NC" >&2
fi

# Extract the parsed parameters from `getopt`
eval set -- "$OPTS"

# Option management
while true; do
    case "$1" in
    -f | --file)
        COMPOSE_FILE="$2"
        shift 2
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    --)
        shift
        break
        ;;
    *)
        echo "${YELLOW}Unhandled option: $1$NC" >&2
        exit 1
        ;;
    esac
done

# The remaining positional parameters are services, and it checks if they are valid
for arg in "$@"; do
    found=0
    for service in $SERVICES; do
        if [ "$service" = "$arg" ]; then
            found=1
            break
        fi
    done

    if [ "$found" -eq 0 ]; then
        echo "${RED}Error: $arg is not a valid service.$NC\n" >&2
        usage >&2
        exit 1
    fi
done

# If there are no errors, the services are compiled
if [ $# -gt 0 ]; then
    for service in "$@"; do
        build_service "$service"
    done
else
    for service in $SERVICES; do
        build_service "$service"
    done
fi
