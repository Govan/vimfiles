set nocompatible                " choose no compatibility with legacy vi
syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation

"-------------------------------------------------------------------------------------
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
"-------------------------------------------------------------------------------------
" I'm not quite sure what this does, but it fixes a colour issue with vim
" running in iTerm
" set t_Co=256
" Update - Turns out I don't need this provided 
" a) .tmux.conf declares screen-256colors
" b) iTerm declares as xTerm-256colors
" With this is place colours work both in and out of tmux 
"-------------------------------------------------------------------------------------
" Layout options
set number
set ruler
set laststatus=2

"-------------------------------------------------------------------------------------
" Treat ' as a word separator, for example when navigating with w and b
set iskeyword+=^.
"-------------------------------------------------------------------------------------
" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif
"-------------------------------------------------------------------------------------
" Enable Mouse Control
set mouse=a
"-------------------------------------------------------------------------------------
"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode

"-------------------------------------------------------------------------------------
"" Searching
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter
set nohlsearch                  " don't highlight on search

"-------------------------------------------------------------------------------------
" Command T Completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git
set wildignore+=*.png,*.jpg,*.jpeg,*.gif
set wildignore+=*.rsync_cache

"-------------------------------------------------------------------------------------
"" Misc
set backupdir=~/.vimswap
set directory=~/.vimswap
set nobackup
set noswapfile
set winheight=11

"-------------------------------------------------------------------------------------
"" Use Pathogen - https://github.com/tpope/vim-pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

"-------------------------------------------------------------------------------------
"" Solarized colourscheme - https://github.com/altercation/vim-colors-solarizedHH˙˙˙
colorscheme solarized
set guifont=Monaco:h12
if has('gui_running')
  " Do nothing
endif

set background=light
"-------------------------------------------------------------------------------------
" highlight the current line
set cursorline
"-------------------------------------------------------------------------------------
" BUFFER HANDLING
"  allow buffer swapping when the current buffer is unsaved
set hidden
" swap between active/last-active files without stretching
map ,, <C-^>         

" Move between buffers with alt+h/l 
noremap <M-R> :bn<CR>
noremap <M-C> :bp<CR>
noremap! <M-R> <esc>:bn<CR>
noremap! <M-C> <esc>:bp<CR>

"-------------------------------------------------------------------------------------
" Use CtrlP for project navigation
noremap <C-t> :CtrlP<CR>
noremap! <C-t> <esc>:CtrlP<CR>
"-------------------------------------------------------------------------------------
" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Berksfile,Guardfile,Vagrantfile,Gemfile,Rakefile,Thorfile,config.ru}    set ft=ruby
""-------------------------------------------------------------------------------------
"
"-------------------------------------------------------------------------------------
" Tags index file should always live in the project root
" set tags=./tags;

"-------------------------------------------------------------------------------------
" <c-x>, <c-a> increment as padded decimals rather than octals
set nrformats=
"-------------------------------------------------------------------------------------
" Use ack instead of grep
set grepprg=ack

" Or, if we have it, use Silver Searcher - it's stupid-fast
if executable("ag")
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s --ignore "*.jpg" --ignore "*.png" --ignore "*.gif" -l --nocolor --hidden -g ""'
  let g:ackprg = 'ag --nogroup --nocolor --column'
endif

"-------------------------------------------------------------------------------------
" Make Y, D, etc copy to the system clipboard in MacVim
" We don't like tihs behaviour because it plays silly buggers with my
" Clipboard manager
" set clipboard=unnamed

"-------------------------------------------------------------------------------------
" Stop Supertab from trying to traverse included files: it doesn't work
set complete=.,w,b,u,t

"-------------------------------------------------------------------------------------
" Arrow keys tend to play silly buggers when running inside tmux
" This seems to fix it
" http://superuser.com/questions/215180/when-running-screen-on-osx-commandr-messes-up-arrow-keys-in-vim-across-all-scr
map <Esc>[A <Up>
map <Esc>[B <Down>
map <Esc>[C <Right>
map <Esc>[D <Left>

"-------------------------------------------------------------------------------------
" fix meta-keys which generate <Esc>a .. <Esc>z
" http://stackoverflow.com/questions/6778961/alt-key-shortcuts-not-working-on-gnome-terminal-with-vim
let c='a'
while c <= 'z'
  exec "set <M-".toupper(c).">=\e".c
  exec "imap \e".c." <M-".toupper(c).">"
  let c = nr2char(1+char2nr(c))
endw
set timeout ttimeoutlen=1

"-------------------------------------------------------------------------------------
" Map save to a friendlier keystroke
nnoremap <M-W> <esc>:w<CR>
inoremap <M-W> <esc>:w<CR>a

"-------------------------------------------------------------------------------------
command! Q q " Bind :Q to :q
" Disable Ex mode
map Q <Nop>
"-------------------------------------------------------------------------------------
" Kill the bell
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

"-------------------------------------------------------------------------------------
" Spellchecking
" A note here, because you'll forget 
" z= brings up the correction page
" <number>z= to insert the word at than index from the list and jump back to
" the buffer
set spelllang=en_gb
nnoremap <leader>s ]s 
nnoremap <leader>n [s

"-------------------------------------------------------------------------------------
" Config for vim-powerbar
" let g:Powerline_symbols = 'fancy'
"-------------------------------------------------------------------------------------
" Expand %% to the directory of the currently open buffer
cnoremap %% <C-R>=expand('%:h').'/'<cr>

"-------------------------------------------------------------------------------------
" SWITCH BETWEEN TEST AND PRODUCTION CODE
" Taken from...
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au BufRead,BufNewFile *.md setlocal textwidth=80
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setup for open-browser - https://github.com/vim-scripts/open-browser.vim
let g:netrw_nogx = 1 
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
" Taken from...
" https://github.com/garybernhardt/dotfiles/blob/master/.vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
"-------------------------------------------------------------------------------------
" Make . run on every selected line
:vnoremap . :norm.<CR>

"-------------------------------------------------------------------------------------
" Stolen from [More Instantly Better
" Vim](http://programming.oreilly.com/2013/10/more-instantly-better-vim.html)
" swap : and ; around to save constant <shifting>
nnoremap ; :
nnoremap : ;

"-------------------------------------------------------------------------------------
" Disable automatic line folding
set nofoldenable

"-------------------------------------------------------------------------------------
" Set up powerline's prompt - won't have any affect if Powerline's not absent
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim

"-------------------------------------------------------------------------------------
" Don't let Nerdtree replace netrw when opening vim on a dir
let g:NERDTreeHijackNetrw=0

"-------------------------------------------------------------------------------------
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

"-------------------------------------------------------------------------------------
" Load in host-dependant settings 
so ~/.vimrc_local

