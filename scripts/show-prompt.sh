#!/usr/bin/env sh

main() {
    table="$1"
    key="$(list_keys "${table}" | fuzzy_search)"
    execute_key "${table}" "${key}"
}

list_keys() {
    table="$1"
    if [ -n "${table}" ]; then
        # list key bindings with notes
        tmux list-keys -NT "${table}"
        # list key bindings as valid config
        tmux list-keys -T "${table}" |
            sed 's/^bind-key \+\(-r \+\)\?-T \+[^ ]\+ \+//'
    fi
}

fuzzy_search() {
    # fuzzy search for a line and print the key
    fzf --tmux 70% |
        sed 's/\([^ ]\+\).*$/\1/'
}

execute_key() {
    table="$1"
    key="$2"
    if [ -n "${key}" ]; then
        tmux switch-client -T "${table}"
        tmux send-keys -K "${key}"
    fi
}

main "$@"
