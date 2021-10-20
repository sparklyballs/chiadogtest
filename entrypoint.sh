#!/usr/bin/env bash

# set timezone
# shellcheck disable=SC2154
if [[ -n "${TZ}" ]]; then
  echo "Setting timezone to ${TZ}"
  ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" > /etc/timezone
fi

# copy config if not exists in /data
[[ ! -d "/data" ]] && mkdir -p /data

[[ ! -e "/data/config.yaml" ]] && cp /chiadog/config-example.yaml /data/config.yaml

# start application
# shellcheck disable=SC1091
. ./venv/bin/activate
python3 main.py --config /data/config.yaml
