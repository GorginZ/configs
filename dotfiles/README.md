# dotfiles

### vim
make sure non baked in vim is installed (vim version i good) -> reason being can't use plugin for yaml guidelines bc macOS version doesn't have certain functions.

install plug

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

open vim and run: ```:PlugInstall``` to install plugins.

---

### ~/.zshrc

set up ohmyzsh again.

smoll aliases I like:

```
alias gs="git status"
alias gc="git commit"
bindkey -v
```
---

### ZSHRC -> kubernetes stuff

```
source <(kubectl completion zsh)  # setup autocomplete in zsh into the current shell
echo '[[ $commands[kubectl] ]] && source <(kubectl completion zsh)' >> ~/.zshrc # add autocomplete permanently to your zsh shell
```
put in zshrc for autocomplete and k alias
```
alias k=kubectl
complete -o default -F __start_kubectl k
```
