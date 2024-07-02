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
      }
      vim.cmd.colorscheme 'fluoromachine'
    end
  }
}
