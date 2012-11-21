def home(*args)
  File.join(File.expand_path('~'), *args)
end

def this(*args)
  File.join(File.expand_path(File.dirname(__FILE__)), *args)
end

dotfiles = {
  '.dotfiles_location' => '',
  '.gitconfig' => 'gitconfig',
  '.zshrc' => 'zshrc',
  '.vim_runtime' => 'vimrc'
}

task :install => :update

task :update => [
  :check_repos,
  :make_symlinks,
  :install_vimrc
]

task :check_repos do
  sh %{git submodule foreach --recursive git pull}
end

dotfiles.each do |target,src|
  file home(target) do
    ln_s this(src), home(target)
  end
  task :make_symlinks => home(target) 
end

task :install_vimrc do
  sh %{sh vimrc/install_awesome_vimrc.sh}
end

