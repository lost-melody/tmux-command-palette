#!/usr/bin/env sh

cd "$(dirname "$0")"

main() {
    source_file "./env.sh"

    local list="$1"
    local cachefile="${CACHEDIR}/${list}.txt"
    local cmd_id="$(sed -E "s/^(:[0-9]+:)[[:space:]]+.*$/\1/")"
    local cmddef="$(mktemp "${CACHEDIR}/XXX.txt")"

    grep -A 2 "^COMMAND${cmd_id}" "${cachefile}" |
        sed -E -n \
            -e "s/^[[:space:]]+NOTE:[0-9]+:[[:space:]]+([^[:space:]]+)[[:space:]]+(.*)$/\1\n\2/" \
            -e "s/^[[:space:]]+BIND:[0-9]+:[[:space:]]+//" \
            -e 2p -e 3p \
            >"${cmddef}"

    local icon="$(head -n 1 "${cmddef}")"
    local note="$(head -n 2 "${cmddef}" | tail -n 1)"
    local cmd="$(tail -n 1 "${cmddef}")"

    echo "# Note"
    echo
    echo "> ${icon}${TAB}${note}"
    echo
    echo '# Source'
    echo
    echo "- from list \`${list}\`"
    echo
    echo '# Command'
    echo
    echo '```sh'
    eval echo "${cmd}"
    echo '```'

    rm -rf "${cmddef}"
}

source_file() {
    . "$@"
}

main "$@"
