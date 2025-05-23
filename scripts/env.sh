#!/usr/bin/env sh

__init() {
    local opts="$(getopt -o "c" -l "clean" -- "$@")" || return 1
    eval set -- "${opts}"

    while true; do
        case "$1" in
        -c | --clean)
            local clean=true
            shift
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

    __set_env
    if [ -n "${clean}" ]; then
        __clean_cache
    fi
    __make_dirs

    unset -f __init __set_env __make_dirs __clean_cache
}

__set_env() {
    if [ -z "${CMDSDIR}" ]; then
        local confdir="${XDG_CONFIG_HOME:-"${HOME}/.config"}"
        CMDSDIR="${confdir}/tmux-command-palette"
    fi

    if [ -z "${CACHEDIR}" ]; then
        local tmpdir="${TMUX_TMPDIR:-"${TMPDIR:-/tmp}"}"
        CACHEDIR="${tmpdir}/tmux-command-palette-$(id -u)"
    fi

    local fzf_version="$(fzf --version | cut -d " " -f 1)"
    if test "${fzf_version}" '<' "0.53.0" || test "${fzf_version}" = "0.61.2"; then
        # fzf versions before 0.53.0 do not support the tmux integration
        # version 0.61.2 has a bug that prevents it from working
        FZFCMD="sh fzf-tmux.sh"
    else
        FZFCMD="fzf --tmux 80%"
    fi

    if [ -z "${TAB}" ]; then
        TAB="$(printf "\t")"
    fi
    if [ -z "${SEP}" ]; then
        SEP="$(printf "\tCMD:PLT\t")"
    fi
}

__make_dirs() {
    if [ ! -d "${CMDSDIR}" ]; then
        mkdir -p "${CMDSDIR}"
    fi

    if [ ! -d "${CACHEDIR}" ]; then
        mkdir -p "${CACHEDIR}"
    fi
}

__clean_cache() {
    if [ -d "${CACHEDIR}" ]; then
        rm -rf "${CACHEDIR}"
    fi
}

__init "$@"
