#!/usr/bin/env sh

cd "$(dirname "$0")"

FZFTMUX="fzf-tmux.sh"
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
    sh "${FZFTMUX}" \
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
