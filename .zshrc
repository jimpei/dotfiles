### path
# export PATH="$PATH:/opt/yarn-[version]/bin:$PATH:$HOME/.nodebrew/current/bin:$HOME/Library/Python/3.7/bin:$PATH:~/.npm-global/bin:$PATH"
export PATH=$PATH:/opt/yarn-[version]/bin
export PATH=$PATH:$HOME/Library/Python/2.7/bin
export PATH=$PATH:~/.npm-global/bin
export PATH=$PATH:/usr/local/var/nodebrew/bin
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# export PATH=$PATH:/Users/jimpei/.npm-global/bin/firebase

### General ###
# export EDITOR=emacs
setopt auto_pushd        # cd時にディレクトリスタックにpushdする
# setopt correct           # コマンドのスペルを訂正する
setopt prompt_subst      # プロンプト定義内で変数置換やコマンド置換を扱う
setopt notify            # バックグラウンドジョブの状態変化を即時報告する
setopt auto_cd           # ディレクトリ名が一致するなら、cdする
setopt nonomatch

### Complement ###
autoload -U compinit; compinit # 補完機能を有効にする
setopt auto_list               # 補完候補を一覧で表示する(d)
setopt auto_menu               # 補完キー連打で補完候補を順に表示する(d)
setopt list_packed             # 補完候補をできるだけ詰めて表示する
setopt list_types              # 補完候補にファイルの種類も表示する
bindkey "^[[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完時に大文字小文字を区別しない
unsetopt correctall # 全コマンドで correct 機能を無効化

### alias ###
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias utf="echo -e '\033]1337;SetProfile=utf-8\aencoding:utf-8'"
alias euc="echo -e '\033]1337;SetProfile=euc\aencoding:euc'"
alias ls="ls -F"
alias la="ls -la"
alias ll="ls -lt" #タイムスタンプ Desc
alias lll="ls -ltr" #タイムスタンプ Asc
alias emasc="emacs"
alias em="emacs"
# alias grep='ionice -c 3 grep'
# alias zgrep='ionice -c 3 zgrep'
# alias egrep='ionice -c 3 egrep'

### prompt
# vcs_infoロード
autoload -Uz vcs_info
# PROMPT変数内で変数参照する
setopt prompt_subst

# vcsの表示
zstyle ':vcs_info:*' formats ':%F{green}%b%f'
zstyle ':vcs_info:*' actionformats ':%F{green}%b%f(%F{red}%a%f)'
# プロンプト表示直前にvcs_info呼び出し
precmd() { vcs_info }
# プロンプト表示
PROMPT='%F{yellow}%M${vcs_info_msg_0_}:%F{magenta}%~%f$ '


### history ###
export HISTCONTROL=ignoredups
export HISTIGNORE='?:??:???:git s:git l:git br:history:'
HISTFILE=~/.zsh_history       # ヒストリを保存するファイル
HISTSIZE=50000               # メモリに保存されるヒストリの件数
SAVEHIST=50000               # 保存されるヒストリの件数
setopt share_history          # 同一ホストで動いているZshで履歴を共有
setopt hist_reduce_blanks     # 余分なスペースを削除してヒストリに保存する
setopt hist_ignore_all_dups  # 重複するコマンド行は古い方を削除
setopt hist_ignore_dups      # 直前と同じコマンドラインはヒストリに追加しない
setopt append_history        # 履歴を追加 (毎回 .zsh_history を作るのではなく)
# setopt inc_append_history    # 履歴をインクリメンタルに追加
setopt hist_no_store         # historyコマンドは履歴に登録しない

# history全部出す
function history-all { history -E 1 }

# 3文字以下のコマンドと指定されたコマンドはヒストリに保存しない
zshaddhistory() {
    local line=${1%%$'\n'}
    local cmd=${line%% *}
    [[ ${#line} -ge 4
      && ${cmd} != (history)
   ]]
}

# cd - と入力してTabキーで今までに移動したディレクトリを一覧表示
setopt auto_pushd
# ディレクトリスタックに重複する物は古い方を削除
setopt pushd_ignore_dups

# マッチしたコマンドのヒストリを表示できるようにする
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end


### display ###
# ターミナルのタイトル
case "${TERM}" in
    xterm|xterm-color|kterm|kterm-color)
precmd() {
    echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
}
;;
esac

export CLICOLOR=true # color

### others ###
setopt no_beep               # ビープ音を消す
setopt rm_star_wait          # rm * を実行する前に確認

