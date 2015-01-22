#!/usr/bin/env ruby
# Todo - make this accessible through the installer
def install_powerline
  platform = `uname`.strip
  system "brew install python" if (platform == "Darwin") && !File.exists?("/usr/local/bin/python")
  target = "#{File.dirname(__FILE__)}/vim/bundle/powerline"
  system "git clone git://github.com/Lokaltog/powerline #{target}" unless File.exists?(target)
  puts "You'll probably want to install the powerline fonts and set the terminal to DejaVu-14"
end

def replace_file(file)
  system %Q{rm -rf "~#{@home}/.#{file.sub('.erb', '')}"}
  link_file(file)
end

def create_swap_directory 
  system %Q{mkdir "~#{@home}/.vimswap"}
end

def create_undo_directory 
  system %Q{mkdir "~#{@home}/.vim/undo"}
end

def setup_submodules
  system "git submodule init"
  system "git submodule update"
end

def touch_vimrc_local
  target = File.expand_path("~#{@home}/.vimrc_local")
  unless File.exists? target
    File.open(target, 'w') do |new_file|
      new_file << "\" Put private customizations in here\n"
      new_file << "\" and/or link to one of the per-machine shared configs\n"
    end
  end
end


def link_file(file)
  if file =~ /.erb$/
    puts "generating ~#{@home}/.#{file.sub('.erb', '')}"
    File.open(File.join("~#{@home}", ".#{file.sub('.erb', '')}"), 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  else
    puts "linking ~#{@home}/.#{file}"
    system %Q{ln -s "$PWD/#{file}" "~#{@home}/.#{file}"}
  end
end

##########################################################
require 'etc'
@home = Etc.getpwuid(Process::UID.eid).name
setup_submodules
#install_powerline if ARGV[0] == "--with-powerline"
replace_file("vimrc")
replace_file("gvimrc")
replace_file("vim")
touch_vimrc_local
create_swap_directory
create_undo_directory
