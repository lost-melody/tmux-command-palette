#!/usr/bin/env sh

cd "$(dirname "$0")"

main() {
    # check whether a custom render command is configured
    local render="$(tmux show-options -gqv @cmdpalette-render-cmd)"
    if [ -n "${render}" ]; then
        # custom render command, e.g. `tee /tmp/preview.md | nl -ba`
        eval ${render}
    elif command -v mdcat >/dev/null; then
        # use `mdcat` if available
        mdcat
    else
        cat
    fi
}

main "$@"
