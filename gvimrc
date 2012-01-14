if has("gui_macvim")
  "-------------------------------------------------------------------------------------
  " Remap Command-T to, um, cmd-t
  " remove MacVim's new tab shortcut
  if has("gui_macvim")
    macmenu &File.New\ Tab key=<nop>
  endif
  " NB - You'll also need to put this in .vimrc
  map <D-t> :CommandT<CR>

  "-------------------------------------------------------------------------------------
  " Start without the toolbar
  set guioptions-=T
endif
