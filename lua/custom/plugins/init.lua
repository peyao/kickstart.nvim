-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
local jsDebugPrintFileType = {
  left = 'console.log("',
  right = '")',
  mid_var = '", ',
  right_var = ")",
}

return {
  { 'rmagatti/session-lens' }, -- no shortcut key bound yet, launch with :SearchSession
  { 'terrortylor/nvim-comment' }, -- add commenter
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup {
        opts = {
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = false -- Auto close on trailing </
        }
      }
    end,
  }, -- open/close html/jsx tags together
  {
    'dstein64/nvim-scrollview',
    config = function()
      require('scrollview').setup {
        excluded_filetypes = { 'NvimTree' },
        winblend = 50,
        signs_on_startup = { 'all' },
      }
    end,
  }, -- adds scrollbar to the right
  {
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup {
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = true, -- Hide cursor while scrolling
        stop_eof = true, -- Stop at <EOF> when scrolling downwards
        respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = nil, -- Default easing function
        -- Performance Hack: https://github.com/karb94/neoscroll.nvim/issues/80#issue-1579995821
        pre_hook = function()
          vim.opt.eventignore:append({
            'WinScrolled',
            'CursorMoved',
           })
        end,
          post_hook = function()
          vim.opt.eventignore:remove({
            'WinScrolled',
            'CursorMoved',
          })
        end,
        performance_mode = false, -- Disable "Performance Mode" on all buffers.
      }
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup {
        view = {
          width = 60,
        },
        update_focused_file = {
          enable = true,
          update_root = false,
          ignore_list = {},
        },
        ui = {
          confirm = {
            remove = true, -- user confirmation when using removing ("d") on an item
          },
        },
      }
      vim.keymap.set('n', '<leader>t', '<Cmd>NvimTreeToggle<cr>', { desc = 'File Tree [T]oggle', silent = true })
    end,
  }, -- add file directory explorer
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' }
  },
  {
    'nanozuki/tabby.nvim',
    event = 'VimEnter',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('tabby.tabline').use_preset('tab_only', {
        nerdfont = true, -- whether use nerdfont
        -- https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
        lualine_theme = 'dracula', -- lualine theme name
        buf_name = {
          mode = 'tail', -- mode = "'unique'|'relative'|'tail'|'shorten'",
        },
      })

      -- tabby keymaps:
      local bufferMap = vim.api.nvim_set_keymap
      local bufferOpts = { noremap = true, silent = true }
      -- Move to previous/next
      bufferMap('n', '<A-t>', '<Cmd>tabnew<CR>', bufferOpts)
      bufferMap('n', '<A-n>', '<Cmd>tabnext<CR>', bufferOpts)
      bufferMap('n', '<A-b>', '<Cmd>tabprev<CR>', bufferOpts)
      bufferMap('n', '<A-w>', '<Cmd>tabclose<CR>', bufferOpts)
      bufferMap('n', '<A-a>', '<Cmd>tabp<CR>', bufferOpts)
      bufferMap('n', '<A-d>', '<Cmd>tabn<CR>', bufferOpts)
      bufferMap('n', '<A-p>', '<Cmd>tabp<CR>', bufferOpts)
      bufferMap('n', '<A-n>', '<Cmd>tabn<CR>', bufferOpts)
      bufferMap('n', '<A-;>', '<Cmd>tabp<CR>', bufferOpts)
      bufferMap('n', "<A-'>", '<Cmd>tabn<CR>', bufferOpts)
      bufferMap('n', '<A-q>', '<Cmd>-tabmove<CR>', bufferOpts)
      bufferMap('n', '<A-e>', '<Cmd>+tabmove<CR>', bufferOpts)
      bufferMap('n', '<A-r>', ':TabRename ', bufferOpts)
    end,
  },
  {
    'rmagatti/auto-session',
    config = function()
      -- https://www.reddit.com/r/neovim/comments/15bfz5f/how_to_open_nvim_tree_after_restoring_a_session/
      -- Uncomment to always start nvim-tree on auto-session resume
      -- local function change_nvim_tree_dir()
      --   local nvim_tree = require 'nvim-tree'
      --   nvim_tree.change_dir(vim.fn.getcwd())
      -- end

      require('auto-session').setup {
        log_level = 'error',
        auto_session_suppress_dirs = nil,
        post_restore_cmds = { change_nvim_tree_dir, 'NvimTreeOpen' },
        pre_save_cmds = { 'NvimTreeClose' },
      }
    end,
  },
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup {}
    end,
  }, -- open/close parens/brackets together
  {
    'andrewferrier/debugprint.nvim',
    opts = {
      keymaps = {
        normal = {
          variable_below = '<leader>ll',
          variable_above = '<leader>lL',
          delete_debug_prints = '<leader>ld',
        }
      },
      commands = {
        toggle_comment_debug_prints = "ToggleCommentDebugPrints",
        delete_debug_prints = "DeleteDebugPrints",
      },
      filetypes = {
        ["javascript"] = jsDebugPrintFileType,
        ["javascriptreact"] = jsDebugPrintFileType,
        ["typescript"] = jsDebugPrintFileType,
        ["typescriptreact"] = jsDebugPrintFileType,
      },
      display_counter = false,
      print_tag = "<^>",
      display_snippet = false,
    },
    keys = {
      { '<leader>l', mode = 'n' },
      { '<leader>l', mode = 'x' },
    },
  },
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true,
      message_template = "<author> ┆ <date> ┆ <sha>",
      date_format = "%m-%d-%Y",
      virtual_text_column = 1,
      message_when_not_committed = 'Not Yet Committed',
      display_virtual_text = 0,
    },
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    config = function()
      local git_blame = require('gitblame')
      vim.g.gitblame_max_commit_summary_length = 12

      require('lualine').setup {
        options = {
          icons_enabled = true,
          -- theme = 'auto',
          theme = 'dracula',
          -- theme = 'fluoromachine',
          -- component_separators = '┃',
          component_separators = '',
          section_separators = '',
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' }, -- default also has: 'diff', 'diagnostics'
          lualine_c = {
            {
              'filename',
              file_status = true, -- displays file status (readonly status, modified status)
              path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
            },
          },
          lualine_x = {
            { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
            { 'filetype' }, -- default has more, simplifying
          }
        },
        inactive_sections = {
          lualine_c = { { 'filename', file_status = true, path = 0 } },
          lualine_x = { 'filetype' },
        },
        extensions = { 'nvim-tree' },
      }
    end
  },
  {
    'lukas-reineke/indent-blankline.nvim', -- Add indentation guides even on blank lines
    main = 'ibl',
    opts = {},
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      -- "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            -- ["vim.lsp.util.stylize_markdown"] = true, -- disabled for eagle.nvim stylizing
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
        cmdline = {
          view = "cmdline"
        },
      })
    end
  },
  {
    "soulis-1256/eagle.nvim",
    event = "VeryLazy",
    config = function()
      require("eagle").setup()
    end
  },
  {
    "rmagatti/goto-preview",
    event = "BufEnter",
    config = function()
      require('goto-preview').setup {
        zindex = 50,
        width = 120,
        height = 40,
        opacity = 5,
        stack_floating_preview_windows = false,
      }
    end
  },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
    config = function()
      require('treesj').setup {
        use_default_keymaps = false,
      }
      vim.keymap.set('n', '<leader>ct', '<Cmd>TSJToggle<cr>', { desc = 'treesj [t]oggle', silent = true })
      vim.keymap.set('n', '<leader>cs', '<Cmd>TSJSplit<cr>', { desc = 'treesj [s]plit', silent = true })
      vim.keymap.set('n', '<leader>cj', '<Cmd>TSJJoin<cr>', { desc = 'treesj [j]oin', silent = true })
    end,
  },
  {
    'HiPhish/rainbow-delimiters.nvim'
  }
}
