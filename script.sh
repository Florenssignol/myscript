#!/usr/bin/env bash
############################
# This script sets up new macs for devs at Bold
############################

homedir=$1

echo "Hello, I'm starting the install"
chmod u+r+x ./script.sh

echo "Installing Xcode"
xcode-select --install

#"Disabling OS X Gate Keeper"
#"(You'll be able to install any app you want from here on, not just Mac App Store apps)"
sudo spctl --master-disable
sudo defaults write /var/db/SystemPolicy-prefs.plist enabled -string no
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "Installing Homebrew & ruby & rails"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew upgrade
brew install rbenv ruby-build
echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.zshrc
source ~/.zshrc
rbenv install 2.7.0
rbenv global 2.7.0
ruby -v
gem install rails -v 6.0.2.1
rbenv rehash
rails -v

echo "Installing homebrew cask"
brew install caskroom/cask/brew-cask

echo "Installing VSCODE with extensions"
brew cask install visual-studio-code
#sudo snap install --classic code
xdg-mime default code.desktop text/plain
cat << EOF >> ~/.bash_profile
export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
EOF
code --extensions-dir <dir>
code --install-extension (<formulahendry.auto-close-tag>)
code --install-extension (<formulahendry.auto-rename-tag>)
code --install-extension (<hookyqr.beautify>)
code --install-extension (<alefragnani.bookmarks>)
code --install-extension (<coenraads.bracket-pair-colorizer>)
code --install-extension (<streetsidesoftware.code-spell-checker>)
code --install-extension (<aliariff.vscode-erb-beautify>)
code --install-extension (<waderyan.gitblame>)
code --install-extension (<eamodio.gitlens>)
code --install-extension (<ecmel.vscode-html-css>)
code --install-extension (<ms-vsliveshare.vsliveshare>)
code --install-extension (<ms-vsliveshare.vsliveshare-audio>)
code --install-extension (<ms-vsliveshare.vsliveshare-pack>)
code --install-extension (<gerane.theme-monokai>)
code --install-extension (<azemoh.one-monokai>)
code --install-extension (<esbenp.prettier-vscode>)
code --install-extension (<wallabyjs.quokka-vscode>)
code --install-extension (<rebornix.ruby>)
code --install-extension (<misogi.ruby-rubocop>)
code --install-extension (<wayou.vscode-todo-highlight>)
code --install-extension (<wingrunr21.vscode-ruby>)

echo "Installing Oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Install git user"
brew install git
git config --global user.name "YOUR NAME"
git config --global user.email "YOUR@EMAIL.com"

echo "Cloning Boldsi project"
cd ~
git clone https://github.com/ArnaudRemi/boldsi.git

echo "installing apps with Cask..."
brew cask install --appdir="/Applications" ${apps[@]}

echo "Installing Iterm"
brew cask install iterm2

echo "Now starting to install Apps:"
echo "Installing Postman"
brew cask install postman

echo "Installing slack"
brew cask install slack

echo "Installing 1Password"
brew cask install 1password

echo "Installing Spotify"
brew cask install spotify

echo "Installing Chrome"
brew cask install google-chrome

echo "Installing Microsoft outlook"
brew cask install microsoft-office

echo "Installing Redis"
brew install Redis

echo "Now editing dock"
dockutil --remove all
dockutil --add /Applications/finder.app --position 1 --no-restart --allhomes
dockutil --add /Applications/ical.app --after "finder" --no-restart --allhomes
dockutil --add /Applications/Google\ Chrome.app --after "ical" --no-restart --allhomes
dockutil --add /Applications/vscode.app --after "Google Chrome" --no-restart --allhomes
dockutil --add /Applications/notes.app --after "vscode" --no-restart --allhomes
dockutil --add /Applications/iterm2.app --after "notes" --no-restart --allhomes
dockutil --add /Applications/slack.app --after "iterm2" --no-restart --allhomes
dockutil --add /Applications/microsoft_outlook.app --after "slack" --no-restart --allhomes
dockutil --add /Applications/1password.app --after "Microsoft Outlook" --no-restart --allhomes
dockutil --add /Applications/spotify.app --after "1password" --no-restart --allhomes
dockutil --add /Applications/System Preferences.app --after "Spotify" --no-restart --allhomes
dockutil --add /Applications/imessage.app --after "System Preferences" --no-restart --allhomes
dockutil --add /Applications/postman.app --after "imessage" --no-restart --allhomes

dockutil --add '/Applications' --view grid --display folder --sort name  --section others --position 1 --allhomes
dockutil --add '~/Downloads' --view list --display folder --sort dateadded --section others --position 2 --allhomes
dockutil --add '/trash' --view list --display folder --sort dateadded --section others --position end --allhomes

echo "Setting up aliases"
alias gs="git status"
alias rc="rails c"
alias rs="rails s"
alias startredis="redis-server /usr/local/etc/redis.conf"
alias startsidekiq="bundle exec sidekiq"

echo "Setting up computer commands"
#"Disable annoying backswipe in Chrome"
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

#"Saving to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

#"Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

#"Disable smart quotes and smart dashes as they are annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

#"Setting trackpad & mouse speed to a reasonable number"
defaults write -g com.apple.trackpad.scaling 2
defaults write -g com.apple.mouse.scaling 2.5

#"Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate"
defaults write com.apple.dock tilesize -int 36

#"Disabling the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

#"Speeding up Mission Control animations and grouping windows by application"
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock "expose-group-by-app" -bool true

#"Setting Dock to auto-hide and removing the auto-hiding delay"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

eval "$(rbenv init -)"
export EDITOR="code --wait"
export GIT_EDITOR="code --wait"
source ~/.fzf.zsh

killall Finder

echo "Cleaning up"
brew cleanup

echo "All done!"
