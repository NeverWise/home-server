
# overview

This project checks the storage health by monitoring SMART attributes and utilizing btrfs utilities to verify the integrity of the btrfs file system.
If errors are detected, the project generates a text-based report file.
The `src` directory contains the shell script files, while the `test` directory contains the shell script files used for testing.
The main shell script file is `storage-health-check`, which requires three parameters to function correctly:

 1. the first parameter is a list of disk devices separated by colons (e.g., `/dev/nvme0:/dev/sda:/dev/sdb`);
 2. the second parameter is a list of btrfs partitions separated by colons (e.g., `/mnt/data:/mnt/backup`);
 3. the third parameter is the path and filename of the report file.

This script is designed to be used in conjunction with crontab, but can also be run manually outside of crontab.
In a crontab environment, it is necessary to add the path of the `src` directory to the `PATH` environment variable.
The `smart-check` and `btrfs-check` files utilize the `smartctl` and `btrfs` commands, respectively, to perform the checks, and therefore require root privileges to function correctly.
The `docker-compose.yml` file, located in the parent directory of this project, contains a service for running unit tests.


# Tests

To run unit tests, execute the following command from the parent directory of this project:
```
docker compose run --rm storage-health-check sh -c "tests"
```
