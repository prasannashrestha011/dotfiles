

# Quick directory navigation
function cdd() {
    cd "$1" || echo "Directory not found"
}

# Git helpers
function gs() {
    git status
}

function ga() {
    git add .
    git commit -m "$1"
}

function gp() {
    git push
}

# System cleanup
function cleanup() {
    sudo apt update && sudo apt upgrade -y
    sudo apt autoremove -y
}

# Show disk usage
function duh() {
    df -h
}

