#!/usr/bin/env sh

cd "$(dirname "$0")"

main() {
    source_file "./env.sh"

    local list="$1"
    local cmdfile="${CMDSDIR}/${list}.sh"
    if [ ! -f "${cmdfile}" ]; then
        if [ "${list}" = "commands" ]; then
            # copy default cmdfile template
            cp "commands.sh.example" "${cmdfile}"
        else
            tmux display-message "command list file not found: ${cmdfile}"
            return 1
        fi
    fi

    local cachefile="${CACHEDIR}/${list}.txt"
    if [ ! -f "${cachefile}" -o "${cmdfile}" -nt "${cachefile}" ]; then
        local CMD_ID=0
        source_file "${cmdfile}" >"${cachefile}" 2>/dev/null
        if [ "$?" -ne 0 ]; then
            tmux display-message "failed to source command list file: ${cmdfile}"
            return 1
        fi
    fi
}

source_file() {
    . "$@"
}

parse_cmdargs() {
    local opts="$(getopt -q -o c:d:f:i:n:N: -l cmd:,desc:,flags:,icon:,note: -- "$@")" || return 1
    eval set -- "${opts}"

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
        -f | --flags)
            flags="$2"
            shift 2
            ;;
        -i | --icon)
            icon="$2"
            shift 2
            ;;
        --)
            shift
            if [ -z "${cmd}" ]; then
                # escape the cmd string
                cmd="$(
                    getopt -q -o "" -- -- "$@" | sed -E "s/^\s+--\s+//"
                )"
            fi
            break
            ;;
        *)
            return 1
            ;;
        esac
    done
}

tmux_cmd() {
    local cmd=""
    local icon=""
    local note=""
    local flags=""
    parse_cmdargs "$@" || return 1

    if [ -n "${cmd}" ]; then
        CMD_ID=$((CMD_ID+1))
        echo "COMMAND:${CMD_ID}:"
        echo "  NOTE:${CMD_ID}: ${icon:-">_"}${TAB}${note:-"$(eval echo "${cmd}")"}"
        echo "  BIND:${CMD_ID}: ${cmd}"
    fi
}

popup_cmd() {
    local cmd=""
    local icon=""
    local note=""
    local flags=""
    parse_cmdargs "$@" || return 1

    if [ -n "${cmd}" ]; then
        tmux_cmd --icon "${icon}" --note "${note}" -- \
            display-popup -h 80% -w 80% ${flags} "${cmd}"
    fi
}

shell_cmd() {
    local cmd=""
    local icon=""
    local note=""
    local flags=""
    parse_cmdargs "$@" || return 1

    if [ -n "${cmd}" ]; then
        tmux_cmd --icon "${icon}" --note "${note}" -- \
            run-shell ${flags} "${cmd}"
    fi
}

send_cmd() {
    local cmd=""
    local icon=""
    local note=""
    local flags=""
    parse_cmdargs "$@" || return 1

    if [ -n "${cmd}" ]; then
        tmux_cmd --icon "${icon}" --note "${note}" -- \
            send-keys ${flags} "${cmd}"
    fi
}

main "$@"
