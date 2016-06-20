#def replace_file(file)
#  system %Q{rm -rf "$HOME/.#{file.sub('.erb', '')}"}
#  link_file(file)
#end
#
#
#def setup_submodules
#  system "git submodule init"
#  system "git submodule update"
#end
#
#def touch_vimrc_local
#  target = File.expand_path("~/.vimrc_local")
#  unless File.exists? target
#    File.open(target, 'w') do |new_file|
#      new_file << "\" Put private customizations in here\n"
#      new_file << "\" and/or link to one of the per-machine shared configs\n"
#    end
#  end
#end
#
#
#def link_file(file)
#  if file =~ /.erb$/
#    puts "generating ~/.#{file.sub('.erb', '')}"
#    File.open(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"), 'w') do |new_file|
#      new_file.write ERB.new(File.read(file)).result(binding)
#    end
#  else
#    puts "linking ~/.#{file}"
#    system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
#  end
#end

##########################################################
install_git_submodules() {
  git submodule init
  git submodule update
}
create_swap_directory() {
  mkdir -p "$HOME/.vimswap"
}

create_undo_directory() {
  mkdir -p "$HOME/.vim/undo"
}

link_files() {
  local source_directory=$(dirname "$(cd "$(dirname "$0")" && pwd)/$(basename "$0")")
  for file in $source_directory/*
  do
    link_file $file
  done
}

link_file() {
  local source=$1
  local filename=$(basename "$source");
  if test $filename = "install.sh" -o $filename = "README.md"
  then
    echo "skipping $filename"
  else
    ln -nsFfv "$source" "$HOME/.${filename}"
  fi
}

touch_vimrc_local() {
  local vimrc_local="$HOME/.vimrc_local";
  if test ! -f $vimrc_local
  then
    touch $vimrc_local;
    echo "Creating placeholder at ${vimrc_local}"
    echo "\" Put private customizations in here" >> $vimrc_local
    echo "\" and/or link to one of the per-machine shared configs" >> $vimrc_local
  fi
}

main() {
  install_git_submodules
  create_swap_directory
  create_undo_directory
  touch_vimrc_local
  link_files
}

main
