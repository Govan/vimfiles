require 'rake'

desc "install my vim setup"
task :install do
  setup_submodules
  replace_file("vimrc")
  replace_file("gvimrc")
  replace_file("vim")
  touch_vimrc_local
  create_swap_directory
end

desc "install powerline, assuming we're on OS X" 
task :install_powerline do
  platform = `uname`.strip
  system "brew install python" if (platform == "Darwin") && !File.exists?("/usr/local/bin/python")
  target = "#{File.dirname(__FILE__)}/vim/bundle/powerline"
  system "git clone git://github.com/Lokaltog/powerline #{target}" unless File.exists?(target)
  puts "You'll probably want to install the powerline fonts and set the terminal to DejaVu-14"
end

def replace_file(file)
  system %Q{rm -rf "$HOME/.#{file.sub('.erb', '')}"}
  link_file(file)
end

def create_swap_directory 
  system %Q{mkdir "$HOME/.vimswap"}
end

def setup_submodules
  system "git submodule init"
  system "git submodule update"
end

def touch_vimrc_local
  target = File.expand_path("~/.vimrc_local")
  unless File.exists? target
    File.open(target, 'w') do |new_file|
      new_file << "\" Put private customizations in here\n"
      new_file << "\" and/or link to one of the per-machine shared configs\n"
    end
  end
end


def link_file(file)
  if file =~ /.erb$/
    puts "generating ~/.#{file.sub('.erb', '')}"
    File.open(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"), 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  else
    puts "linking ~/.#{file}"
    system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
  end
end
