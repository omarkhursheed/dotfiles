# Dotfiles

Personal dotfiles for ML research, optimized for quick setup on SSH machines.

## Quick Install

```bash
# Clone and install
git clone https://github.com/omarkhursheed/dotfiles.git ~/dotfiles
~/dotfiles/install.sh

# Or with neovim config
~/dotfiles/install.sh --full
```

## What's Included

- **Shell config** - Portable bash/zsh with ML aliases
- **Tmux** - Prefix Ctrl-a, mouse support, GPU in status bar
- **Git** - Useful aliases and global gitignore
- **SSH** - Connection persistence and multiplexing
- **Neovim** - Minimal vim-friendly config (optional)

## Key Aliases

### GPU Monitoring
- `gpu` - nvidia-smi
- `gpuwatch` - watch nvidia-smi
- `gpumem` - show GPU memory
- `gpukill` - kill GPU python processes

### uv (Python)
- `uvenv <name>` - create and activate venv
- `uvsync` - sync dependencies
- `uvrun` - run with uv

### Training
- `tb <logdir>` - tensorboard
- `watchlog` - tail logs for metrics

### Tmux
- `tm [name]` - attach or create session
- `Ctrl-a |` - vertical split
- `Ctrl-a -` - horizontal split
- `Ctrl-a g` - GPU monitor split
- `Ctrl-a h/j/k/l` - vim-style navigation

### Git
- `lg` - lazygit
- `gs` - git status
- `glog` - pretty log

## Manual Setup

If you prefer manual setup:

```bash
# Shell
ln -sf ~/dotfiles/shell/zshrc ~/.zshrc  # or bashrc

# Git
ln -sf ~/dotfiles/git/gitconfig ~/.gitconfig
ln -sf ~/dotfiles/git/gitignore_global ~/.gitignore_global

# Tmux
ln -sf ~/dotfiles/tmux/tmux.conf ~/.tmux.conf

# SSH (append to existing config)
cat ~/dotfiles/ssh/config_defaults >> ~/.ssh/config
mkdir -p ~/.ssh/sockets
```
