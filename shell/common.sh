# Common shell configuration for ML research
# Works on both bash and zsh, Linux and macOS
# Source this file from .bashrc or .zshrc

# ============================================
# GPU Monitoring (NVIDIA)
# ============================================
alias gpu='nvidia-smi'
alias gpuwatch='watch -n1 nvidia-smi'
alias gpumem='nvidia-smi --query-gpu=memory.used,memory.total --format=csv'

# Kill all Python processes on GPU
gpukill() {
    nvidia-smi | grep 'python' | awk '{print $5}' | xargs -I{} kill -9 {} 2>/dev/null
    echo "Killed GPU python processes"
}

# Show GPU processes
gpuproc() {
    nvidia-smi --query-compute-apps=pid,used_memory,process_name --format=csv
}

# ============================================
# uv - Fast Python Package Manager
# ============================================
alias uvsync='uv sync'
alias uvrun='uv run'
alias uvpip='uv pip'
alias uvlock='uv lock'

# Create and activate a new uv environment
uvenv() {
    local name="${1:-.venv}"
    uv venv "$name" && source "$name/bin/activate"
}

# Initialize new uv project
uvinit() {
    uv init
    uv sync
}

# ============================================
# Training & Logging
# ============================================
alias tb='tensorboard --logdir'
alias tblogs='ls -lt */events.out.tfevents.* 2>/dev/null | head -5'

# Watch training logs for metrics
watchlog() {
    local pattern="${1:-*.log}"
    tail -f $pattern 2>/dev/null | grep --line-buffered -iE "(loss|epoch|step|acc|error|val_)"
}

# Find recent checkpoints
ckpts() {
    find . -name "*.pt" -o -name "*.pth" -o -name "*.ckpt" 2>/dev/null | head -20
}

# ============================================
# Remote Utils
# ============================================
# Show listening ports
alias ports='ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null'

# Disk usage summary
diskuse() {
    echo "=== Filesystem ==="
    df -h | grep -E "^/dev|Filesystem"
    echo ""
    echo "=== Current Directory ==="
    du -sh * 2>/dev/null | sort -hr | head -10
}

# Kill process on port
killport() {
    if [ -z "$1" ]; then
        echo "Usage: killport <port>"
        return 1
    fi
    local pid=$(lsof -t -i:$1 2>/dev/null)
    if [ -n "$pid" ]; then
        kill -9 $pid
        echo "Killed process $pid on port $1"
    else
        echo "No process found on port $1"
    fi
}

# ============================================
# Git shortcuts
# ============================================
alias lg='lazygit'
alias gs='git status -sb'
alias gd='git diff'
alias gdc='git diff --cached'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --graph --decorate -20'

# ============================================
# Better defaults (with fallbacks)
# ============================================
# Use bat if available, otherwise cat
if command -v bat &>/dev/null; then
    alias cat='bat --paging=never'
fi

# Use eza/exa if available, otherwise ls
if command -v eza &>/dev/null; then
    alias ls='eza --color=auto'
    alias ll='eza -alF'
    alias la='eza -a'
    alias l='eza -F'
    alias tree='eza --tree'
elif command -v exa &>/dev/null; then
    alias ls='exa --color=auto'
    alias ll='exa -alF'
    alias la='exa -a'
    alias l='exa -F'
    alias tree='exa --tree'
else
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
fi

# Use btop/htop if available
if command -v btop &>/dev/null; then
    alias top='btop'
elif command -v htop &>/dev/null; then
    alias top='htop'
fi

# Grep with color
alias grep='grep --color=auto'

# ============================================
# Navigation shortcuts
# ============================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Make directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# ============================================
# Tmux helper
# ============================================
tm() {
    if [ -z "$1" ]; then
        tmux attach 2>/dev/null || tmux new-session
    else
        tmux new-session -A -s "$1"
    fi
}

# ============================================
# Python helpers
# ============================================
alias py='python'
alias ipy='ipython'
alias jl='jupyter lab'
alias jn='jupyter notebook'

# Quick Python HTTP server
serve() {
    local port="${1:-8000}"
    python -m http.server "$port"
}

# ============================================
# SSH helpers
# ============================================
# Forward port from remote
portfwd() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: portfwd <host> <port>"
        echo "Example: portfwd ml-server 8888"
        return 1
    fi
    ssh -N -L "$2:localhost:$2" "$1"
}

# ============================================
# Editor
# ============================================
export EDITOR='nvim'
alias vim='nvim'
alias vi='nvim'
