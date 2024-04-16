-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { 'rmagatti/session-lens' }, -- no shortcut key bound yet, launch with :SearchSession
  { 'windwp/nvim-ts-autotag' }, -- open/close html/jsx tags together
  { 'terrortylor/nvim-comment' }, -- add commenter
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
          width = 39,
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
    'tzachar/local-highlight.nvim',
    config = function()
      require('local-highlight').setup {
        file_types = { 'javascript', 'typescript', 'html', 'css', 'scss' },
        hlgroup = 'Search',
        cw_hlgroup = nil,
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
    dependencies = {
      'nvim-treesitter/nvim-treesitter'
    },
    config = function()
      local js = {
        left = 'console.log("',
        right = '")',
        mid_var = '", ',
        right_var = ")",
      }
      require("debugprint").setup {
        filetypes = {
          ["javascript"] = js,
          ["javascriptreact"] = js,
          ["typescript"] = js,
          ["typescriptreact"] = js,
        },
        display_counter = false,
        print_tag = "",
        display_snippet = false,
      }
      vim.keymap.set({'x','n'}, '<leader>ll',
        function()
          return require('debugprint').debugprint({ variable = true })
        end,
        { desc = 'Console [L]og variable', expr = true }
      )
    end,
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        -- theme = 'auto',
        theme = 'dracula',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' }, -- default also has: 'diff', 'diagnostics'
        lualine_c = {
          {
            'filename',
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
          },
        },
        lualine_x = { 'filetype' }, -- default has more, simplifying
      },
      inactive_sections = {
        lualine_c = { { 'filename', file_status = true, path = 1 } },
      },
      extensions = { 'nvim-tree' },
    },
  },
  {
    'lukas-reineke/indent-blankline.nvim', -- Add indentation guides even on blank lines
    main = 'ibl',
    opts = {},
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim", -- optional for floating window border decoration
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "Lazy[G]it" }
    }
  },
}
