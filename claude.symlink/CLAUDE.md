# Global Claude Instructions

## Installing CLI Tools

When installing a CLI tool or application, always:

1. Add it to the appropriate section in `/Users/andrewdt/workspace/Setup/setup.sh` first:
   - Homebrew packages → `MAC_PACKAGES` array
   - Homebrew cask apps → `CASKS` array
   - Non-brew installs → `install_non_brew_applications()`
2. Then run the install command.

## Pull Request Links

After pushing to any branch other than `main` or `master`, always provide the GitHub PR link in the format:
`https://github.com/<owner>/<repo>/compare/<branch>`

## Writing Plans

When presenting or updating a plan, always show the full plan content — never show a diff of what changed. Only show a diff if the user explicitly asks for one.

## Parallel Sessions

When a task is handed off to a parallel session (e.g. via executing-plans), that session should use PushNotification to alert the user when it is complete.
