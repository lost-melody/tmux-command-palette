#!/usr/bin/env sh

main() {
    table="$1"
    key="$(tmux list-keys -T "${table}" \
        | sed 's/^bind-key \+\(-r\)\? \+-T \+[^ ]\+ \+//' \
        | fzf --tmux 70% \
        | sed 's/\([^ ]\+\).*$/\1/')"
    if [ -n "${key}" ]; then
        tmux switch-client -T "${table}"
        tmux send-keys -K "${key}"
    fi
}

main "$@"
