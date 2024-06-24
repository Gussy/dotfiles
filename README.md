# dotfiles

Personal dot files for development.

## Prerequisites

### MacOS

```shell
brew install fzf
brew install zoxide
brew install jandedobbeleer/oh-my-posh/oh-my-posh
brew install --cask font-cascadia-code-nf
```

### Debian

```shell
sudo apt install zsh fzf unzip
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
curl -s https://ohmyposh.dev/install.sh | bash -s
```

## Install

```bash
source bin/activate-hermit
just install
chsh -s /usr/bin/zsh
```
