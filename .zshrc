# zsh config file dir
export ZDOTDIR=${HOME}

bindkey "^?" backward-delete-char

FORTUNE2CH=0

export LS_PATH='ls'

# 以下、広瀬レコメンドは小文字、そうでないのは大文字にしてある
# setopt auto_cd 			# コマンドが省略されていたら cd とみなす
setopt AUTO_PUSHD		# cd 時にOldDir を自動的にスタックに積む
setopt correct			# コマンドのスペルチェック
setopt auto_name_dirs		# よく判らん
setopt auto_remove_slash	# 補完が/で終って、つぎが、語分割子か/かコマンド
setopt extended_history 	# ヒストリに時刻情報もつける
setopt extended_glob		# グロブで、特殊文字"#,~,^"を使う、
setopt FUNCTION_ARGZERO 	#  $0 にスクリプト名/シェル関数名を格納
setopt hist_ignore_dups		# 前のコマンドと同じならヒストリに入れない
setopt hist_ignore_space	# 空白ではじまるコマンドをヒストリに保持しない
setopt HIST_IGNORE_ALL_DUPS	# 重複するヒストリを持たない
setopt HIST_NO_FUNCTIONS	# 関数定義をヒストリに入れない
setopt HIST_NO_STORE		# history コマンドをヒストリに入れない
setopt HIST_REDUCE_BLANKS	# 履歴から冗長な空白を除く
setopt MULTIOS			# 名前付きパイプ的に入出力を複数開ける
setopt NUMERIC_GLOB_SORT	# グロブの数のマッチを辞書式順じゃなくって数値の順
setopt prompt_subst		# プロンプト文字列で各種展開を行なう
setopt no_promptcr              # 改行コードで終らない出力もちゃんと出力する
setopt pushd_ignore_dups	# ディレクトリスタックに、同じディレクトリを入れない
setopt SHARE_HISTORY		# 複数プロセスで履歴を共有
setopt SHORT_LOOPS		# loop の短縮形を許す
setopt sh_word_split		# よく判らん
setopt RC_EXPAND_PARAM		# {}をbash ライクに展開
setopt TRANSIENT_RPROMPT 	# 右プロンプトに入力がきたら消す

# hisotry
# setopt share_history # 前のほうですでに設定してある。
HISTFILE=$HOME/.zsh-history           # 履歴をファイルに保存する
HISTSIZE=100000                       # メモリ内の履歴の数
SAVEHIST=100000                       # 保存される履歴の数
setopt extended_history               # 履歴ファイルに時刻を記録
function history-all { history -E 1 } # 全履歴の一覧を出力する

# Ctrl-D でログアウトするのを抑制する。
setopt  ignore_eof

# グロブがマッチしないときエラーにしない
# http://d.hatena.ne.jp/amt/20060806/ZshNoGlob
setopt null_glob

# 小文字に対して大文字も補完する
# http://www.ex-machina.jp/zsh/index.cgi?FAQ%40zsh%A5%B9%A5%EC#l1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# urlエンコード
function url-encode { E=${${(j: :)@}//(#b)(?)/%$[[##16]##${match[1]}]} }
function url-decode { D=${1//\%(#b)([0-F][0-F])/\\\x$match[1]} }

# 全プロセスから引数の文字列を含むものを grep する
function psg() {
    ps aux | head -n 1		 # ラベルを表示
    ps aux | 'grep' $* | 'grep' -v "ps -aux" | 'grep' -v 'grep' # grep プロセスを除外
}

# sub shell で sudo
function sudo-command(){
	sudo sh -c "$@"
}

# man を pdf で見る。
function man-pdf(){
	pdfPath=$TMPDIR/man.$1.pdf
	man -t $1 | ps2pdf - $pdfPath
	if [ -f /usr/bin/open ]; then
		/usr/bin/open $pdfPath
	else
		echo "PDF generated: $pdfPath"
	fi
}

# tar.bz2解凍
function untarbz2(){
	bzip2 -dc $1 | tar xvf -
}

# tar.gz解凍
function untargz(){
	tar -zxvf $1
}

# 補完
autoload -Uz compinit
compinit

# ssh with peco
function peco-ssh() {
  local selected_host=$(awk '
  tolower($1)=="host" {
    for (i=2; i<=NF; i++) {
      if ($i !~ "[*?]") {
        print $i
      }
    }
  }
  ' ~/.ssh/config | sort | peco --query "$LBUFFER")
  if [ -n "$selected_host" ]; then
    BUFFER="ssh ${selected_host}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-ssh
stty -ixon
bindkey '^s' peco-ssh

# select history with peco
function peco-select-history() {
  typeset tac
  if which tac > /dev/null; then
    tac="tac"
  else
    tac='tail -r'
  fi
  BUFFER=$(fc -l -n 1 | eval $tac | peco --query "$LBUFFER" --prompt "[zsh history]")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N peco-select-history
stty -ixon
bindkey '^r' peco-select-history

# 外部ファイル読み込み
if [ -e ~/.zshrc_prompt ]; then
    source ~/.zshrc_prompt
fi

if [ -e ~/.zshrc_alias ]; then
    source ~/.zshrc_alias
fi

if [ -e ~/.zshrc_path ]; then
    source ~/.zshrc_path
fi

if [ -e ~/.zshrc_local ]; then
    source ~/.zshrc_local
fi

# PATHの重複削除
typeset -U path PATH
