
# Overview

This project implements a container for sending emails. The emails are taken from text files located in a specified directory, which is mounted as a volume using Docker Compose. The recipients are defined in the environment variable `RECIPIENTS`, which accepts email addresses separated by either colons or spaces.

The Docker image to be built needs the following variables:
```
CRON_SCHEDULE='*/15 * * * *'   # Frequency of checking the emails directory.
OPENSSL_PWD=changeme           # Password used to derive an encryption key for securing the email password.
EMAIL_PWD=emailPwd             # The email password.
```
The image instance (container) needs the following environment variables to work properly:
```
HOST=required.email.host                         # Email server host.
PORT=587                                         # Port for the email server.
USER=requiredUser                                # Username for email access (typically an email address).
DISPLAY_NAME='Foo Bar'                           # Display name for the sender. This is optional.
FROM=mail@from.send                              # Email address used for sending messages. This is optional; if not set, EMAIL_USER will be used as the sender's address.
RECIPIENTS=mail1@example.com:mail2@example.com   # Recipient email addresses, as described above.
```
Almost all of these variables can be passed to Docker Compose by adding the `EMAIL_` prefix, except for the `EMAIL_PWD` variable, which is set by the [`build-images.sh`](../readme.md#build-imagessh) shell script for security reasons.


# Tests

It's possible to test the code that send the emails by running the following command:
```
docker compose run --rm email-notifier sh -c "tests"
```
This test consists of two steps. The first step checks if the crontab is valid and then tries to send an email.
The second step tests the email composition to ensure that all parameters are handled correctly.

What this test cannot do is verify if Supercronic works correctly. To do this, it is necessary to run a container in the shell with the following command:
```
docker compose run --rm email-notifier sh
```
Create a test email by running the `create-test-email '/emails/Test Email'` command, and then run Supercronic with the command:
```
supercronic -debug /etc/crontab 2> >(logger)
```
It's possible to have a more verbose and not formatted log using the following command:
```
supercronic -debug /etc/crontab
```
The `-debug` option add information to log and obviously are optional at your discretion.
Finally, wait for Supercronic to send the email, then use `CTRL` + `C` to stop it.