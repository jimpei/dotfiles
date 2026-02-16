# ================================================================
#  .zshrc
# ================================================================
# 構成:
#   PATH・環境変数    — PATH, export を全て集約
#   シェルオプション  — setopt/unsetopt を1箇所に
#   補完             — compinit, zstyle, fzf-tab
#   エイリアス       — alias 全部
#   キーバインド     — bindkey 全部
#   プロンプト       — vcs_info, PROMPT
#   ヒストリ         — HIST変数, setopt, 関数
#   関数             — 自作関数
# ================================================================

# ----------------------------------------------------------------
# PATH・環境変数
# ----------------------------------------------------------------

# 基本 PATH
export PATH=/usr/local/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"

# Node.js (nodebrew)
export PATH=$PATH:/usr/local/var/nodebrew/bin
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH=$PATH:/opt/yarn-[version]/bin
export PATH=$PATH:~/.npm-global/bin

# 環境変数
# export EDITOR=emacs
export CLICOLOR=true

# ----------------------------------------------------------------
# シェルオプション
# ----------------------------------------------------------------

setopt prompt_subst      # プロンプト定義内で変数置換やコマンド置換を扱う
setopt notify            # バックグラウンドジョブの状態変化を即時報告する
setopt auto_cd           # ディレクトリ名が一致するなら、cdする
setopt nonomatch
setopt auto_pushd        # cd時にディレクトリスタックにpushdする
setopt pushd_ignore_dups # ディレクトリスタックに重複する物は古い方を削除
setopt no_beep           # ビープ音を消す
setopt rm_star_wait      # rm * を実行する前に確認
unsetopt correctall      # 全コマンドで correct 機能を無効化

# ----------------------------------------------------------------
# 補完
# ----------------------------------------------------------------

# compinit: キャッシュが1日以内なら再生成しない（高速化）
autoload -U compinit
if [[ -f ~/.zcompdump && $(date +'%j') == $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]]; then
    compinit -C
else
    compinit
fi

setopt auto_list            # 補完候補を一覧で表示する(d)
setopt auto_menu            # 補完キー連打で補完候補を順に表示する(d)
setopt list_packed          # 補完候補をできるだけ詰めて表示する
setopt list_types           # 補完候補にファイルの種類も表示する
setopt always_to_end        # 補完後カーソルを末尾に移動
setopt complete_in_word     # カーソル位置で補完する

# --- zstyle ---
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z_-}={A-Za-z-_}' \
    'r:|=*' \
    'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'
zstyle ':completion:*:messages' format '%F{cyan}-- %d --%f'
zstyle ':completion:*' verbose yes
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# --- fzf-tab（compinitの後にロードする必要あり） ---
source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
zstyle ':fzf-tab:*' fzf-bindings 'tab:accept' 'ctrl-k:kill-line'

# ----------------------------------------------------------------
# エイリアス
# ----------------------------------------------------------------

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
alias py="python"
alias flutter="fvm flutter"
# alias grep='ionice -c 3 grep'
# alias zgrep='ionice -c 3 zgrep'
# alias egrep='ionice -c 3 egrep'

# ----------------------------------------------------------------
# キーバインド
# ----------------------------------------------------------------

bindkey "^[[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する

# マッチしたコマンドのヒストリを表示できるようにする
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# ----------------------------------------------------------------
# プロンプト
# ----------------------------------------------------------------

autoload -Uz vcs_info
zstyle ':vcs_info:*' formats ':%F{green}%b%f'
zstyle ':vcs_info:*' actionformats ':%F{green}%b%f(%F{red}%a%f)'
precmd() { vcs_info }
PROMPT='%F{yellow}%M${vcs_info_msg_0_}:%F{magenta}%~%f$ '

# ターミナルのタイトル
case "${TERM}" in
    xterm|xterm-color|kterm|kterm-color)
precmd() {
    echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
}
;;
esac

# ----------------------------------------------------------------
# ヒストリ
# ----------------------------------------------------------------

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

# 3文字以下のコマンドと指定されたコマンドはヒストリに保存しない
zshaddhistory() {
    local line=${1%%$'\n'}
    local cmd=${line%% *}
    [[ ${#line} -ge 4
      && ${cmd} != (history)
      && ${line} != (git s|git l|git br)
   ]]
}

# ----------------------------------------------------------------
# 関数
# ----------------------------------------------------------------

# history全部出す
function history-all { history -E 1 }
