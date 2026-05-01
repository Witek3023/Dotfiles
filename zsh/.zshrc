#           _ _       _
# __      _(_) |_ ___| | ____ _
# \ \ /\ / / | __/ _ \ |/ / _` |
#  \ V  V /| | ||  __/   < (_| |
#   \_/\_/ |_|\__\___|_|\_\__, |
#                         |___/
# Witek3023 | Functional but Minimal
# https://github.com/Witek3023

# --- EXPORTS && ENV ---
export TERM="xterm-256color"
export EDITOR="emacsclient -t -a ''"
export VISUAL="emacsclient -c -a emacs"
export LANG=en_US.UTF-8
export KEYTIMEOUT=1 # Reduce delay

# --- XDG PATHS ---
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# --- MAN COLORS && LESS --- 
export MANPAGER="less -R --use-color -Dd+b -Du+g" # Add colors to man pages
export MANROFFOPT="-c"
export LESS="-R" # Handle ANSI color escape sequences correctly

### --- FZF DEFAULTS ---
export FZF_DEFAULT_OPTS="--layout=reverse --exact --border=bold --border=rounded --margin=3% --color=dark"

# --- HISTORY ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)" # Don't log common commands

# --- ZSH OPTIONS ---
setopt AUTO_CD              # Enter directory without 'cd'
setopt CORRECT              # Suggest corrections for typos
setopt SHARE_HISTORY        # Share history across multiple sessions
setopt HIST_IGNORE_ALL_DUPS # Delete duplicates from history
setopt HIST_REDUCE_BLANKS   # Remove whitespaces from history commands
setopt INTERACTIVE_COMMENTS # Allow comments even in interactive shells
setopt PUSHD_IGNORE_DUPS    # Ignore copies of the same dir when pushing onto the stack
setopt PUSHD_SILENT         # Do not print the directory stack after pushd/popd
setopt NO_BEEP              # Disable beep
setopt AUTO_LIST            # Automatically list choices on completion
setopt AUTO_MENU            # Show completion menu on a tab press
setopt LIST_PACKED          # Use a compact layout for the completion list
setopt PROMPT_SUBST         # Variables in prompts (git prompt)

# --- PATH ---
path=(
  $HOME/.bin
  $HOME/.local/bin
  $HOME/.emacs.d/bin
  $HOME/.config/emacs/bin/
  $HOME/Applications
  /var/lib/flatpak/exports/bin/
  $HOME/.spicetify
  $path # Keep previous path
)
typeset -U path # Remove path duplicates

# --- COMPLETION ---
# Change default directory
ZCOMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump"
mkdir -p "$(dirname "$ZCOMPDUMP")"

# Optimized cache - new file once a day
autoload -Uz compinit
if [[ -s "$ZCOMPDUMP" && (! -f "$ZCOMPDUMP"(N.m1)) ]]; then
  compinit -C -d "$ZCOMPDUMP" # -C skips security checks for speed
else
  compinit -d "$ZCOMPDUMP"
fi

# Compile zcompdump for faster loading in the background
if [[ -s "$ZCOMPDUMP" && (! -s "${ZCOMPDUMP}.zwc" || "$ZCOMPDUMP" -nt "${ZCOMPDUMP}.zwc") ]]; then
  zcompile "$ZCOMPDUMP"
fi

# --- LS_COLORS files coloring ---
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="${LS_COLORS/di=01;34/di=01;32}" # Replace blue with green for directories
    export LS_COLORS="${LS_COLORS/di=34/di=32}" 
fi

# Enhanced Tab-Completion Menu
zstyle ':completion:*' menu select # Use a navigable menu
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} # Match menu colors to LS_COLORS
zstyle ':completion:*' group-name '' # Group results by type
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f' # Header for groups
export COMPLETION_WAITING_DOTS="%F{green}waiting...%f"

# Word selection behavior (makes Ctrl+W stop at slashes/dots)
autoload -U select-word-style
select-word-style bash

# --- KEYBINDINGS ---
bindkey '^[[Z' reverse-menu-complete    # Shift-Tab to go backwards in completion menu
bindkey '^[[1;5C' forward-word          # Ctrl + Right
bindkey '^[[1;5D' backward-word         # Ctrl + Left
bindkey '^[[H' beginning-of-line        # Home key
bindkey '^[[F' end-of-line              # End key
bindkey '^[[3~' delete-char             # Delete key
bindkey '^H' backward-kill-word         # Ctrl + Backspace
bindkey '^[[3;5~' kill-word             # Ctrl + Delete

# --- PLUGINS ---
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
ZSH_AUTOSUGGEST_STRATEGY=(history completion) # Suggest based on history, then completion engine
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- FUNCTIONS ---

# Visual Countdown
cdown () {
  N=$1
  while [[ $((--N)) -gt 0 ]]; do
    echo "$N" | figlet -c | lolcat && sleep 1
  done
}

# Universal Extract Tool
function ex {
  if [ -z "$1" ]; then
    echo "Usage: ex <file>"
  else
    for n in "$@"; do
      if [ -f "$n" ]; then
        case "${n%,}" in
          *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) tar xvf "$n" ;;
          *.lzma) unlzma ./"$n" ;;
          *.bz2) bunzip2 ./"$n" ;;
          *.rar) unrar x -ad ./"$n" ;;
          *.gz) gunzip ./"$n" ;;
          *.zip|*.epub) unzip ./"$n" ;;
          *.7z|*.deb|*.iso) 7z x ./"$n" ;;
          *) echo "ex: '$n' - unknown method"; return 1 ;;
        esac
      else
        echo "'$n' - file does not exist"; return 1
      fi
    done
  fi
}

# Move to parent direcotry
up () {
  local d=""
  local limit="${1:-1}"
  for ((i=1;i<=limit;i++)); do d="../$d"; done
  cd "$d" || echo "Couldn't go up $limit dirs."
}

# Double esc to add sudo for previous command
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER != sudo\ * ]]; then
        BUFFER="sudo $BUFFER"
        CURSOR=$(( CURSOR + 5 ))
    fi
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line

# --- PROMPT ---
autoload -Uz vcs_info
setopt PROMPT_SUBST
precmd() { vcs_info } # Run vcs_info before every prompt to get git status

# Git Status
zstyle ':vcs_info:git:*' formats ' %F{yellow}%f%K{yellow}%F{black}%b%f%k%F{yellow}%f'
zstyle ':vcs_info:*' enable git

# Main Prompt 
PROMPT='%F{21}%f%K{21}%F{white} %~ %f%k%F{21}%f${vcs_info_msg_0_}
%(?.%F{cyan}.%F{red})%# ❯%f '
RPROMPT='%F{242} %T%f' # Clock on the right

# --- ALIASES ---
alias df='df -h'
alias free='free -m'
alias ls='ls --color=auto -h --group-directories-first'
alias la='ls -Ah --color=auto --group-directories-first'
alias ll='ls -lh --color=auto --group-directories-first'
alias rr='roll.sh'

# --- FZF INTEGRATION ---
source <(fzf --zsh)
source /home/witekg/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /home/witekg/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
