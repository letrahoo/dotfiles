# if [ -e ~/.vim ]
# then
#   rm -rf ~/.vim
# fi

mkdir -p ~/.vim
cp -r vim/ ~/.vim
cp -r vim/ ~/.config/nvim
cp ./zsh/.zshrc ~/.zshrc

