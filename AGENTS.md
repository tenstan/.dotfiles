# Repository guidance

Personal dotfiles for Windows, Arch Linux, and Arch Linux under WSL. Favor
cross-platform configuration where practical, but keep platform-specific
installation and behavior explicit. [README.md](README.md) covers installation
and SSH/KeePassXC setup.

## Layout and deployment

The installers symlink these paths into the home directory, so edits here can
immediately affect running applications. Edit repository sources, not installed
copies. The installer scripts are authoritative for exact destinations.

| Source                                        | Platforms      | Linked to                                           |
| --------------------------------------------- | -------------- | --------------------------------------------------- |
| `neovim/`                                     | All            | `~/.config/nvim`; `~/AppData/Local/nvim` on Windows |
| `git/.gitconfig`                              | Arch, Arch WSL | `~/.gitconfig`                                      |
| `git/.windows.gitconfig`                      | Windows        | `~/.gitconfig`                                      |
| `fish/`                                       | Arch, Arch WSL | `~/.config/fish`                                    |
| `hyprland/`                                   | Arch           | `~/.config/hypr`                                    |
| `waybar/`, `fuzzel/`, `wezterm/`              | Arch           | `~/.config/<directory name>`                        |
| `powershell/Microsoft.Powershell_profile.ps1` | Windows        | `$PROFILE` of the PowerShell running the installer  |
| `windows-terminal/settings.json`              | Windows        | Windows Terminal's `LocalState/settings.json`       |
| `jetbrains/rider/.ideavimrc`                  | Windows        | `~/.ideavimrc`                                      |

- `install-windows.ps1` uses winget and Chocolatey and manages Node.js with nvm.
  `install-arch.sh` (desktop) and `install-arch-wsl.sh` (no desktop) use pacman
  and yay and manage Node.js with fnm. The installers are independent: when
  adding a dependency, update each installer whose platform needs it, and update
  the README if setup steps change.
- Plugin `build` steps in `neovim/lua/_/plugins/` need their build tools
  installed by every applicable installer.
- Git identity lives in the machine-local `~/.local.gitconfig`, which both Git
  configs include. Keep identity out of the repository.

## Neovim

- `neovim/init.lua` loads the core modules before lazy.nvim. The leader key
  (Space) is set in `lua/_/keymaps.lua` and must be defined before lazy.nvim
  loads.
- Each file in `neovim/lua/_/plugins/` returns a lazy.nvim spec annotated with
  `---@type LazySpec`. Put a new plugin in a related file there or in a new
  file, and keep its options and mappings with its spec. General mappings belong
  in `lua/_/keymaps.lua`.
- `neovim/lazy-lock.json` is written by lazy.nvim. Change it only for
  intentional plugin updates, and commit it with any configuration changes that
  require the new plugin versions.
- Starting Neovim with this configuration can download plugins, parsers, and
  language servers. The Neotest `npm test` setting is for projects opened in
  Neovim, not for this repository.

## Editing conventions

- Follow the surrounding file's formatting. Lua generally uses four spaces and
  single-quoted strings.
- Commit files with LF line endings; the Bash installers fail with CRLF. No
  `.gitattributes` file enforces this.
- When changing shared editing behavior, check the matching mappings in Neovim
  and `jetbrains/rider/.ideavimrc`, and keep intentional differences.
- `git/.gitconfig` and `git/.windows.gitconfig` duplicate their shared settings
  rather than including a common file. Apply shared changes to both, and keep
  platform-specific values such as `core.autocrlf` and `core.editor`.
- `install-windows.ps1` runs in Windows PowerShell 5.1 (README starts it with
  `powershell.exe`) and links the profile to the `$PROFILE` of the PowerShell
  running it. Keep both files compatible with Windows PowerShell 5.1 and
  PowerShell 7: avoid `&&`, `||`, `??`, and the ternary operator.
- Keep Windows-only dependencies and APIs behind platform checks in shared
  configuration. Fish syntax differs from Bash and PowerShell.
- Prefer home-relative or environment-derived paths in new configuration.
  Existing usernames, monitor names, terminal profiles, and wallpaper paths are
  machine-specific, not portable defaults.

## Files that applications rewrite

Applications write some files through the symlinks:

- Windows Terminal rewrites `windows-terminal/settings.json`, reformatting it and
  removing comments. Don't rely on comments in that file.
- lazy.nvim updates `neovim/lazy-lock.json`.
- Fish writes `fish/fish_variables`, which Git ignores.

Don't revert or reformat these application-made changes unless asked.

## Working and validation

- Check `git status` before editing and preserve existing local changes.
- Never run the installers as a test. They install packages, enable services,
  replace configuration, and change the login shell.
- There is no build, test suite, CI workflow, or repository-wide formatter.
  Validate the files you changed, and report which checks ran and what remains
  unverified on other platforms.

Run checks from the repository root. Use `git --no-pager`, because the Git
configuration pages output through delta.

- Changed tracked files, including staged changes:
  `git --no-pager diff HEAD --check -- <paths>`
- New, untracked files:
  `git --no-pager diff --no-index --check -- /dev/null <file>`. Any output
  indicates a whitespace problem; the exit status is nonzero even for a clean
  file.
- Bash installers: `bash -n <script>`. On Windows, `bash` may start WSL; use Git
  Bash instead (`& "$env:ProgramFiles\Git\bin\bash.exe" -n <script>` in
  PowerShell). Also run ShellCheck when available: `bash -n` checks syntax only
  and misses problems such as undefined variables.
- PowerShell files: on Windows, run this with `powershell.exe` (5.1) and again
  with `pwsh` (7). `-NoProfile` avoids loading this repository's profile.

  ```text
  powershell.exe -NoProfile -Command 'foreach ($f in (Get-Item -ErrorAction Stop install-windows.ps1, powershell/Microsoft.Powershell_profile.ps1)) { $e = $null; [void][System.Management.Automation.Language.Parser]::ParseFile($f.FullName, [ref]$null, [ref]$e); if ($e) { $e; exit 1 } }'
  ```

- Neovim Lua runs on LuaJIT. Check each changed file without loading the
  configuration by replacing the path below. This does not check modules that
  the file requires.

  ```text
  nvim --headless -u NONE -i NONE -n -c "lua local f, err = loadfile('neovim/init.lua'); if not f then print(err); vim.cmd('cquit 1') end" -c "qa!"
  ```

  Don't use a Lua 5.4 `luac` for Neovim files; it accepts syntax that LuaJIT
  rejects.

- `wezterm/wezterm.lua` runs on WezTerm's embedded Lua 5.4. Check it with a
  Lua 5.4 `luac -p`, or in WezTerm, which reloads the file automatically and
  reports load errors. Don't use the Neovim check for it.
- Waybar's `config.jsonc` allows comments and `style.css` is GTK CSS, so strict
  JSON and browser CSS validators report false errors.
- For behavior changes, test the affected application on its target platform.
  For Neovim, check `:checkhealth` and `:messages` in a configured session.

## Maintaining this file

Keep this file concise and limited to stable, non-obvious guidance. Update it
when deployment, dependencies, or validation change. Add skills or
agent-specific instruction files only when a real workflow needs them.
