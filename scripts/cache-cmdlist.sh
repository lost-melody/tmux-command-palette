#!/usr/bin/env sh

cd "$(dirname "$0")"

CONFIG="${XDG_CONFIG_HOME:-"${HOME}/.config"}"
CMDSDIR="${CONFIG}/tmux-command-palette"
CACHE="${TMUX_TMPDIR:-/tmp}"
CACHEDIR="${CACHE}/tmux-command-palette"

TAB="$(echo -e "\t")"

main() {
    local list="$1"
    local cmdfile="${CMDSDIR}/${list}.sh"
    if [ ! -f "${cmdfile}" ]; then
        tmux display-message "command list file not found: ${cmdfile}"
        exit 1
    fi

    mkdir -p "${CACHEDIR}"
    local cachefile="${CACHEDIR}/${list}.txt"
    if [ ! -f "${cachefile}" -o "${cmdfile}" -nt "${cachefile}" ]; then
        local CMD_ID=0
        source "${cmdfile}" >"${cachefile}" 2>/dev/null
        if [ "$?" -ne 0 ]; then
            tmux display-message "failed to source command list file: ${cmdfile}"
            exit 1
        fi
    fi
}

tmux_cmd() {
    local opts="$(getopt -q -o c:d:i:n:N: -l cmd:,desc:,icon:,note: -- "$@")" || return 1
    eval set -- "${opts}"
    local cmd=""
    local icon=""
    local note=""

    while true; do
        case "$1" in
        -c | --cmd)
            cmd="$2"
            shift 2
            ;;
        -d | -n | -N | --desc | --note)
            note="$2"
            shift 2
            ;;
        -i | --icon)
            icon="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            return 1
            ;;
        esac
    done

    if [ -n "${cmd}" ]; then
        let CMD_ID++
        echo "COMMAND:${CMD_ID}:"
        echo "  NOTE:${CMD_ID}: ${icon:-">_"}${TAB}${note:-"${cmd}"}"
        echo "  BIND:${CMD_ID}: ${cmd}"
    fi
}

main "$@"
