SHELL := /bin/bash

HOME_DIRECTORY=$(shell echo ${HOME})
SCRIPT_LOCATION=$(shell pwd)
VENV_LOCATION=${HOME_DIRECTORY}/Venvs
USER_SYSTEMD_LOCATION=${HOME_DIRECTORY}/.config/systemd/user

FILES=notify-package-update \
      notify-package-update.service \
      notify-package-update.timer \
      requirements.txt \
      config.yaml
TEMPLATE=notify-package-update.service.tmpl
NAME=notify-package-update


all: generate-systemd-service install set-up-python activate-systemd-services

install: ${FILES}
	install -Dm 644 ${NAME}.service ${USER_SYSTEMD_LOCATION}
	install -Dm 644 ${NAME}.timer ${USER_SYSTEMD_LOCATION}

set-up-python:
	python -m venv ${VENV_LOCATION}/${NAME}
	source ${VENV_LOCATION}/${NAME}/bin/activate
	${VENV_LOCATION}/${NAME}/bin/pip install --upgrade pip
	${VENV_LOCATION}/${NAME}/bin/pip install -r requirements.txt

generate-systemd-service: ${TEMPLATE}
	sed -e 's|VENV_LOCATION|'${VENV_LOCATION}'|g' -e 's|SCRIPT_LOCATION|'${SCRIPT_LOCATION}'|g' ${TEMPLATE} > ${NAME}.service

activate-systemd-services:
	systemctl --user daemon-reload
	systemctl --user enable ${NAME}.service
	systemctl --user enable ${NAME}.timer

deactivate-systemd-services:
	systemctl --user disable ${NAME}.service
	systemctl --user disable ${NAME}.timer
	systemctl --user daemon-reload

clean: ${NAME}.service
	rm -f ${NAME}.service

uninstall: deactivate-systemd-services
	rm -f ${USER_SYSTEMD_LOCATION}/${NAME}.service
	rm -f ${USER_SYSTEMD_LOCATION}/${NAME}.timer
	rm -rf ${VENV_LOCATION}/${NAME}
