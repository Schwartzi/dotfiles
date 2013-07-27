export LANG=ja_JP.UTF-8

## ---- 補完 ---------------------------

autoload -U compinit
compinit

# コマンド訂正
setopt correct

# 補完候補を詰めて表示する
setopt list_packed

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

## 重複したパスを登録しない。
typeset -U path

## 「/」も単語区切りとみなす。
WORDCHARS=${WORDCHARS:s,/,,}


# --- ヒストリ -------------------------

# 移動したディレクトリを記録しておく。"cd -[Tab]"で移動履歴を一覧
setopt auto_pushd
alias pd='popd'

# ディレクトリ名を入力するだけで移動
setopt auto_cd

# 同じコマンドラインを連続で実行した場合はヒストリに登録しない。
setopt hist_ignore_dups

# ヒストリファイルに保存するとき、すでに重複したコマンドがあったら古い方を削除する
setopt hist_save_nodups

# コピペしやすいようにコマンド実行後は右プロンプトを消す。
setopt transient_rprompt

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt share_history        # share command history data

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# --- その他の設定 ---------------------

# 改行のない出力をプロンプトで上書きするのを防ぐ
unsetopt promptcr

## ビープ音を鳴らさない
setopt nolistbeep

# 日本語ファイル名を表示可能にする
setopt print_eight_bit



# --- 色の設定 -------------------------
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:
                  cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

alias ls="ls -G"
alias gls="gls --color"

zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

# ---- プロンプト ----------------------

setopt prompt_subst

autoload colors
colors

## --- 右プロンプト --------
# VCSの情報を取得するzshの便利関数 vcs_infoを使う
autoload -Uz vcs_info

# 表示フォーマットの指定
# %b ブランチ情報
# %a アクション名(mergeなど)
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'

## --- ミスプロンプト --------
SPROMPT="%{[31m%}%r is correct? [n,y,a,e]:%{[m%} "

## --- 左プロンプト --------
local pbLeft="%n@%m %F{blue}[%~]%f"
local pbRight="%F{cyan}%D %T%f"

local pMark="%B%(?,%F{green},%F{red})%(!,#,>)%f%b"


## プロンプトフォーマットを展開した後の文字数を返す
countPChars(){
    print -n -P -- "$1" | sed -e $'s/\e\[[0-9;]*m//g' | wc -m | sed -e 's/ //g'
}

update_prompt() {

    local bRestLength=$[COLUMNS - 14]

    local bLeftWithoutPath="${pbLeft:s/%~//}"
    local bLeftWithoutPathLength=$(countPChars "$bLeftWithoutPath")

    local maxPathLength=$[bRestLength - bLeftWithoutPathLength]
    bLeft=${pbLeft:s/%~/%(C,%${maxPathLength}<...<%~%<<,)/}

    local bLeftLength=$(countPChars "$bLeft")
    bRestLength=$[bRestLength - bLeftLength]
    local separator="${(l:${bRestLength}:: :)}"
    bLeft="${bLeft}${separator}"

    PROMPT="${bLeft}${pbRight}"$'\n'" $pMark "

    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
    # バージョン管理されているディレクトリにいれば表示，そうでなければ非表示
    RPROMPT="%1(v|%F{green}%1v%f|)"

}

## コマンド実行前に呼び出されるフック。
precmd_functions=($precmd_functions update_prompt)


# ---- エイリアス ----------------------

alias emacs="open -a emacs"
alias la='ls -a'
alias ll='ls -lh'
alias lla='ls -alh'
alias j='jobs'
alias rm='rm -i'
alias mkdir='mkdir -p'

alias -s pdf='open -a Preview'
alias -s txt='cat'

# -------------------------------------------------------------

# ruby on rails
eval "$(rbenv init -)"

#smlのパスを通す
export PATH=/usr/local/smlnj-110.75/bin/:$PATH
