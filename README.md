# Tmux Command Palette

## Features

*Tmux Command Palette* is actually *Keybinding Palette* despite its name.

- Pressing `prefix` then `?` shows the palette for key table *prefix*.
- Pressing `prefix` then `BSpace` shows the palette for key table *root*.
- Pressing `?` in `copy-mode` shows the palette for key table *copy-mode*.

## Installation

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

Set key tables that command palette should bind keys for:

```tmux
# leave empty for all tables
set -g @cmdpalette-tables 'root,prefix,copy-mode-vi'
```

Use custom keys for key tables:

```tmux
# 'prefix ?' -> cmdpalette 'prefix', defaults to '?'
set -g @cmdpalette-key-prefix '?'
# 'prefix BSpace' -> cmdpalette 'root'
set -g @cmdpalette-key-root 'BSpace'
# 'copy-mode-vi C-/' -> cmdpalette 'copy-mode-vi'
set -g @cmdpalette-key-copy-mode-vi 'C-/'
```

## Similar Projects

- [tmux-which-key](https://github.com/alexwforsythe/tmux-which-key)
- [tmux-menus](https://github.com/jaclu/tmux-menus)
