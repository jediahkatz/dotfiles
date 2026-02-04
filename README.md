# dotfiles

Personal dotfiles for macOS and WSL.

## What's included

| Tool | Config | Notes |
|------|--------|-------|
| **zsh** | `.zshrc` | Oh My Zsh, Powerlevel10k, mise, custom functions |
| **Powerlevel10k** | `.p10k.zsh` | Lean style with nerd font glyphs |
| **tmux** | `osx/.tmux.conf`, `wsl/.tmux.conf` | Prefix `C-a`, TPM plugins, Solarized dark theme, battery status |
| **Alacritty** | `.alacritty.toml` | MesloLGS NF font, xterm-256color |
| **nano** | `osx/.nanorc` | Syntax highlighting via Homebrew nano |
| **Windows Terminal** | `WindowsTerminal/settings.json` | WSL profile with tmux auto-attach |

### CLI tools (installed via Homebrew on macOS)

`tmux` `fzf` `fd` `ripgrep` `bat` `lsd` `diff-so-fancy` `hub` `nano` `tlrc` `mise`

### Zsh plugins

`fzf-tab` `zsh-z` `zsh-autosuggestions` `fast-syntax-highlighting`

### Tmux plugins (via TPM)

`tmux-better-mouse-mode` `extrakto` `tmux-resurrect` `tmux-battery`

## Install (macOS)

```bash
git clone https://github.com/jediahkatz/dotfiles ~/dotfiles
cd ~/dotfiles
./scripts/install-macos.sh
```

The install script is idempotent — safe to run multiple times. It will:

1. Install Homebrew (if missing)
2. Install CLI tools via `brew` (including `mise` for version management)
3. Install Oh My Zsh, Powerlevel10k, and zsh plugins
4. Install Node.js LTS via mise
5. Install TPM and tmux plugins
6. Install MesloLGS Nerd Font
7. Create symlinks (backing up any existing files to `*.bak`)

After installing, restart your terminal or run `exec zsh -l`.

### Font

The [MesloLGS Nerd Font](https://github.com/ryanoasis/nerd-fonts) is installed automatically
via `brew install --cask font-meslo-lg-nerd-font`. Set your terminal font to `MesloLGS Nerd Font`.

### Node.js version management

[mise](https://mise.jdx.dev/) manages Node.js (and other tool) versions. It reads `.nvmrc`,
`.node-version`, and `.mise.toml` files automatically.

```bash
mise use node@20           # use Node 20 in current project
mise use --global node@lts # set global default
mise ls                    # list installed versions
```

## Install (WSL)

See `scripts/README` for the WSL install order. The WSL scripts (`scripts/bash.sh`,
`scripts/zsh.sh`, `scripts/powershell.ps1`) are older and may need updates.

## Structure

```
.
├── .alacritty.toml        # Alacritty terminal config (TOML, current format)
├── .alacritty.yml         # Alacritty config (legacy YAML format, kept for reference)
├── .p10k.zsh              # Powerlevel10k theme configuration
├── .zshrc                 # Main zsh configuration
├── osx/
│   ├── .tmux.conf         # tmux config for macOS
│   └── .nanorc            # nano config for macOS (Homebrew paths)
├── wsl/
│   └── .tmux.conf         # tmux config for WSL
├── WindowsTerminal/
│   └── settings.json      # Windows Terminal settings
└── scripts/
    ├── install-macos.sh   # macOS install script (recommended)
    ├── bash.sh            # Legacy: install zsh on Ubuntu
    ├── zsh.sh             # Legacy: original install notes
    ├── powershell.ps1     # Legacy: WSL2 setup from PowerShell
    └── README             # Legacy script run order
```

## Symlinks created

| Source | Destination |
|--------|-------------|
| `~/dotfiles/.zshrc` | `~/.zshrc` |
| `~/dotfiles/.p10k.zsh` | `~/.p10k.zsh` |
| `~/dotfiles/.alacritty.toml` | `~/.alacritty.toml` |
| `~/dotfiles/osx/.tmux.conf` | `~/.tmux.conf` |
| `~/dotfiles/osx/.nanorc` | `~/.nanorc` |

## Custom shell functions

| Function | Description |
|----------|-------------|
| `copy <file>` | Copy file contents to clipboard (strips trailing newlines) |
| `mcd <dir>` | Create a directory and cd into it |
| `fif <term> [dir]` | Find-in-file using ripgrep + fzf |
| `slice <start:stop:step> [file]` | Python-style line slicing |
| `diff` | Wraps `diff` with `diff-so-fancy` output |
| `reload` | Reload the shell |
