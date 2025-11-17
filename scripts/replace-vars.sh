#!/usr/bin/env bash

set -eu

file=${1:?"need a file as the argument"}

BASE_URL_RELATIVE="$(echo "$1" | sed -e 's#public/##' | sed -e 's#[^/]\+/#../#g' | xargs dirname)"
sed -i -e "s#BASE_URL_RELATIVE#$BASE_URL_RELATIVE#" "$1"
