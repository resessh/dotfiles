###
### zplug
###
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "changyuheng/zsh-interactive-cd", use:zsh-interactive-cd.plugin.zsh
zplug "resessh/git-prompt"
zplug "tsub/4448666a276b088bce3f19005f512c15", from:gist, use:ghq-fzf.zsh

# Install plugins if there are plugins that have not been installed
if ! zplug check; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

###
### personal
###
if [ -e ~/.personal.zsh ]; then
    source ~/.personal.zsh
fi
