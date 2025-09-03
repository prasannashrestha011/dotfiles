
alias ll='ls -la'
alias gs='git status'
alias gp='git pull'
alias ..='cd ..'

# Pinger service management shortcuts
alias pinger-start='sudo systemctl start pinger.service'
alias pinger-stop='sudo systemctl stop pinger.service'
alias pinger-restart='sudo systemctl restart pinger.service'
alias pinger-status='systemctl status pinger.service'
alias pinger-logs='journalctl -u pinger.service -f'
