set nocompatible                " choose no compatibility with legacy vi
syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation

"-------------------------------------------------------------------------------------
" Esc is bad and should not be used.
:inoremap jk <esc>
:inoremap <esc> <nop>
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

map! <C-space> <esc>  " Remap escape to shift+space

"-------------------------------------------------------------------------------------
"" Use Pathogen - https://github.com/tpope/vim-pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

"-------------------------------------------------------------------------------------
"" Solarized colourscheme - https://github.com/altercation/vim-colors-solarized
colorscheme solarized
set guifont=Monaco:h12 
set background=light
"set background=dark

"-------------------------------------------------------------------------------------
" highlight the current line
set cursorline
:highlight CursorLine guibg=#eff0fd

"-------------------------------------------------------------------------------------
"  allow buffer swapping when the current buffer is unsaved
set hidden
map ,, <C-^>                    " swap between active/last-active files without stretching

"-------------------------------------------------------------------------------------
" Command-T - https://github.com/wincent/Command-T
" Remap Command-T to, um, cmd-t
map <C-t> :CommandT<CR>
map! <C-t> <esc>:CommandT<CR>

let g:CommandTMaxHeight=20

" Refresh the Command-T tree on file wirte
autocmd BufWritePost * call s:CmdTFlush()

function s:CmdTFlush(...)
  if exists(":CommandTFlush") == 2
    CommandTFlush
  endif
endfunction

"-------------------------------------------------------------------------------------
" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Vagrantfile,Gemfile,Rakefile,Thorfile,config.ru}    set ft=ruby

"-------------------------------------------------------------------------------------
" Turn off the arrow keys in command mode. Yes, it'll hurt. Yes, it'll work. 
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

" Move between buffers with Ctl+h/l 
map <C-l> :bn<CR>
map <C-h> :bp<CR>
map! <C-l> <esc>:bn<CR>
map! <C-h> <esc>:bp<CR>

"-------------------------------------------------------------------------------------
" Tags index file should always live in the project root
" set tags=./tags;

"-------------------------------------------------------------------------------------
" Use ack instead of grep
set grepprg=ack

"-------------------------------------------------------------------------------------
" Make Y, D, etc copy to the system clipboard in MacVim
set clipboard=unnamed

"-------------------------------------------------------------------------------------
" Stop Supertab from trying to traverse included files: it doesn't work
set complete=.,w,b,u,t

