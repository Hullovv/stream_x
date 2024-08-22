#!/bin/bash

set -eaou pipefail

docker=$(which docker)

tag_name="stream_ffmpeg"

main_tag="stream_x"

# На случай отсутствия докера
#if [[ -v $docker ]]; then
#  echo "Install Docker?(yes/no)"
#  read -r answer
#  case "$answer" in
#    "yes")
#      apt install -y docker
#    ;;
#    "no")
#      exit 0
#    ;;
#  esac
#fi
mkdir ${PWD}/build
$docker build -t $tag_name -f ${PWD}/Dockerfile.ffmpeg .
$docker run -d --name $tag_name $tag_name
$docker cp $tag_name:/stream/ffmpeg_build/bin/ffmpeg ${PWD}/build/ffmpeg
$docker rm -f $tag_name

echo "Build $main_tag...."
$docker build -t ${main_tag} .