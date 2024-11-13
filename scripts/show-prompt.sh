#!/usr/bin/env sh

main() {
    local table="$1"
    local key="$(list_keys "${table}" | fuzzy_search)"
    execute_key "${table}" "${key}"
}

list_keys() {
    local table="$1"
    if [ -n "${table}" ]; then
        # list key bindings with notes
        tmux list-keys -NT "${table}"
        # list key bindings as valid config
        tmux list-keys -T "${table}" |
            sed -E \
                -e 's/^bind-key\s+//' \
                -e 's/^(-r\s+)?//' \
                -e 's/^-T\s+\S+\s+//'
    fi |
        sed -E -e 's/^\\?(\S+)\s+/\1\t/'
}

fuzzy_search() {
    # fuzzy search for a line and print the key
    fzf --tmux 80% |
        sed -E -e 's/^(\S+).*$/\1/'
}

execute_key() {
    local table="$1"
    local key="$2"
    if [ -n "${key}" ]; then
        tmux switch-client -T "${table}"
        tmux send-keys -K "${key}"
    fi
}

main "$@"
