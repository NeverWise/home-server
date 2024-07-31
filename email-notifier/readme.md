
# Overview

This project sends emails. The emails are taken from text files located in a specified directory, which is mounted as a volume with Docker Compose. The recipients are defined in the environment variable `EMAIL_RECIPIENTS`, which accepts email addresses separated by either colons or spaces.

The following environment variables are used by this project:
```
EMAIL_CRON_SCHEDULE='*/15 * * * *'                     # Frequency of checking the emails directory.
EMAIL_ENCRYPTION_KEY=changeme                          # Encryption key for securing the email password.
EMAIL_HOST=required.email.host                         # Email server host.
EMAIL_PORT=587                                         # Port for the email server.
EMAIL_FROM=mail@from.send                              # Email address used for sending messages.
EMAIL_FROM_NAME='Foo Bar'                              # Display name for the sender (optional).
EMAIL_USER=requiredUser                                # Username for email access (typically the same as EMAIL_FROM).
EMAIL_RECIPIENTS=mail1@example.com:mail2@example.com   # Recipient email addresses, as described above.
```


# Tests

Full-cycle testing with cron job and email sending:
```
docker compose run --rm email-notifier sh -c "full-test"
```

Environment variable permutation testing (currently only for recipients):
```
docker compose run --rm email-notifier sh -c "parameters-test"
```
