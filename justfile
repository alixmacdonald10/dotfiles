# dotfiles installer — symlink configs into place
# Usage: just install   |   just check   |   just unlink

DOTFILES := justfile_directory()

# config-source : link-target  (relative to $HOME)
# edit this list when adding new configs
links := '''
configs/.zshrc                 .zshrc
configs/starship.toml          .config/starship.toml
configs/kitty.conf             .config/kitty/kitty.conf
configs/presenterm/config.yaml .config/presenterm/config.yaml
configs/helix/config.toml      .config/helix/config.toml
configs/helix/languages.toml   .config/helix/languages.toml
'''

# Default: show available recipes
default:
    @just --list

# Create all symlinks (backs up existing real files as *.bak)
install:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "{{links}}" | while read -r src dst; do
        [ -z "$src" ] && continue
        SRC="{{DOTFILES}}/$src"
        DST="$HOME/$dst"

        if [ ! -e "$SRC" ]; then
            echo "SKIP   missing source: $SRC"
            continue
        fi

        # already correctly linked?
        if [ -L "$DST" ] && [ "$(readlink "$DST")" = "$SRC" ]; then
            echo "OK     $dst"
            continue
        fi

        mkdir -p "$(dirname "$DST")"

        # back up a real file / wrong symlink
        if [ -e "$DST" ] || [ -L "$DST" ]; then
            if [ -L "$DST" ]; then
                echo "RELINK $dst (was -> $(readlink "$DST"))"
                rm "$DST"
            else
                echo "BACKUP $dst -> $dst.bak"
                mv "$DST" "$DST.bak"
            fi
        else
            echo "LINK   $dst"
        fi

        ln -s "$SRC" "$DST"
    done

# Show what install would do without changing anything
check:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "{{links}}" | while read -r src dst; do
        [ -z "$src" ] && continue
        SRC="{{DOTFILES}}/$src"
        DST="$HOME/$dst"
        if [ -L "$DST" ] && [ "$(readlink "$DST")" = "$SRC" ]; then
            printf '%-8s %s\n' OK "$dst"
        elif [ -L "$DST" ]; then
            printf '%-8s %s -> %s\n' RELINK "$dst" "$(readlink "$DST")"
        elif [ -e "$DST" ]; then
            printf '%-8s %s\n' BACKUP "$dst"
        else
            printf '%-8s %s\n' LINK "$dst"
        fi
    done

# Remove symlinks that point into this repo (leaves *.bak in place)
unlink:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "{{links}}" | while read -r src dst; do
        [ -z "$src" ] && continue
        SRC="{{DOTFILES}}/$src"
        DST="$HOME/$dst"
        if [ -L "$DST" ] && [ "$(readlink "$DST")" = "$SRC" ]; then
            rm "$DST"
            echo "REMOVED $dst"
        fi
    done
