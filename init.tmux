#!/usr/bin/env sh
# vi: filetype=sh

CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS="${CURRENT_DIR}/scripts"
SEDKEYBIND="${SCRIPTS}/sed-keybind.sh"
KEYPALETTE="${SCRIPTS}/show-prompt.sh"
CMDPALETTE="${SCRIPTS}/show-cmdlist.sh"

main() {
    source_file "${SCRIPTS}/env.sh" -c

    local TABLES="$(tmux show-options -gqv @cmdpalette-tables | sed 's/,/ /g')"
    if [ -z "${TABLES}" ]; then
        TABLES="$(all_tables)"
    fi
    for table in $TABLES; do
        bind_keytable "${table}"
    done

    local CMDLISTS="$(tmux show-options -gqv @cmdpalette-cmdlists | sed 's/,/ /g')"
    if [ -z "${CMDLISTS}" ]; then
        CMDLISTS="commands"
    fi
    for list in $CMDLISTS; do
        bind_cmdlist "${list}"
    done
}

source_file() {
    . "$@"
}

all_tables() {
    tmux list-keys |
        sh "${SEDKEYBIND}" |
        sed -E 's/^(\S+)\s+(\S+)\s+(.*)$/\1/' |
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
    local table="$1"
    local bind="${table}"
    local key="?"

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
    local list="$1"
    local bind="prefix"
    local key="M-m"

    parse_binding $(tmux show-options -gqv "@cmdpalette-cmd-${list}")

    tmux bind-key \
        -N "Command Palette: ${list}" \
        -T "${bind}" \
        "${key}" run-shell "/usr/bin/env sh \"${CMDPALETTE}\" \"${list}\""
}

main "$@"
