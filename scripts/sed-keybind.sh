#!/usr/bin/env sh

sed -E \
    -e 's/^bind-key//' \
    -e 's/^(\s+-r)?//' \
    -e 's/^\s+-T//' \
    -e 's/^\s+(\S+\s+)\\?(\S+)/\1\2/'
