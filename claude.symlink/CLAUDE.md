# Global Claude Instructions

## Installing CLI Tools

When installing a CLI tool or application, always:

1. Add it to the appropriate section in `/Users/andrewdt/workspace/Setup/setup.sh` first:
   - Homebrew packages → `MAC_PACKAGES` array
   - Homebrew cask apps → `CASKS` array
   - Non-brew installs → `install_non_brew_applications()`
2. Then run the install command.
