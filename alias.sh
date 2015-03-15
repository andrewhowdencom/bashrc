# Aliases
alias psgr="ps aux | grep -i"  # Search running processes for string
alias llgr="ls -alF | grep -i" # Search files within a given folder
alias cpp="rsync --progress "  # Copy with progress bar, using RSYNC
alias ssh="ssh -v "            # Make ssh more talkative by default

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
