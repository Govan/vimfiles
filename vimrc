" vim: foldmethod=marker

" Unsorted {{{
set nocompatible                " choose no compatibility with legacy vi
syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation

set backupdir=~/.vimswap
set directory=~/.vimswap
set nobackup
set noswapfile
set winheight=11
" }}}
" Use Pathogen to manage plugins {{{
" https://github.com/tpope/vim-pathogen 
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
" }}}
" iTerm Color fix {{{
"-------------------------------------------------------------------------------------
" I'm not quite sure what this does, but it fixes a colour issue with vim
" running in iTerm
" set t_Co=256
" Update - Turns out I don't need this provided 
" a) .tmux.conf declares screen-256colors
" b) iTerm declares as xTerm-256colors
" With this is place colours work both in and out of tmux 
"-------------------------------------------------------------------------------------
" }}}
" Tmux {{{
" Arrow keys tend to play silly buggers when running inside tmux
" http://superuser.com/questions/215180/when-running-screen-on-osx-commandr-messes-up-arrow-keys-in-vim-across-all-scr
map <Esc>[A <Up>
map <Esc>[B <Down>
map <Esc>[C <Right>
map <Esc>[D <Left>
" ----------------------------------------------------------------------
" Remap tmux-vim-navigator to use <m-direction> rather than <c-direction>
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <M-H> :TmuxNavigateLeft<cr>
nnoremap <silent> <M-J> :TmuxNavigateDown<cr>
nnoremap <silent> <M-K> :TmuxNavigateUp<cr>
nnoremap <silent> <M-L> :TmuxNavigateRight<cr>

inoremap <silent> <M-H> <Esc>:TmuxNavigateLeft<cr>
inoremap <silent> <M-J> <Esc>:TmuxNavigateDown<cr>
inoremap <silent> <M-K> <Esc>:TmuxNavigateUp<cr>
inoremap <silent> <M-L> <Esc>:TmuxNavigateRight<cr>
" }}}
" 'Window' Options {{{
set number
set ruler
set laststatus=2
set scrolloff=10
" -------------------------------------------------------------------
" Use block cursor in normal mode and a vertical line in insert mode
" taken from https://gist.github.com/1195581 
" tmux will only forward escape sequences to the terminal if surrounded by a DCS sequence
" http://sourceforge.net/mailarchive/forum.php?thread_name=AANLkTinkbdoZ8eNR1X2UobLTeww1jFrvfJxTMfKSq-L%2B%40mail.gmail.com&forum_name=tmux-users
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
" }}}
" Enable Mouse Control {{{
set mouse=a
" }}}
" Disable bell {{{
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif
" }}}
" fix meta-keys which generate <Esc>a .. <Esc>z {{{
" http://stackoverflow.com/questions/6778961/alt-key-shortcuts-not-working-on-gnome-terminal-with-vim
" There are two ways for a terminal emulator to send an Alt key (usually
" called a Meta key as actual terminals didn't have Alt). It can either send 8
" bit characters and set the high bit when Alt is used, or it can use escape
" sequences, sending Alt-a as <Esc>a. Vim expects to see the 8 bit encoding
" rather than the escape sequence.
"
" Some terminal emulators such as xterm can be set to use either mode, but
" Gnome terminal doesn't offer any such setting. To be honest in these days of
" Unicode editing, the 8-bit encoding is not such a good idea anyway. But
" escape sequences are not problem free either; they offer no way of
" distinguishing between <Esc>j meaning Alt-j vs pressing Esc followed by j.
"
" In earlier terminal use, typing Escj was another way to send a Meta on a
" keyboard without a Meta key, but this doesn't fit well with vi's use of Esc
" to leave insert mode.

let c='a'
while c <= 'z'
  exec "set <M-".toupper(c).">=\e".c
  exec "imap \e".c." <M-".toupper(c).">"
  let c = nr2char(1+char2nr(c))
endw
set timeout ttimeoutlen=1
" }}}
" <c-x>, <c-a> increment as padded decimals rather than octals {{{
set nrformats=
" }}}

" Whitespace {{{
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode
" }}}
" Turn off the current line highlight {{{
" it makes syntax enabled file very,
" very laggy when moving, or at least it does when used in combination with
" the rest of my setup. Possibly something to do with string highlighting?
set nocursorline
" }}}
" Disable automatic line folding {{{
set nofoldenable
" }}}
" Spellchecking {{{
" A note here, because you'll forget 
" z= brings up the correction page
" <number>z= to insert the word at than index from the list and jump back to
" the buffer
set spelllang=en_gb
nnoremap <leader>s ]s 
nnoremap <leader>n [s
" }}}
" Remember last location in file {{{
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif
" }}}

"" Searching {{{
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter
set nohlsearch                  " don't highlight on search
" }}}
" Treat ' as a word separator {{{
set iskeyword+=^.
" }}}
" Project Search {{{
" If we have it use Silver Searcher or use ack instead
set grepprg=ack
if executable("ag")
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s --ignore "*.jpg" --ignore "*.png" --ignore "*.gif" -l --nocolor --hidden -g ""'
  let g:ackprg = 'ag --nogroup --nocolor --column'
endif

" }}}
" Fuzzy File Finder {{{
" Use CtrlP for project navigation
noremap <C-t> :CtrlP<CR>
noremap! <C-t> <esc>:CtrlP<CR>

set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git
set wildignore+=*.png,*.jpg,*.jpeg,*.gif
set wildignore+=*.rsync_cache
" }}}
" Solarized colourscheme {{{
" https://github.com/altercation/vim-colors-solarizedHH˙˙˙
colorscheme solarized
set guifont=Monaco:h12
if has('gui_running')
  " Do nothing
endif
set background=light
" }}}
" Use S in normal/visual mode as a shortcut to filewide search {{{
nnoremap S :%s//g<LEFT><LEFT> 
vnoremap S :s//g<LEFT><LEFT>
" }}}
" Browser search for what's under the cursor {{{
" https://github.com/vim-scripts/open-browser.vim
let g:netrw_nogx = 1 
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
" }}}

" Buffer/Tab Management {{{
"  allow buffer swapping when the current buffer is unsaved
set hidden
" swap between active/last-active files without stretching
map ,, <C-^>         

" Move between buffers with alt+h/l 
noremap <M-R> :bn<CR>
noremap <M-C> :bp<CR>
noremap! <M-R> <esc>:bn<CR>
noremap! <M-C> <esc>:bp<CR>
"
" Previous/Next Tab Navigation
noremap tt<CR> :tabe .<CR>
noremap th :tabp<CR>
noremap tn :tabn<CR>
" }}}
" Persistant undos {{{
" Taken from Instantly Better Vim by http://damian.conway.org/
" Warn when stepping from current session's undos into those from the previous session
" Remap the undo key to warn about stepping back into a buffer's pre-history... 
set undofile                " Save undo's after file closes
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo

nnoremap <expr> u VerifyUndo()
" Track each buffer's starting position in undo history...
augroup UndoWarnings 
  autocmd!
  autocmd BufReadPost,BufNewFile *
        \ :call Rememberundo_start() 
augroup END

function! Rememberundo_start ()
  let b:undo_start = exists('b:undo_start')
        \ ? b:undo_start
        \ : undotree().seq_cur
endfunction
function! VerifyUndo ()
  " Are we back at the start of this session " (but still with undos possible)???
  let undo_now = undotree().seq_cur
  if undo_now > 0 && undo_now == b:undo_start
    " If so, ask whether to undo into pre-history...
    return confirm('', "Undo into previous session? (&Yes\n&No)",1) == 1  ? "\<C-L>u" : "\<C-L>"
  endif
  " Otherwise, just undo...
  return 'u' 
endfunction
" }}}
" Open help in a new tab {{{
augroup HelpInTabs 
  autocmd!
  autocmd BufEnter *.txt call HelpInNewTab() 
augroup END

function! HelpInNewTab () 
  if &buftype == 'help'
  execute "normal \<C-W>T"
endif 
endfunction
" }}}
" Stop Supertab from trying to traverse included files {{{
" The include behaviour wasn't working at all.
set complete=.,w,b,u,t
" }}}
" Highlight the 81st character, rather than forcibly impose a wrap {{{
" Stolen from Instantly More Better vim
" http://programming.oreilly.com/2013/10/more-instantly-better-vim.html
highlight ColorColumn ctermbg=red
call matchadd('ColorColumn', '\%81v', 100)
" }}}
" Expand %% to the directory of the currently open buffer {{{
cnoremap %% <C-R>=expand('%:h').'/'<cr>
" }}}
" Switch <file> and <file>_spec {{{
" https://github.com/garybernhardt/dotfiles/blob/master/.vimrc
"-------------------------------------------------------------------------------------
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    if in_app
      let new_file = 'app/' . new_file
    end
  endif
  return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>
" }}}
" rename current file {{{
" https://github.com/garybernhardt/dotfiles/blob/master/.vimrc
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>mv :call RenameFile()<cr>
" }}}
" Wrap markdown files {{{
au BufRead,BufNewFile *.md setlocal textwidth=80
" }}}
" Format Thorfile, Rakefile and Gemfile as Ruby {{{
au BufRead,BufNewFile {Berksfile,Guardfile,Vagrantfile,Gemfile,Rakefile,Thorfile,config.ru}    set ft=ruby
" }}}
" Make . run on every selected line in visual mode {{{
:vnoremap . :norm.<CR>
" }}}
" Map quit to :Q {{{
" It's not used, it's a common typo, so let's fix it
command! Q q " Bind :Q to :q
" }}}
" Remap jk to Escape {{{
imap jk <Esc>
" }}}
" Remap save to a friendlier keystroke {{{
" Note that remapping C-s requires flow control to be disabled
" (e.g. in .bashrc or .zshrc) with
" stty start undef
" stty stop undef
map <C-s> <esc>:w<CR>
imap <C-s> <esc>:w<CR>
" }}}
" map ; to : in normal mode, save yourself from hitting shift {{{
" Stolen from More Instantly Better Vim
" http://programming.oreilly.com/2013/10/more-instantly-better-vim.html
" swap : and ; around to save constant <shifting>
" actually, don't remap : to ; - it screws with a lot of other people's remaps
nnoremap ; :
" }}}

" Load in host-dependant settings 
so ~/.vimrc_local
