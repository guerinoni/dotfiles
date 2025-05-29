#! /bin/sh

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'



# Dock

# speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.12

# remove launch animation
defaults write com.apple.dock launchanim -bool false

# set to dock position
defaults write com.apple.dock "orientation" -string "bottom"

# set 36 of icon size
defaults write com.apple.dock "tilesize" -int "36"

# autohide
defaults write com.apple.dock "autohide" -bool "true"

# remove recents from dock
defaults write com.apple.dock "show-recents" -bool "false"

# show active applications only
defaults write com.apple.dock "static-only" -bool "true"



# Finder

# list view in all Finder windows
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# show extension of files
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"

# show hidden files
defaults write com.apple.finder "AppleShowAllFiles" -bool "true"

# show path in a bar
defaults write com.apple.finder "ShowPathbar" -bool "true"

# deafult search in current folder
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"

# save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false



# Thouchpad

# three finger drag
defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool "true"

# enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1



# Keyboard

# fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# disable held down menu when keep press a letter
defaults write NSGlobalDomain "ApplePressAndHoldEnabled" -bool "false"

# disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false



# Safari + webkit

# don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true



# iMessage

# disable automatic emoji substitution (i.e. use plain text smileys)
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

# disable smart quotes as it’s annoying for messages that contain code
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

# disable continuous spell checking
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false



# Kill all apps affected

for app in "Activity Monitor" \
	"Address Book" \
	"Calendar" \
	"cfprefsd" \
	"Contacts" \
	"Dock" \
	"Finder" \
	"Mail" \
	"Messages" \
	"Photos" \
	"Safari" \
	"SystemUIServer" \
	"iCal"; do
	killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."

