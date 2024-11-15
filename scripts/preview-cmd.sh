#!/usr/bin/env sh

cd "$(dirname "$0")"

main() {
    source_file "./env.sh"

    local list="$1"
    local cachefile="${CACHEDIR}/${list}.txt"
    local cmd_id="$(sed -E "s/^(:[0-9]+:)\s+.*$/\1/")"
    local cmddef="$(mktemp "${CACHEDIR}/XXX.txt")"

    grep -A 2 "^COMMAND${cmd_id}" "${cachefile}" |
        sed -E -n \
            -e "s/^\s+NOTE:[0-9]+:\s+(\S+)\s+(.*)$/\1\n\2/" \
            -e "s/^\s+BIND:[0-9]+:\s+//" \
            -e 2p -e 3p \
            >"${cmddef}"

    local icon="$(head -n 1 "${cmddef}")"
    local note="$(head -n 2 "${cmddef}" | tail -n 1)"
    local cmd="$(tail -n 1 "${cmddef}")"

    echo "[cmdlist \"${list}\"]"
    if [ "${note}" != "${cmd}" ]; then
        echo
        echo "[Note]"
        echo "${icon}${TAB}${note}"
    fi
    echo
    echo "[Command]"
    echo "${cmd}"

    rm -rf "${cmddef}"
}

source_file() {
    . "$@"
}

main "$@"
