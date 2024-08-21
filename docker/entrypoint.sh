#!/bin/bash

set -eaou pipefail
bundle install
echo "start pulse"
runuser -l streamer -c 'pulseaudio --start -D'
echo "Exit from entrypoint"
exec "$@"