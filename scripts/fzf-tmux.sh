#!/usr/bin/env sh

main() {
    source "./env.sh" --

    local args="$(mktemp "${CACHEDIR}/XXX.txt")"
    local input="$(mktemp "${CACHEDIR}/XXX.txt")"
    local output="$(mktemp "${CACHEDIR}/XXX.txt")"

    cat >"${input}"

    parse_opts "$@" >"${args}"
    if [ "$?" -ne 0 ]; then
        tmux display-message "failed to parse fzf options"
        return 1
    fi

    tmux popup -h 80% -w 80% -E \
        "cd '${PWD}' && cat '${input}' | eval fzf \$(cat ${args}) >'${output}'"

    cat "${output}"

    rm "${args}" "${input}" "${output}"
}

parse_opts() {
    getopt -o "d:" \
        -l "with-nth:,preview:,preview-window:" \
        -- "$@" \
        2>/dev/null
}

main "$@"
