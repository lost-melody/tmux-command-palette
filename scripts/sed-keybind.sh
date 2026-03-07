#!/usr/bin/env sh

sed -E \
    -e 's/^bind-key//' \
    -e 's/^([[:space:]]+-r)?//' \
    -e 's/^[[:space:]]+-T//' \
    -e 's/^[[:space:]]+([^[:space:]]+[[:space:]]+)\\?([^[:space:]]+)/\1\2/'
