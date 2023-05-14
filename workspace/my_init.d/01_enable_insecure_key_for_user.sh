#!/bin/bash
set -e

USERNAME=$(id -un $PUID)
AUTHORIZED_KEYS=/home/$USERNAME/.ssh/authorized_keys

if [[ -e "$AUTHORIZED_KEYS" ]] && grep -q baseimage-docker-insecure-key "$AUTHORIZED_KEYS"; then
	echo "Insecure key has already been added to $AUTHORIZED_KEYS."
else
	DIR=`dirname "$AUTHORIZED_KEYS"`
  cp -rf /root/.ssh /home/$USERNAME/.ssh
  chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
	echo "Success: insecure key has been added to $AUTHORIZED_KEYS"
fi
