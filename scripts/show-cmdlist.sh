#!/usr/bin/env sh

CONFIG="${XDG_CONFIG_HOME:-"${HOME}/.config"}"
COMMANDSDIR="${CONFIG}/tmux-command-palette"
TAB="$(echo -e "\t")"
SEP="$(echo -e "\tCMD:PLT\t")"

main() {
    local list="${1:-commands}"
    local listfile="${COMMANDSDIR}/${list}.sh"
    if [ -f "${listfile}" ]; then
        local command="$(list_commands "${listfile}" | fuzzy_search)"
        if [ -n "${command}" ]; then
            eval tmux "${command}"
        fi
    else
        tmux display-message "command list file not found: ${listfile}"
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
        echo "${cmd}${SEP}${icon:-">_"}${TAB}${note:-"${cmd}"}"
    fi
}

list_commands() {
    local listfile="$1"
    source "${listfile}" ||
        tmux display-message "failed to execute command list file: ${listfile}"
}

fuzzy_search() {
    # fuzzy search for a line and print the key
    fzf --tmux 80% -d "${SEP}" --with-nth 2 |
        sed -E -e "s/^(.*)${SEP}.*$/\1/"
}

main "$@"
