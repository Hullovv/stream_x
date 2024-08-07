#!/bin/bash

set -eaou pipefail
bundle install
echo "start streamer"
echo "start pulse"
runuser -l streamer -c 'pulseaudio --start -D'
echo "exit"
$@