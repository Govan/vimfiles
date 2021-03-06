" vim: foldmethod=marker
"
let mapleader=" "

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

set timeout ttimeoutlen=1

" stop vim crapping out a netrwhist file, maybe?
let g:netrw_dirhistmax=0
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

let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-t> :TmuxNavigateDown<cr>
nnoremap <silent> <C-n> :TmuxNavigateUp<cr>
nnoremap <silent> <C-s> :TmuxNavigateRight<cr>

inoremap <silent> <C-h> <Esc>:TmuxNavigateLeft<cr>
inoremap <silent> <C-t> <Esc>:TmuxNavigateDown<cr>
inoremap <silent> <C-n> <Esc>:TmuxNavigateUp<cr>
inoremap <silent> <C-s> <Esc>:TmuxNavigateRight<cr>

" ----------------------------------------------------------------------
" }}}


" Show Invisibles {{{
" Highlight tabs and end of line characters
set list
set listchars=tab:▸\ ,eol:¬

hi NonText        ctermfg=red    ctermbg=white    cterm=NONE
hi SpecialKey     ctermfg=red       ctermbg=white    cterm=NONE
" ----------------------------------------------------------------------
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
" Enable draggable panels for resizing
" set ttyfast
" set ttymouse=xterm2
" set mouse=a
" }}}

" Disable bell {{{
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif
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
set cursorline
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
nnoremap <leader>S ]s
nnoremap <leader>N [s
" }}}

" Remember last location in file {{{
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif
" }}}

" Searching {{{
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter
set nohlsearch                  " don't highlight on search
" }}}

" Treat ' as a word separator {{{
set iskeyword+=^.
" }}}


" Fuzzy File Finder {{{
" Use CtrlP for project navigation
" Turning fuzzy finder off while I sort out tmux/vim split navigation
noremap <C-@> :CtrlP<CR>
noremap! <C-@> <esc>:CtrlP<CR>

noremap <C-y> :CtrlPBuffer<CR>
noremap! <C-y> <esc>:CtrlPBuffer<CR>

" We're not using this custom command - just assume that ag is accessible
" further down. I can't nicely exclude images with this form
"let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f', 'tags']
"let g:ctrlp_use_caching = 0

" Note that, because I'm using a ctrlp_user_command, the list below doesn't
" have any effect.
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git
set wildignore+=*.png,*.jpg,*.jpeg,*.gif
set wildignore+=*.rsync_cache
" }}}
"
" Project Search {{{
" If we have it use Silver Searcher or use ack instead
set grepprg=ack
if executable("ag")
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -i --nocolor --hidden
        \ --ignore .git
        \ --ignore .svn
        \ --ignore "*.png"
        \ --ignore "*.jpg"
        \ --ignore "*.gif"
        \ --ignore .hg
        \ --ignore .DS_Store
        \ --ignore "**/*.pyc"
        \ --ignore "*.beam"
        \ --ignore "deps/*"
        \ --ignore "node_modules/*"
        \ --ignore "_build/*"
        \ -g ""'
  let g:ackprg = 'ag --nogroup --nocolor --column'
endif
" }}}

" Molokai colourscheme {{{
" https://github.com/altercation/vim-colors-solarized
colorscheme molokai
" }}}

" Airline {{{
" https://github.com/bling/vim-airline
" You'll also want the powerline patched font
" https://github.com/powerline/fonts/blob/master/Inconsolata/Inconsolata%20for%20Powerline.otf
"-------------------------------------------------------------------------------------
let g:airline_theme='molokai'
let g:airline_powerline_fonts = 1
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
noremap <leader>, <C-^>

" Move between buffers
noremap <leader>h :bn<CR>
noremap <leader>s :bp<CR>

" Close the current buffer and move to the next one, removing the original
" from the bufferlist
" evernote:///view/46596/s1/8c9ce88a-7b93-4b3b-be11-1ab26461377a/8c9ce88a-7b93-4b3b-be11-1ab26461377a/
nmap <leader>q :b#<bar>bd#<CR>

"
" Previous/Next Tab Navigation
" Turning tab navigation off until I sort out the Dvorak homerow
"noremap <leader>t :tabe .<CR>
"noremap <leader>h :tabp<CR>
"noremap <leader>s :tabn<CR>
" }}}

" Persistant undos {{{
" Taken from Instantly Better Vim by http://damian.conway.org/
" Warn when stepping from current session's undos into those from the previous session
" Remap the undo key to warn about stepping back into a buffer's pre-history...
set undofile                " Save undo's after file closes
set undodir=$HOME/.vim_local/undo " where to save undo histories
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
  " And does the buffer have a name?
  let named_file = expand('%:p')
  if (!empty(named_file)) && undo_now > 0 && undo_now == b:undo_start
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

" Remap save to a friendlier keystroke c-w {{{
map <C-w> <esc>:w<CR>
imap <C-w> <esc>:w<CR>a
" }}}

" map ; to : in normal mode, save yourself from hitting shift {{{
" Stolen from More Instantly Better Vim
" http://programming.oreilly.com/2013/10/more-instantly-better-vim.html
" swap : and ; around to save constant <shifting>
" actually, don't remap : to ; - it screws with a lot of other people's remaps
" 11/07/2016 - turning this off for now so I can use it for inline searching
" nnoremap ; :
" }}}

" Give myself a HardTime{{{
" https://github.com/takac/vim-hardtime
let g:hardtime_default_on = 0
let g:list_of_normal_keys = ["h", "t", "n", "s", "-", "+", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:list_of_visual_keys = ["h", "t", "n", "s", "-", "+", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:list_of_insert_keys = ["<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:list_of_disabled_keys = []
" }}}

" Remap the Dvorak RHS home row to behave as directions{{{
nnoremap l s
nnoremap L S
nnoremap s l
noremap S L
vnoremap l s
vnoremap L S
vnoremap s l
vnoremap S L

nnoremap t j
nnoremap T J
nnoremap j t
nnoremap J T
vnoremap t j
vnoremap T J
vnoremap j t
vnoremap J T

nnoremap n k
nnoremap N K
nnoremap k n
nnoremap K N

vnoremap n k
vnoremap N K
vnoremap k n
vnoremap K N
" }}}

" Fix Dvorak up/down to play nicely with netrw {{{
" netrw overloads 't' with open-in-new-tab
" http://unix.stackexchange.com/questions/31575/remapping-keys-in-vims-directory-view
" The solution is a buffer-only remap. Will probably add to this over time
augroup netrw_dvorak_fix
    autocmd!
    autocmd filetype netrw call Fix_netrw_maps_for_dvorak()
augroup END
function! Fix_netrw_maps_for_dvorak()
    noremap <buffer> t j
endfunction
" }}}

" RSpec.vim mappings to send tests to tmux {{{
" Use https://github.com/jgdavey/tslime.vim/blob/master/plugin/tslime.vim
" which lets us default to current window
let g:tslime_always_current_session = 1
let g:tslime_always_current_window = 1
 map <Leader>o :w<CR>:call RunLastSpec()<CR>
 map <Leader>a :w<CR>:call RunNearestSpec()<CR>
 map <Leader>A :w<CR>:call RunCurrentSpecFile()<CR>
 map <Leader>O :w<CR>:call RunAllSpecs()<CR>
 let g:rspec_command = 'call Send_to_Tmux("bundle exec rspec {spec}\n")'
" }}}

" Trim trailing whitespace on save. {{{
" Stolen from
" http://stackoverflow.com/questions/356126/how-can-you-automatically-remove-trailing-whitespace-in-vim
fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun

" This is rather aggressive - it'll strip all trailing whitespace on all
" files. That might bo overkill, but sod it.
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
" }}}


" Force myself to use the iOS compatible esc{{{
" inoremap <esc> <NOP>
inoremap jk <esc>
" }}}


" Load in host-dependant settings
so ~/.vimrc_local


