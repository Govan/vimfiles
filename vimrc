set nocompatible                " choose no compatibility with legacy vi
syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation



"-------------------------------------------------------------------------------------
" Layout options
set number
set ruler
set laststatus=2

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
" Tab Completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rb
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
map <D-t> :CommandT<CR>
" NB! You'll also need this in .gvimrc
" if has("gui_macvim")
"  macmenu &File.New\ Tab key=<nop>
" endif

let g:CommandTMaxHeight=20

"-------------------------------------------------------------------------------------
" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru}    set ft=ruby

