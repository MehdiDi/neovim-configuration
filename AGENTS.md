# Repository Guidelines

## Project Structure & Module Organization
- **Entry point:** `init.lua` sets leaders and loads `lua/config/*` and lazy.nvim.
- **Config:** `lua/config/` holds editor options (`options.lua`), keymaps (`keymaps.lua`), shims, and lazy bootstrap (`lazy.lua`).
- **Plugins:** `lua/plugins/` contains one-file specs that `return { ... }` for each plugin area (e.g., `lsp.lua`, `treesitter.lua`, `telescope.lua`, `formatting.lua`, `qol.lua`, `ui.lua`).
- **State/locks:** `lazy-lock.json` pins plugin commits; `startup.log`/`nvim.log` aid troubleshooting.

## Build, Test, and Development Commands
- **Sync/update plugins:** inside Neovim, run `:Lazy sync` (install/update) and `:Lazy check` (updates check).
- **Treesitter parsers:** `:TSUpdate`; install extras via `:TSInstall <lang>`.
- **LSP/tools:** open `:Mason` to install/update language servers/formatters.
- **Health checks:** `:checkhealth` for environment validation.
- **Debug info:** `:LspInfo`, `:ConformInfo`, and `:Telescope` for feature verification.
- **Isolated testing:** `NVIM_APPNAME=nvim-dev nvim` to test changes without affecting your main config.

## Coding Style & Naming Conventions
- **Language:** Lua (2‑space indent). Keep modules small and focused.
- **Plugin specs:** each file returns a Lazy.nvim spec table; prefer descriptive lowercase filenames (e.g., `lsp.lua`, `nvim-tree.lua`).
- **Keymaps/options:** extend in `lua/config/keymaps.lua` and `lua/config/options.lua` rather than inline in specs when possible.
- **Formatting:** prefer `stylua` if available (`stylua .`); avoid trailing whitespace and unused locals.

## Testing Guidelines
- **Manual validation:** open representative files (TS/JS/Go/Markdown) and confirm highlighting, LSP, formatting, and Telescope work.
- **Commands to verify:** `:LspInfo`, make edits and trigger `BufWritePre` to verify `conform.nvim` formatting, run `:TSUpdate` and re-open files.
- **No unit tests:** this repo relies on runtime checks and health reports.

## Commit & Pull Request Guidelines
- **Commits:** concise, imperative subject; scope prefix when helpful. Examples: `lsp: enable eslint`, `treesitter: add go`, `qol: tweak which-key groups`.
- **PRs:** include summary, rationale, notable keymaps, and screenshots/log snippets if UI/health changes. List commands used (e.g., `:Lazy sync`, `:checkhealth`).
- **Verification:** confirm clean startup (no errors in `startup.log`) and no breaking changes to existing keymaps.

## Security & Configuration Tips
- Avoid machine‑specific absolute paths or secrets. Prefer tool installers via `mason.nvim` and project‑local linters/formatters.
- Keep `ensure_installed` lists minimal and language‑driven; large defaults can slow startup.
