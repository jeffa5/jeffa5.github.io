#!/usr/bin/env bash

set -eu

file=${1:?"need a file as the argument"}

BASE_URL_RELATIVE="$(echo "$1" | sed -e 's#public/##' | xargs dirname | sed -e 's#[^/]\+/#..#g')"
sed -i -e "s#BASE_URL_RELATIVE#$BASE_URL_RELATIVE#" "$1"
