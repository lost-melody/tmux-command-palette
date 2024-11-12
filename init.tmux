#!/usr/bin/env sh
# vi: filetype=sh

CACHE="${TMUX_TMPDIR:-/tmp}"
CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS="${CURRENT_DIR}/scripts"
KEYPALETTE="${SCRIPTS}/show-prompt.sh"
CMDPALETTE="${SCRIPTS}/show-cmdlist.sh"

main() {
    TABLES="$(tmux show-options -gqv @cmdpalette-tables | sed 's/,/ /g')"
    if [ -z "${TABLES}" ]; then
        TABLES="$(all_tables)"
    fi
    for table in $TABLES; do
        bind_keytable "${table}"
    done

    CMDLISTS="$(tmux show-options -gqv @cmdpalette-cmdlists | sed 's/,/ /g')"
    if [ -z "${CMDLISTS}" ]; then
        CMDLISTS="commands"
    fi
    for list in $CMDLISTS; do
        bind_cmdlist "${list}"
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

parse_binding() {
    if [ $# -eq 1 ]; then
        # "BSpace"
        key="$1"
    elif [ $# -ge 2 ]; then
        # "prefix BSpace"
        bind="$1"
        key="$2"
    fi
}

bind_keytable() {
    table="$1"
    bind="${table}"
    key="?"

    if [ "${table}" = "root" ]; then
        bind="prefix"
        key="BSpace"
    fi

    parse_binding $(tmux show-options -gqv "@cmdpalette-key-${table}")

    tmux bind-key \
        -N "Command Palette: ${table}" \
        -T "${bind}" \
        "${key}" run-shell "/usr/bin/env sh \"${KEYPALETTE}\" \"${table}\""
}

bind_cmdlist() {
    list="$1"
    bind="prefix"
    key="M-m"

    parse_binding $(tmux show-options -gqv "@cmdpalette-cmd-${list}")

    tmux bind-key \
        -N "Command Palette: ${list}" \
        -T "${bind}" \
        "${key}" run-shell "/usr/bin/env sh \"${CMDPALETTE}\" \"${list}\""
}

main "$@"
