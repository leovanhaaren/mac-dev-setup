#!/bin/bash

echo "Creating an SSH key for you..."
ssh-keygen -t rsa

echo "Please add this public key to Github \n"
echo "https://github.com/account/ssh \n"
read -p "Press [Enter] key after this..."

echo "Installing xcode-stuff"
xcode-select --install

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  # single user
  # ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  
  # multi user
  mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
  eval "$(homebrew/bin/brew shellenv)"
  brew update --force --quiet
  chmod -R go-w "$(brew --prefix)/share/zsh"
fi

# Update homebrew recipes
echo "Updating homebrew..."
brew update

echo "Installing Git..."
brew install git

echo "Git config"

# Ask the user for git config
read -p 'Git username: ' usernamevar
read -p 'Git email: ' emailvar
echo
echo "Thankyou ${usernamevar} (${emailvar})"

git config --global user.name "${usernamevar}"
git config --global user.email ${emailvar}

# echo "Installing brew git utilities..."
# brew install git-extras
# brew install legit
# brew install git-flow

echo "Installing other brew stuff..."
#brew install tree
#brew install wget
#brew install trash
brew install node

echo "Cleaning up brew"
brew cleanup

echo "Installing homebrew cask"
#brew install caskroom/cask/brew-cask

# echo "Copying dotfiles from Github"
# cd ~
# git clone git@github.com:leovanhaaren/dotfiles.git .dotfiles
# cd .dotfiles
# sh symdotfiles

#Install Zsh & Oh My Zsh
echo "Installing Oh My ZSH..."
curl -L http://install.ohmyz.sh | sh

echo "Setting up Zsh plugins..."
cd ~/.oh-my-zsh/custom/plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git

echo "Setting ZSH as shell..."
chsh -s /bin/zsh

echo 'eval $(homebrew/bin/brew shellenv)' >> /Users/$USER/.zshrc

# Apps
apps=(
  alfred
  # bartender
  bettertouchtool
  cleanmymac
  firefox
  google-chrome
  # phpstorm
  visual-studio-code
  iterm2
  1password
  # sequel-pro
  notion
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps with Cask..."
brew install --cask --appdir="/Applications" ${apps[@]}

brew cleanup

echo "Done!"
