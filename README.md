# dotfiles

Personal macOS development environment: shell, Git, Neovim, Ghostty, Atuin,
Homebrew packages, and macOS defaults.

## Install

```zsh
./install.sh
```

## After install

A script can't do these:

- Give your terminal Full Disk Access and App Management in System Settings ->
  Privacy & Security, then rerun `./macos.sh`. Without Full Disk Access it skips
  the Safari, Terminal, TextEdit, App Store and System Settings prefs. Without
  App Management, Homebrew can't upgrade some casks.
- Import the GPG key named in `.gitconfig`. Every commit is signed, so commits
  fail until it's there.
- Add an SSH key to GitHub. Pushes to GitHub go over SSH, even for HTTPS clones.
- Create `~/.gitconfig.local` if you need it. It's untracked and holds work URL
  rewrites and per-directory identity.
- Log out and back in. A few macOS settings only apply after that.

## Maintenance

```zsh
update       # macOS/Homebrew updates, without emptying Trash
devspace     # show large dev caches
devclean go  # clear Go build/test cache
devclean rust-cache-dry
devclean rust
devclean rust-targets-dry ~/hack
devclean nix-dry
devpkg list     # global go, cargo and npm packages
devpkg go-rm    # pick Go binaries to delete (fzf), or pass names
devpkg rust-rm
devpkg node-rm
```

The current machine pressure is mostly memory, not disk. Keep parallel agent
count intentional, use browser profiles/spaces for active work, and send
"read later" links to a queue instead of leaving every page live.
