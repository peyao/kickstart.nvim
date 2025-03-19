return {
  {
    'NTBBloodbath/doom-one.nvim',
    config = function()
      vim.g.doom_one_plugin_nvim_tree = true
      vim.g.doom_one_plugin_telescope = true
      vim.g.doom_one_plugin_indent_blankline = true
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
      integrations = {
        fidget = true,
        indent_blankline = { enabled = true },
      },
      dim_inactive = {
        enabled = true
      },
      background = {
        light = 'latte',
        dark = 'mocha'
      }
    },
  },
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    lazy = false,
    config = function()
      require('tokyonight').setup {
        dim_inactive = true,
        lualine_bold = true,
        on_highlights = function(hl, c)
          -- nvim-tree colors
          hl.NvimTreeNormal = { fg = c.none }
          hl.NvimTreeNormalNC = { fg = c.none }
        end,
      }
      -- You can configure highlights by doing something like
      -- vim.cmd.hi 'Comment gui=none'

      -- vim.cmd.colorscheme 'catppuccin'
      -- vim.cmd.colorscheme 'tokyonight'
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    opts = {
      dimInactive = true
    }
  },
  {
    'nyngwang/nvimgelion',
    config = function ()
      -- vim.cmd.colorscheme 'nvimgelion'
    end
  },
  {
    'maxmx03/fluoromachine.nvim',
    priority = 1000,
    config = function()
      local fm = require 'fluoromachine'
      fm.setup {
        glow = true,
        -- transparent = true,
        -- theme = 'fluoromachine',
        -- theme = 'retrowave',
        theme = 'delta',
        colors = function(c, color)
          return {
            editor = {
              selection = color.darken(c.yellow, 70)
            }
          }
        end,
      }
      -- vim.cmd.colorscheme 'fluoromachine'
    end
  },
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('github-theme').setup({
        options = {
          dim_inactive = true,
          styles = {
            comments = 'italic',
          },
        }
      })

      vim.cmd('colorscheme github_light')
    end,
  },
}
