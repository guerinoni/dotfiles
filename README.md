# dotfiles

Personal macOS development environment: shell, Git, Neovim, Ghostty, Atuin,
Homebrew packages, and macOS defaults.

## Install

```zsh
./install.sh
```

## Maintenance

```zsh
update       # macOS/Homebrew updates, without emptying Trash
devspace     # show large dev caches
devclean go  # clear Go build/test cache
devclean rust-cache-dry
devclean rust
devclean rust-targets-dry ~/hack
devclean nix-dry
```

The current machine pressure is mostly memory, not disk. Keep parallel agent
count intentional, use browser profiles/spaces for active work, and send
"read later" links to a queue instead of leaving every page live.
