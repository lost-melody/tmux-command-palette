# Tmux Command Palette

## Features

_Tmux Command Palette_ is actually _Keybinding Palette_ despite its name.

- Pressing `prefix` then `?` shows the palette for key table _prefix_.
- Pressing `prefix` then `BSpace` shows the palette for key table _root_.
- Pressing `?` in `copy-mode` shows the palette for key table _copy-mode_.
- Pressing `prefix` then `M-m` shows the palette for a custom command list.

## Screenshots

<details>
<summary>Keybinding Palette</summary>

![tmux-cmdpalette01.png](https://i.postimg.cc/TPVRms29/tmux-cmdpalette01.png)
![tmux-cmdpalette02.png](https://i.postimg.cc/mZXTQC40/tmux-cmdpalette02.png)

</details>

<details>
<summary>Command Palette</summary>

![tmux-cmdpalette03.png](https://i.postimg.cc/7YjDR4f9/tmux-cmdpalette03.png)

</details>

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
tmux_cmd --icon "󰑕 " --note "Rename session" -- \
    command-prompt -p "session name:" "rename-session %1"
shell_cmd --icon "󰈹 " --note "Launch firefox" -- \
    firefox
local editor="${EDITOR:-"vim"}"
popup_cmd --icon "󰤌 " --note "Edit this list of commands" --flags "-E" -- \
    ${editor} "${cmdfile}"
```

With `tmux_cmd`, `shell_cmd`, `popup_cmd` defined in the entry file:

```txt
tmux_cmd [--note string] [--icon string] -- [command]
shell_cmd [--note string] [--icon string] -- [command]
popup_cmd [--note string] [--icon string] -- [command]
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
