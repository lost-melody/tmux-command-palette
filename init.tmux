#!/usr/bin/env sh
# vi: filetype=sh

CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS="${CURRENT_DIR}/scripts"
SHOW="${SCRIPTS}/show-prompt.sh"

main() {
    TABLES="$(tmux show-options -gqv @cmdpalette-tables | sed 's/,/ /g')"
    if [ -z "${TABLES}" ]; then
        TABLES="$(all_tables)"
    fi

    for table in $TABLES; do
        bind_prompt "${table}"
    done
}

all_tables() {
    tmux list-keys | sed 's/^bind-key \+\(-r\)\? \+-T \+\([^ ]\+\).*$/\2/' | sort -u
}

bind_prompt() {
    table="$1"
    key="$(tmux show-options -gqv "@cmdpalette-key-${table}")"
    if [ "${table}" = "root" ]; then
        bind="prefix"
        if [ -z "${key}" ]; then
            key="BSpace"
        fi
    else
        bind="${table}"
        if [ -z "${key}" ]; then
            key="?"
        fi
    fi
    tmux bind-key -T "${bind}" "${key}" run-shell "/usr/bin/env sh \"${SHOW}\" \"${table}\""
}

main "$@"
