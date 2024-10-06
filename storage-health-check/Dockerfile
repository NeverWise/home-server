FROM alpine:latest

ARG TEST_PATH

ENV PATH="/src:${TEST_PATH%:}${TEST_PATH:+:}$PATH"
