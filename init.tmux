#!/usr/bin/env sh
# vi: filetype=sh

CACHE="${TMUX_TMPDIR:-/tmp}"
CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS="${CURRENT_DIR}/scripts"
SHOW="${SCRIPTS}/show-prompt.sh"

main() {
    TABLES="$(tmux show-options -gqv @cmdpalette-tables | sed 's/,/ /g')"
    if [ -z "${TABLES}" ]; then
        TABLES="$(all_tables)"
    fi

    for table in $TABLES; do
        bind_keytable "${table}"
    done
}

all_tables() {
    tmux list-keys |
        sed -E \
            -e 's/^bind-key\s+//' \
            -e 's/^(-r\s+)?//' \
            -e 's/^-T\s+(\S+).*$/\1/' |
        sort -u
}

bind_keytable() {
    table="$1"
    bind="${table}"
    key="?"

    if [ "${table}" = "root" ]; then
        bind="prefix"
        key="BSpace"
    fi

    set -- $(tmux show-options -gqv "@cmdpalette-key-${table}")
    if [ $# -eq 1 ]; then
        # "BSpace"
        key="$1"
    elif [ $# -ge 2 ]; then
        # "prefix BSpace"
        bind="$1"
        key="$2"
    fi

    tmux bind-key \
        -N "Command Palette: ${table}" \
        -T "${bind}" \
        "${key}" run-shell "/usr/bin/env sh \"${SHOW}\" \"${table}\""
}

main "$@"
