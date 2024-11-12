#!/usr/bin/env sh

CONFIG="${XDG_CONFIG_HOME:-"${HOME}/.config"}"
COMMANDSDIR="${CONFIG}/tmux-command-palette"
SEP="$(echo -e "\tCMD:PLT\t")"

main() {
    list="${1:-commands}"
    listfile="${COMMANDSDIR}/${list}.sh"
    if [ -f "${listfile}" ]; then
        command="$(list_commands "${listfile}" | fuzzy_search)"
        if [ -n "${command}" ]; then
            eval tmux "${command}"
        fi
    else
        tmux display-message "command list file not found: ${listfile}"
    fi
}

tmux_cmd() {
    opts="$(getopt -q -o c:d:n:N: -l cmd:,desc:,note: -- "$@")" || return 1
    eval set -- "${opts}"
    cmd=""
    note=""

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
        echo "${cmd}${SEP}${note:-"${cmd}"}"
    fi
}

list_commands() {
    listfile="$1"
    source "${listfile}" ||
        tmux display-message "failed to execute command list file: ${listfile}"
}

fuzzy_search() {
    # fuzzy search for a line and print the key
    fzf --tmux 70% -d "${SEP}" --with-nth 2 |
        sed -E -e "s/^(.*)${SEP}.*$/\1/"
}

main "$@"
