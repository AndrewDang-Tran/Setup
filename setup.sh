#!/usr/bin/env bash

DOTFILES_ROOT=$(pwd)

set -e

inform () {
    printf "  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
    printf "\r  [ \033[0;33m?\033[0m ] $1 \n"
}

success () {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
    echo ''
    exit
}

link_file () {
    local src=$1 dst=$2

    local overwrite= backup= skip=
    local action=

    if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
    then

        if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
        then

            local currentSrc="$(readlink $dst)"

            if [ "$currentSrc" == "$src" ]
            then

                skip=true;

            else

                user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
                    [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
                read -n 1 action

                case "$action" in
                    o )
                        overwrite=true;;
                    O )
                        overwrite_all=true;;
                    b )
                        backup=true;;
                    B )
                        backup_all=true;;
                    s )
                        skip=true;;
                    S )
                        skip_all=true;;
                    * )
                        ;;
                esac

            fi

        fi

        overwrite=${overwrite:-$overwrite_all}
        backup=${backup:-$backup_all}
        skip=${skip:-$skip_all}

        if [ "$overwrite" == "true" ]
        then
            rm -rf "$dst"
            success "removed $dst"
        fi

        if [ "$backup" == "true" ]
        then
            mv "$dst" "${dst}.backup"
            success "moved $dst to ${dst}.backup"
        fi

        if [ "$skip" == "true" ]
        then
            success "skipped $src"
        fi
    fi

    if [ "$skip" != "true" ]  # "false" or empty
    then
        ln -s "$1" "$2"
        success "linked $1 to $2"
    fi
}

install_dotfiles () {
    inform 'installing dotfiles'

    local overwrite_all=false backup_all=false skip_all=false

    for src in $(find "$DOTFILES_ROOT" -maxdepth 3 -name '*.symlink')
    do
        dst="$HOME/.$(basename "${src%.*}")"
        link_file "$src" "$dst"
    done
}

install_mac_applications () {
    if test ! $(which zsh); then
        inform "Installing zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
    if test ! $(which brew); then
        inform "Installing homebrew..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    
    if test ! $(which jabba); then
        inform "Installing jabba..."
        curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash && . ~/.jabba/jabba.sh
    fi

    inform "Homebrew update..."
    brew update

    MAC_PACKAGES=(
        vim
        pyenv
        python@3.8
        pipenv
        node
        nvm
        zsh
        docker
        #jabba https://github.com/shyiko/jabba/issues/138
        yarn
        maven
    )

    inform "Installing packages..."
    brew list "${MAC_PACKAGES[@]}" &>/dev/null || brew install "${MAC_PACKAGES[@]}"

    CASKS=(
        spectacle
        alfred
        firefox
        iterm2
        anki
        notion
        flux
        karabiner-elements
        intellij-idea
        postman
        franz
        mactex-no-gui
        zoomus
        docker
    )

    inform "Installing cask apps..."
    inform "${CASKS[@]}..."
    brew cask list "${CASKS[@]}" &>/dev/null || brew install --cask "${CASKS[@]}"
    install_non_brew_applications
}

install_non_brew_applications() {
    pip3 install pipenv
}

setup_firefox_for_mac() {
    inform "Setting up firefox for mac..."
    FIREFOX_DEFAULT_PROFILE=$(ls "$HOME/Library/Application Support/Firefox/Profiles/" | grep default-release)
    mkdir -p "$HOME/library/application support/firefox/profiles/$FIREFOX_DEFAULT_PROFILE/chrome"
    ln -s "$DOTFILES_ROOTfirefox/userChrome.css" "$HOME/library/application support/firefox/profiles/$FIREFOX_DEFAULT_PROFILE/chrome/userChrome.css"
}

install_applications () {
    local platform="$OSTYPE"
    inform "Installing applications dependent on platform..."
    if [[ "$platform" == "linux-gnu" ]]; then
        inform "linux"
    elif [[ "$platform" == "darwin"* ]]; then
        inform "osx"
        install_mac_applications
        setup_firefox_for_mac
    elif [[ "$platform" == "cygwin" ]]; then
        inform "windows cygwin"
    elif [[ "$platform" == "msys" ]]; then
        inform "msys"
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
    elif [[ "$platform" == "freebsd"* ]]; then
        inform "freebsd"
    else
        fail "unknown operating system platform"
    fi
}

setup () {
    install_dotfiles
    install_applications
}

setup
