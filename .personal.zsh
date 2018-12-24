###
### global
###
setopt AUTO_PUSHD           # cd 時にOldDir を自動的にスタックに積む
setopt pushd_ignore_dups    # ディレクトリスタックに、同じディレクトリを入れない
setopt auto_remove_slash    # 補完が/で終って、つぎが、語分割子か/かコマンド
setopt extended_glob        # グロブで、特殊文字"#,~,^"を使う、
setopt FUNCTION_ARGZERO     #  $0 にスクリプト名/シェル関数名を格納
setopt MULTIOS              # 名前付きパイプ的に入出力を複数開ける
setopt NUMERIC_GLOB_SORT    # グロブの数のマッチを辞書式順じゃなくって数値の順
setopt prompt_subst         # プロンプト文字列で各種展開を行なう
setopt no_promptcr          # 改行コードで終らない出力もちゃんと出力する
setopt SHARE_HISTORY        # 複数プロセスで履歴を共有
setopt TRANSIENT_RPROMPT    # 右プロンプトに入力がきたら消す
setopt RC_EXPAND_PARAM		# {}をbash ライクに展開
setopt ignore_eof           # Ctrl-D でログアウトするのを抑制する。

# 小文字に対して大文字も補完する
# http://www.ex-machina.jp/zsh/index.cgi?FAQ%40zsh%A5%B9%A5%EC#l1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

###
### history
###
HISTFILE=$HOME/.zsh-history # 履歴をファイルに保存する
HISTSIZE=100000             # メモリ内の履歴の数
SAVEHIST=100000             # 保存される履歴の数
setopt extended_history     # 履歴ファイルに時刻を記録
setopt hist_ignore_space    # 空白ではじまるコマンドをヒストリに保持しない
setopt HIST_IGNORE_ALL_DUPS # 重複するヒストリを持たない
setopt HIST_REDUCE_BLANKS   # 履歴から冗長な空白を除く

###
### ls
###
export LS_PATH='gls'
export LS_OPTIONS='-v --color=auto'
alias ls="$LS_PATH -h $LS_OPTIONS"
alias l="$LS_PATH -h $LS_OPTIONS"
alias la="$LS_PATH -ha $LS_OPTIONS"
alias ll="$LS_PATH -lAFtr $LS_OPTIONS"
alias lsH="$LS_PATH -l $LS_OPTIONS"
alias lsHa="$LS_PATH -la $LS_OPTIONS"
alias lsg="$LS_PATH -lh $LS_OPTIONS . | grep"
if [ -e ~/.dotfiles/dircolors.monokai ]; then
    eval $(gdircolors ~/.dotfiles/dircolors.monokai)
fi
if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

###
### alias
###
alias rm='rm -i'
alias reload="exec $SHELL"
alias drma="docker ps --filter \"status=exited\" -q | xargs docker rm -v"
###
### prompt
###
TERM=xterm-256color
FSGREEN='%F{048}'
FSRED='%F{197}'

# git information
ZSH_THEME_GIT_PROMPT_PREFIX="${FSGREEN}|%f "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_SEPARATOR=" "
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[red]%}%{●%G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{✖%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[blue]%}%{✚%G%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{↓%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{↑%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{…%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}%{✔%G%}"

PROMPT='%F{238}%D %*%f ${FSGREEN}|%f %F{243}%~%f $(git_status)
%(?.${FSGREEN}.${FSRED}) ❯ %f'

###
### fzf
###
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'

function select-history() {
  BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
}
zle -N select-history
bindkey '^r' select-history

# fkill - kill process
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
fbr() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

###
### env
###
# eval "$(rbenv init -)"
# export PATH="$HOME/.rbenv/bin:$PATH"
# eval "$(pyenv init -)"
# export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(nodenv init -)"
export PATH="$HOME/.nodenv/bin:$PATH"

# PATHの重複削除
typeset -U path PATH
