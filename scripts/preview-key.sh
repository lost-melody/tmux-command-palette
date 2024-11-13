#!/usr/bin/env sh

cd "$(dirname "$0")"

SEDKEYBIND="sed-keybind.sh"

main() {
    local table="$1"

    local key="$(head -n 1 | sed -E 's/^(\S+)\s+.*$/\1/')"
    # escaped semicolon
    local k="${key}"
    if [ "${k}" = ";" ]; then
        k="\\${k}"
    fi

    local note="$(
        tmux list-keys -NT "${table}" "${k}" 2>/dev/null |
            sed -E 's/^\S+\s+//'
    )"
    local bind="$(
        tmux list-keys -T "${table}" "${k}" 2>/dev/null |
            sh "${SEDKEYBIND}" |
            sed -E 's/^(\S+)\s+(\S+)\s+(.*)$/\3/'
    )"

    echo "[${table} \"${key}\"]"
    if [ -n "${note}" ]; then
        echo
        echo '[Note]'
        echo "${note}"
    fi
    echo
    echo '[Bind]'
    echo "${bind}"
}

main "$@"
