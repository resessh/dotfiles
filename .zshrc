###
### zplug
###
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "b4b4r07/enhancd", use:enhancd.sh
zplug "olivierverdier/zsh-git-prompt", use:zshrc.sh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose

###
### personal
###
if [ -e ~/.personal.zsh ]; then
    source ~/.personal.zsh
fi
