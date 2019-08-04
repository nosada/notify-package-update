# Notify-package-update
Post message about update information about specified Arch Linux package to Slack channel (using incoming-webhook).

Using systemd user service and timer (available by adding `--user` to `systemctl`), package update will be posted
everyday at 12:00 if it exists.

## Usage:
See `python notify-package-update --help`:
```
$ python notify-package-update --help
Search given package(s) in recent updated packages on Arch Linux.

Usage:
    notify-package-update [-h | --help]
    notify-package-update [-c CONFIG] [-d | --dry-run]
    notify-package-update [-u SLACK_WEBHOOK_URL] [-d | --dry-run]
                          [PACKAGE ...]

Options:
    -h  --help          Show help (this message)
    -d  --dry-run       Write search result only to stdout,
                        not posting to Slack
    -c                  Specify config file (written in yaml)
    -u                  Specify Slack incoming-webhook URL
    PACKAGE             Package name(s) you want to search in
                        recent updates
```

## Install
Write `config.yaml` based on `config.yaml.tmpl` and create directory `$HOME/Venvs`,  then invoke below:
```
$ make
$ systemctl --user start notify-package-update.timer
```

## Uninstall
```
$ make uninstall
$ make clean
```
