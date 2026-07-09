# dotfiles

Personal configuration files, version-controlled and symlinked into place via
[`just`](https://github.com/casey/just). Keep configs in this repo; the installer
links them to the locations each tool expects, so edits here are live everywhere.

## Layout

```
dotfiles/
├── justfile                    # installer — creates the symlinks
├── configs/                    # tracked config files
│   ├── .zshrc                  # → ~/.zshrc
│   ├── starship.toml           # → ~/.config/starship.toml
│   ├── kitty.conf              # → ~/.config/kitty/kitty.conf
│   ├── presenterm/config.yaml  # → ~/.config/presenterm/config.yaml
│   └── helix/                  # → ~/.config/helix/
│       ├── config.toml
│       └── languages.toml
└── ollama/                     # local Ollama + OpenCode setup (own justfile)
```

## Requirements

- [`just`](https://github.com/casey/just) — `cargo install just` / `brew install just` / `pacman -S just`
- `bash` (recipes use it)

## Getting started

Run these from the repo root, in order.

1. **Clone the repo.** Its location matters — symlinks point at wherever the
   repo lives. Move it later and the links break; just re-run `just install`.
2. **Install `just`** (see Requirements above).
3. **`just check`** — dry run. Shows what `install` would do per config,
   changes nothing. Read the output:
   - `OK` — already linked correctly, will be left alone
   - `RELINK` — a symlink points elsewhere, will be replaced
   - `BACKUP` — a real file is in the way, will be moved to `*.bak` then linked
   - `LINK` — target missing, will be created
4. **`just install`** — create the symlinks. Any real file in the way (e.g.
   `~/.zshrc`) is moved to `<target>.bak` first, never deleted.
5. **Verify** — open a new shell / tool. From now on, edit configs **inside
   this repo**; the target paths are just symlinks back here.

`install` is idempotent — safe to re-run.

### Recipes

```sh
just            # list recipes
just check      # dry run — show what install would do, changes nothing
just install    # create the symlinks
just unlink     # remove symlinks that point into this repo
```

### Undo

```sh
just unlink              # remove the symlinks this repo created
mv ~/.zshrc.bak ~/.zshrc # restore a backed-up file (repeat per *.bak)
```

### Adding a config

1. Put the file under `configs/`.
2. Add one `source  target` line to the `links` block in the `justfile`
   (target is relative to `$HOME`).
3. `just check` to preview, `just install` to apply.

## Ollama

`ollama/` is a self-contained setup for running a local Ollama container and
wiring it into [OpenCode](https://opencode.ai). It has its **own justfile** and
is independent of the dotfiles installer above.

**Requires:** Docker + Docker Compose.

Run these from inside `ollama/`, in order.

1. **`cd ollama`** — the recipes assume this is the working directory.
2. **`just run`** — start the Ollama container detached
   (`docker compose up -d`). Serves on `localhost:11434`.
3. **`just install-models`** — pull/create the configured models. Model names
   and context sizes come from the `MODEL` / `SMALL_MODEL` variables at the top
   of `ollama/justfile`; each gets an `-opencode` variant via
   `scripts/install-model.sh`.
4. **`just list-models`** — confirm the models are installed in the container.
5. **`just create-opencode-config`** — write `~/.config/opencode/opencode.json`,
   pointing OpenCode at the local Ollama and registering the two models. Run
   this after the models exist.

### Changing models

Edit the `MODEL` / `MODEL_CTX` (and `SMALL_MODEL*`) variables at the top of
`ollama/justfile`, then re-run `just install-models` and
`just create-opencode-config`.

### Ollama recipes

```sh
just run                     # start the ollama container (docker compose up -d)
just list-models             # list models installed in the container
just install-models          # pull/create the configured models
just create-opencode-config  # write ~/.config/opencode/opencode.json
```
