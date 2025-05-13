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

    if [ -n "${note}" ]; then
        echo '# Note'
        echo
        echo "> ${note}"
        echo
    fi
    echo '# Keys'
    echo
    echo "- \`${table}\`, \`${key}\`"
    echo
    echo '# Bind'
    echo
    echo '```tmux'
    echo "${bind}"
    echo '```'
}

main "$@"
