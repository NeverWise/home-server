FROM alpine:3.20

COPY ./src /src

RUN apk update && \
    apk upgrade && \
    apk add msmtp \
            openssl \
            envsubst && \
    rm -rf /var/cache/apk/*

CMD ['run-email-notifier']
