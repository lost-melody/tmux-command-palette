#!/usr/bin/env sh

cd "$(dirname "$0")"

CONFIG="${XDG_CONFIG_HOME:-"${HOME}/.config"}"
CACHE="${TMUX_TMPDIR:-/tmp}"
CACHEDIR="${CACHE}/tmux-command-palette"
PREVIEW="preview-cmd.sh"
CACHECMD="cache-cmdlist.sh"

TAB="$(echo -e "\t")"
SEP="$(echo -e "\tCMD:PLT\t")"

main() {
    local list="${1:-commands}"
    sh "${CACHECMD}" "${list}" || exit

    local command="$(list_commands "${list}" | fuzzy_search "${list}")"
    if [ -n "${command}" ]; then
        eval tmux "${command}"
    fi
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
        fzf --tmux 80% -d "${SEP}" --with-nth 2 \
            --preview "echo {} | sh ${PREVIEW} ${list}" \
            --preview-window wrap |
            sed -E "s/^(:[0-9]+:)\s+.*$/\1/"
    )"

    # query that command from the command cache
    local cachefile="${CACHEDIR}/${list}.txt"
    grep "^  BIND${cmd_id}" "${cachefile}" |
        sed -E "s/^\s+BIND:[0-9]+:\s+//"
}

main "$@"
