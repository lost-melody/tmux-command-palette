#!/usr/bin/env sh

cd "$(dirname "$0")"

PREVIEW="preview-key.sh"
SEDKEYBIND="sed-keybind.sh"

main() {
    source_file "./env.sh"

    local table="$1"

    local key="$(list_keys "${table}" | fuzzy_search "${table}")"
    execute_key "${table}" "${key}"

    return 0
}

source_file() {
    . "$@"
}

list_keys() {
    local table="$1"
    if [ -n "${table}" ]; then
        # list key bindings with notes
        tmux list-keys -NT "${table}" |
            sed -E 's/^(\S+)\s+/\1\t/'
        # list key bindings as valid config
        tmux list-keys -T "${table}" |
            sh "${SEDKEYBIND}" |
            sed -E 's/^(\S+)\s+(\S+)\s+(.*)$/\2\t\3/'
    fi
}

fuzzy_search() {
    local table="$1"
    # fuzzy search for a line and print the key
    ${FZFCMD} \
        --preview "echo {} | sh ${PREVIEW} ${table}" \
        --preview-window wrap |
        sed -E 's/^(\S+)\s+.*$/\1/'
}

execute_key() {
    local table="$1"
    local key="$2"
    if [ -n "${key}" ]; then
        if [ "${key}" = ";" ]; then
            key="\\${key}"
        fi

        local tmux_version="$(tmux -V)"
        if [ "${tmux_version}" = "3.4" -o "${tmux_version}" '>' "3.4" ]; then
            # tmux (>=3.4) supports "send-keys -K"
            tmux switch-client -T "${table}"
            tmux send-keys -K "${key}"
            return
        fi

        # tmux (<3.4) does not support "send-keys -K", execute commands instead
        # note: some commands (e.g. new-session) will not work
        local command="$(
            tmux list-keys -T "${table}" "${key}" |
                sh "${SEDKEYBIND}" |
                sed -E 's/^\S+\s+\S+\s+//'
        )"
        if [ -n "${command}" ]; then
            eval tmux ${command}
        fi
    fi
}

main "$@"
