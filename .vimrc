" color
colorscheme molokai

" set
set encoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set fileformats=unix,dos,mac
set hlsearch "検索結果ハイライト
"set number
set list
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%
set statusline=%F " ファイル名表示
set statusline+=%m " 変更チェック表示
set statusline+=%r " 読み込み専用かどうか表示
set statusline+=%h " ヘルプページなら[HELP]と表示
set statusline+=%w " プレビューウインドウなら[Prevew]と表示
set statusline+=%= " これ以降は右寄せ表示
set statusline+=[ENC=%{&fileencoding}] " file encoding
set statusline+=[LOW=%l/%L] " 現在行数/全行数
set laststatus=2 " ステータスラインを常に表示(0:表示しない、1:2つ以上ウィンドウがある時だけ表示)

" for mac
set term=xterm-256color
syntax on

" remap
noremap <C-p> <Up>
noremap <C-n> <Down>
noremap <C-b> <Left>
noremap <C-f> <Right>
noremap <C-a> <HOME>
noremap <C-e> <END>
noremap <C-d> <Del>
noremap <C-h> <BS>
noremap <C-k> <Esc>D
noremap <C-u> <Esc>dd

noremap! <C-p> <Up>
noremap! <C-n> <Down>
noremap! <C-b> <Left>
noremap! <C-f> <Right>
noremap! <C-a> <HOME>
noremap! <C-e> <END>
noremap! <C-d> <Del>
noremap! <C-h> <BS>
noremap! <C-k> <Esc>D
noremap! <C-u> <Esc>dd
