FROM alpine:3.20

COPY ./src /src

ARG SUPERCRONIC_VERSION=v0.2.33 \
    SUPERCRONIC_ARCH=amd64 \
    SUPERCRONIC_CHECKSUM='sha256:feefa310da569c81b99e1027b86b27b51e6ee9ab647747b49099645120cfc671' \
    EMAIL_PWD \
    CRON_SCHEDULE \
    OPENSSL_PWD \
    TEST_PATH

ADD --checksum=${SUPERCRONIC_CHECKSUM} \
    --chmod=0755 \
    "https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-${SUPERCRONIC_ARCH}" \
    /usr/bin/supercronic

ENV OPENSSL_PWD=$OPENSSL_PWD \
    PATH="/src:${TEST_PATH%:}${TEST_PATH:+:}$PATH"

RUN apk update && \
    apk upgrade && \
    apk add msmtp openssl && \
    rm -rf /var/cache/apk/* && \
    if [ -z "$EMAIL_PWD" ]; then \
        echo -e '\033[0;31mError: EMAIL_PWD not provided. Are you using the `build-images.sh` command?\033[0m' && exit 1 ; \
    else \
        openssl enc -aes-256-cbc -salt -k "$OPENSSL_PWD" -pbkdf2 -iter 100000 -in <(echo "$EMAIL_PWD") -out /etc/credential ; \
    fi && \
    echo "$CRON_SCHEDULE send-emails" > /etc/crontab && \
    adduser --disabled-password --no-create-home user

USER user

CMD ['supercronic /etc/crontab 2> >(logger >>/logs/email-notifier)']
