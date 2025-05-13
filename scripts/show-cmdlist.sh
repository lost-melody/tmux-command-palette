#!/usr/bin/env sh

cd "$(dirname "$0")"

PREVIEW="preview-cmd.sh"
RENDER="render.sh"
CACHECMD="cache-cmdlist.sh"

main() {
    source_file "./env.sh"

    local list="${1:-commands}"
    sh "${CACHECMD}" "${list}" || return

    local command="$(list_commands "${list}" | fuzzy_search "${list}")"
    if [ -n "${command}" ]; then
        eval tmux "${command}"
    fi

    return 0
}

source_file() {
    . "$@"
}

list_commands() {
    local list="$1"
    local cachefile="${CACHEDIR}/${list}.txt"
    grep "^  NOTE:" "${cachefile}" | sed -E "s/^\s+NOTE(:[0-9]+:)\s+/\1${SEP}/"
}

fuzzy_search() {
    local list="$1"

    # fuzzy search for a line and print the key
    local cmd_id="$(
        ${FZFCMD} \
            -d "${SEP}" --with-nth 2 \
            --preview "echo {} | sh ${PREVIEW} ${list} | sh ${RENDER}" \
            --preview-window wrap |
            sed -E "s/^(:[0-9]+:)\s+.*$/\1/"
    )"

    if [ -n "${cmd_id}" ]; then
        # query that command from the command cache
        local cachefile="${CACHEDIR}/${list}.txt"
        grep "^  BIND${cmd_id}" "${cachefile}" |
            sed -E "s/^\s+BIND:[0-9]+:\s+//"
    fi
}

main "$@"
