#!/usr/bin/env bash
#this script is for installing regular tools on debian

#WIP wrote on mac we'll take this for a run before it gets too big and ugly an I'll fix it and push it up

die() { echo "${1:-Exited}"; exit "${2:-1}";}

prompt_continue () {
  local component=$1
  local ext_code=$2
  echo "Installing $1 failed, continue? Y for yes, anything else for no"
  read -r input
  if [[ $input == "Y" || $input == "y" ]]; then
    echo "Continuing..."
  else
    die "Installing $component failed" "$ext_code" 
  fi
}

apt_install() {
  echo "Installing $1"
  sudo apt install "$2" || prompt_continue "$1" $?
}

#install vscode based on https://wiki.debian.org/VisualStudioCode
install_vscode() {
  hash curl || echo "curl not installed can't install vscode" && prompt_continue "vscode"
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

  sudo apt-get update
  sudo apt-get install code # or code-insiders
}
#install terraform https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
install_terraform() {

    hash gnupg || echo "gnupg not installed can't install terraform" && prompt_continue "terraform" 1
    hash software-properties-common || echo "software-properties-common not installed can't install terraform" && prompt_continue "terraform" 1

    #HashiCorp GPG signature
    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

    #Hashicorp GPG key
    wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

    #add HashiCorp repo to apt
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list

    sudo apt update && sudo apt install terraform
}

install_yq() {
    wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq
}

sudo apt update || die "apt update failed" $?
apt_install "curl" "curl"
apt_install "gnupg" "gnupg"
apt_install "software-properties-common" "software-properties-common"
apt_install "Git" "git"
apt_install "Vim" "vim"
apt_install "zplug" "zplug"
apt_install "jq" "jq"

#these are "smart" and know their dependencies so check them to tell us WHY they failed if they failed
install_terraform
install_vscode