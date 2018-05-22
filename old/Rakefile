def home(*args)
  File.join(File.expand_path('~'), *args)
end

def this(*args)
  File.join(File.expand_path(File.dirname(__FILE__)), *args)
end

dotfiles = {
  '.dotfiles_location' => '',
  '.gitconfig' => 'gitconfig',
  '.zshrc' => 'zshrc'
}

task :install => :update

task :update => [:make_symlinks]


dotfiles.each do |target,src|
  file home(target) do
    ln_s this(src), home(target)
  end
  task :make_symlinks => home(target) 
end

