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
- [fzf](https://github.com/junegunn/fzf) `>=0.24.0`

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
popup="popup -h 80% -h 80%"
tmux_cmd --icon ' ' --note 'tgpt chat window' \
    --cmd "${popup} -E 'screen -R tgpt tgpt -i'"
tmux_cmd --note 'lazygit for chezmoi' \
    ---cmd "${popup} -E 'lazygit -p ~/.local/share/chezmoi'"
tmux_cmd --cmd "${popup} neofetch"
```

Where `tmux_cmd` is a shell function defined in the entry file:

```txt
tmux_cmd [-c|--cmd string] [-d|-n|-N|--desc|--note string] [-i|--icon string]
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
