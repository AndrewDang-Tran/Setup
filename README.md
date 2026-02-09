### Setup
Run the `setup.sh` script to symlink all configuration files. It will also install my commonly used applications but only supports osx with brew.

#### OSX Instructions
1. Install xcode and generate ssh key for Github
```
xcode-select --install;
cd ~/.ssh; ssh-keygen -o;
```

2. Write public ssh key to Github
3. Clone repo and run setup script
```
mkdir workspace; cd workspace;
git clone git@github.com:AndrewDang-Tran/Setup.git; cd Setup; ./setup.sh;
```

4. Change OSX and App settings
- capslock to esc
- turn off natural scrolling
- spotlight to alfred. Enable clipboard history.

#### Commands not in setup.sh yet
none

#### Computer Applications I can't install with Cask
none

#### Phone Applications
* todoist
* anki
* podcast addict
* [tachiyomi](https://github.com/inorichi/tachiyomi)
