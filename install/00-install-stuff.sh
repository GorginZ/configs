#!/usr/bin/env bash

die() { echo "${1:-Exited}"; exit "${2:-1}";}

prompt_continue () {
  echo "Installing $1 failed, continue? Y for yes, anything else for no"
  read input
  if [[ $input == "Y" || $input == "y" ]]; then
    echo "Continuing..."
  else
    die
  fi
}

brew_install() {
  echo "Installing $1"
  brew install $2 || prompt_continue $1
}

echo "Installing HomeBrew"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || prompt_continue Homebrew

#general dev
brew_install "non mac vim" "vim"
brew_install "Git" "git"
brew_install "Slack" "--cask slack"
brew_install "1Password" "--cask 1password"
brew_install "Iterm2" "--cask iterm2"
brew_install "Visual Studio Code" "--cask visual-studio-code"

#cloud yaml k8s
brew_install "yq" "yq"
brew_install "jq" "jq"
brew_instal "cfn-lint" "cfn-lint"
brew_install "icdiff" "icdiff"
brew_install "watch"

# zshrc stuffs