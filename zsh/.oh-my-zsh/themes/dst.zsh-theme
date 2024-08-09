# Witek3023
# My slightly modified version of prompt from oh-my-zsh themes
ZSH_THEME_GIT_PROMPT_PREFIX=" on  %{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_CLEAN=""

function prompt_char {
	if [ $UID -eq 0 ]; then echo "%{$fg[red]%}#%{$reset_color%}"; else echo $; fi
}

PROMPT='%(?, ,%{$fg[red]%}FAIL%{$reset_color%}
)
%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%} %{$fg_bold[blue]%}%~%{$reset_color%}$(git_prompt_info)
❯'

RPROMPT='%{$fg[green]%}%D{%H:%M} %{$reset_color%}'
