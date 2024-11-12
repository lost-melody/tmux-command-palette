# Tmux Command Palette

## Features

_Tmux Command Palette_ is actually _Keybinding Palette_ despite its name.

- Pressing `prefix` then `?` shows the palette for key table _prefix_.
- Pressing `prefix` then `BSpace` shows the palette for key table _root_.
- Pressing `?` in `copy-mode` shows the palette for key table _copy-mode_.
- Pressing `prefix` then `P` shows the palette for a custom command list.

## Installation

Requirements:

- [tmux](https://github.com/tmux/tmux) `>=3.3`
- [fzf](https://github.com/junegunn/fzf) `>=0.53.0`

### TPM (Tmux Plugin Manager)

- Install [tpm](https://github.com/tmux-plugins/tpm).
- Add this plugin to the list of TPM plugins in `~/.tmux.conf`:
  ```tmux
  set -g @plugin 'lost-melody/tmux-command-palette'
  ```
- Press `prefix` then `I` (in tmux) to install it.

### Manually

Optionally, you may clone this repo and simply run the initialization script in `~/.tmux.conf`:

```tmux
run-shell $PATH_TO_CMDPALETTE/init.tmux
```

## Configuration

### Keybindings Table

Set key tables that command palette should bind keys for:

```tmux
# leave empty for all tables
set -g @cmdpalette-tables 'root,prefix,copy-mode-vi'
```

Use custom keys for key tables:

```tmux
# 'prefix ?' -> cmdpalette 'prefix', defaults to '?'
set -g @cmdpalette-key-prefix 'prefix ?'
# 'prefix BSpace' -> cmdpalette 'root'
set -g @cmdpalette-key-root 'prefix BSpace'
# 'copy-mode-vi C-/' -> cmdpalette 'copy-mode-vi'
set -g @cmdpalette-key-copy-mode-vi 'copy-mode-vi C-/'
```

### Extended Keybindings Table

> Note: you probably want to use the Custom Command List below instead.

We can bind commands to unicode characters, even if we don't actually have the key:

```tmux
# for example, we bind a tgpt popup window to a nerd symbol '', in custom table 'cmdpalette'
bind-key -N 'tgpt chat window' -T cmdpalette '' popup -E -h 70% -w 70% "screen -r tgpt || screen -S tgpt tgpt -i"
```

Then we bind `prefix P` to command palette for table `cmdpalette`:

```tmux
set -g @cmdpalette-cmdpalette 'prefix P'
```

Now we can press `prefix` then `P` and choose our commands from the palette.

### Custom Command List

Command list is a shell script that is sourced by the palette entry file, where we register a series of tmux commands.

First create the shell script:

```sh
mkdir -p ~/.config/tmux-command-palette
touch ~/.config/tmux-command-palette/commands.sh
```

Then register commands in the file:

```sh
# commands.sh
tmux_cmd --note '  tgpt chat window' --cmd 'popup -E -h 70% -w 70% "screen -r tgpt || screen -S tgpt tgpt -i"'
tmux_cmd --cmd 'popup neofetch'
```

Where `tmux_cmd` is a shell function defined in the entry file:

```sh
# tmux_cmd [-c|--cmd str] [-d|-n|-N|--desc|--note str]
tmux_cmd() {
    opts="$(getopt -q -o c:d:n:N: -l cmd:,desc:,note: -- "$@")" || return 1
    # ...
}
```

Custom key binding for raising the command palette:

```tmux
# same to the script file name, defaults to 'commands'
set -g @cmdpalette-cmdlists 'commands'
# 'prefix P' -> cmdpalette 'commands'
set -g @cmdpalette-cmd-commands 'prefix P'
```

Now we can press `prefix` then `P` and choose our commands from the palette.

## Similar Projects

- [tmux-which-key](https://github.com/alexwforsythe/tmux-which-key)
- [tmux-menus](https://github.com/jaclu/tmux-menus)
