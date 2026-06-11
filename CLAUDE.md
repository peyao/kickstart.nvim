# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration forked from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Plugin manager is **lazy.nvim**.

## File Structure

- `init.lua` — main config: options, keymaps, LSP, completion, treesitter, and lazy.nvim bootstrap. Contains both upstream kickstart code and personal customizations (marked with `-- peyao`).
- `lua/custom/plugins/init.lua` — all personal plugin additions and their keymaps.
- `lua/custom/plugins/themes.lua` — colorscheme plugins; active theme is `dracula` (set at the bottom of the file).
- `lua/kickstart/plugins/` — optional kickstart extras (debug, lint, autopairs, etc.); currently all commented out in `init.lua`.

## Architecture Conventions

**Adding plugins**: Add to `lua/custom/plugins/init.lua` (or a new file under `lua/custom/plugins/`). The `{ import = 'custom.plugins' }` line in `init.lua` auto-imports everything in that directory.

**VSCode compatibility**: Plugins that don't work in VSCode use `cond = not vim.g.vscode`. Apply this to any new UI or editor-behavior plugins.

**Leader key**: `<Space>`

## Existing Keymap Groups (which-key registered)

| Prefix | Group |
|--------|-------|
| `<leader>T` | Toggle |
| `<leader>c` | Code (n/x) |
| `<leader>d` | Document |
| `<leader>l` | Log (debugprint) |
| `<leader>r` | Rename |
| `<leader>s` | Search (Telescope) |
| `<leader>w` | Workspace |
| `<leader>f` | File |
| `<leader>G` | Git |
| `<leader>h` | Git Hunk (n/v) |
| `<leader>a` | AI Claude Code |

## Notable Keymaps (avoid conflicts)

**Taken leader bindings**: `<leader>e`, `<leader>q`, `<leader>b`, `<leader>/`, `<leader><leader>`, `<leader>F`, `<leader>D`, `<leader>th`, `<leader>rn`, `<leader>ca`, `<leader>cc`, `<leader>cb`, `<leader>ct`, `<leader>cs`, `<leader>cj`, `<leader>ll`, `<leader>lL`, `<leader>ld`, `<leader>ff`, `<leader>fa`, `<leader>GH`, `<leader>GB`, `<leader>sm`, `<leader>su`, all `<leader>s*` telescope bindings, `<leader>af`, `<leader>ar`, `<leader>aC`, `<leader>am`, `<leader>aa`, `<leader>ad`.

**Alt bindings in use**: `<A-t/w/a/d/q/e/r>` (tabby tabs), `<A-m/n/p>` + `<A-S-m>` (grapple).

**g-prefix taken**: `gd`, `gr`, `gI`, `gD`, `gp`, `gP`.

**Window nav**: `<C-h/j/k/l>` (focus), `<C-S-h/j/k/l>` (move window).

**Other taken bindings**: `<C-,>` (Claude Code toggle), `<C-.>` (LazyGit toggle), `<C-/>` (NvimTree toggle).

## LSP / Formatting

- LSP servers managed by Mason: `html`, `cssls`, `angularls`, `lua_ls`
- Formatters via conform.nvim: `stylua` (Lua), `eslint_d` (JS/TS/SCSS)
- Format-on-save disabled for `c`, `cpp`, `htmlangular`
- Manual format: `<leader>F`

## Plugin Management Commands

```
:Lazy          # open plugin manager UI
:Lazy update   # update all plugins
:Mason         # manage LSP servers / formatters
:checkhealth   # diagnose issues
```
