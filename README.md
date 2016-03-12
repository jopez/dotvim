Based on
http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen/

```bash
git clone https://github.com/jopez/dotvim dotvim
ln -s dotvim ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc
ln -s ~/.vim/gvimrc ~/.gvimrc

stop here!
cd .vim
git submodule init
git submodule update
```

## Update all bundled modules

```bash
git submodule foreach git pull origin master
```

## Install a new bundle

```bash
git submodule add http://github.com/tpope/vim-fugitive.git bundle/fugitive
git add .
git commit -m "Install Fugitive.vim bundle as a submodule."
```

## To remove a submodule

```bash
1. Delete the relevant section from the .gitmodules file.
2. Delete the relevant section from .git/config.
3. Run git rm --cached path_to_submodule (no trailing slash).
4. Commit and delete the now untracked submodule files.
```
