-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
local jsDebugPrintFileType = {
  left = 'console.log("',
  right = '")',
  mid_var = '", ',
  right_var = ')',
}

return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {},
  },
  {
    'rmagatti/session-lens',
    cond = not vim.g.vscode,
  }, -- no shortcut key bound yet, launch with :SearchSession
  {
    'numToStr/Comment.nvim',
    cond = not vim.g.vscode,
    config = function()
      require('Comment').setup {
        toggler = {
          line = '<leader>cc',
          block = '<leader>cb',
        },
        opleader = {
          line = '<leader>cc',
          block = '<leader>cb',
        },
        extra = {
          above = '<leader>cO',
          below = '<leader>co',
          eol = '<leader>cA',
        },
      }
    end,
  }, -- add commenter
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup {
        opts = {
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = false, -- Auto close on trailing </
        },
      }
    end,
  }, -- open/close html/jsx tags together
  {
    'dstein64/nvim-scrollview',
    cond = not vim.g.vscode,
    dependencies = { 'lewis6991/gitsigns.nvim' },
    config = function()
      require('scrollview').setup {
        excluded_filetypes = { 'NvimTree' },
        winblend = 50,
        signs_on_startup = { 'all' },
      }
      require('scrollview.contrib.gitsigns').setup()
    end,
  }, -- adds scrollbar to the right
  {
    'declancm/cinnamon.nvim',
    cond = not vim.g.vscode,
    config = function()
      require('cinnamon').setup {
        keymaps = {
          basic = true,
          extra = true,
        },
      }
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    cond = not vim.g.vscode,
    config = function()
      require('nvim-tree').setup {
        on_attach = function(bufnr)
          local api = require 'nvim-tree.api'
          api.config.mappings.default_on_attach(bufnr)
          vim.keymap.set('n', '<Esc>', api.tree.close, { buffer = bufnr, desc = 'Close', nowait = true })

          -- when float, close the tree after opening a file instead of leaving it open
          local function keep_float_focus(open_fn)
            return function()
              local tree_view = require 'nvim-tree.view'
              local winnr = tree_view.get_winnr()
              local was_float = winnr and vim.api.nvim_win_get_config(winnr).relative ~= ''
              open_fn()
              if was_float then
                tree_view.close()
              end
            end
          end
          vim.keymap.set('n', '<CR>', keep_float_focus(api.node.open.edit), { buffer = bufnr, desc = 'Open', nowait = true })
          vim.keymap.set('n', 'o', keep_float_focus(api.node.open.edit), { buffer = bufnr, desc = 'Open', nowait = true })
          vim.keymap.set('n', '<2-LeftMouse>', keep_float_focus(api.node.open.edit), { buffer = bufnr, desc = 'Open', nowait = true })
          vim.keymap.set('n', '<C-v>', keep_float_focus(api.node.open.vertical), { buffer = bufnr, desc = 'Open: Vertical Split', nowait = true })
          vim.keymap.set('n', '<C-x>', keep_float_focus(api.node.open.horizontal), { buffer = bufnr, desc = 'Open: Horizontal Split', nowait = true })

          vim.keymap.set('n', '<Tab>', function()
            local node = api.tree.get_node_under_cursor()
            if not node or node.type ~= 'file' then
              return
            end
            local buf = vim.fn.bufadd(node.absolute_path)
            vim.fn.bufload(buf)
            Snacks.win.new {
              buf = buf,
              width = 0.7,
              height = 0.8,
              border = 'rounded',
              wo = { number = true, relativenumber = false, signcolumn = 'no' },
              keys = { q = 'close', ['<Esc>'] = 'close' },
            }
          end, { buffer = bufnr, desc = 'Preview file', nowait = true })
        end,
        view = {
          width = 60,
          side = 'right',
          float = {
            enable = false,
            quit_on_focus_loss = true,
            open_win_config = function()
              local screen_w = vim.opt.columns:get()
              local screen_h = vim.opt.lines:get()
              local width = math.floor(screen_w * 0.4)
              local height = math.floor(screen_h * 0.8)
              return {
                relative = 'editor',
                border = 'rounded',
                width = width,
                height = height,
                row = math.floor((screen_h - height) / 2),
                col = math.floor((screen_w - width) / 2),
              }
            end,
          },
        },
        update_focused_file = {
          enable = true,
          update_root = {
            enable = false,
            ignore_list = {},
          },
        },
        ui = {
          confirm = {
            remove = true, -- user confirmation when using removing ("d") on an item
          },
        },
        tab = {
          sync = {
            open = true,
            close = true,
          },
        },
      }
      require('nvim-tree.api').events.subscribe(require('nvim-tree.api').events.Event.TreeClose, function()
        require('nvim-tree.config').g.view.float.enable = false
      end)
      local nvim_tree_toggle = function()
        local api = require 'nvim-tree.api'
        if not api.tree.is_visible() then
          api.tree.open()
        elseif vim.bo.filetype == 'NvimTree' then
          api.tree.close()
        else
          api.tree.focus()
        end
      end
      vim.keymap.set('n', '<leader>t', nvim_tree_toggle, { desc = 'File Tree smart toggle', silent = true })
    end,
  }, -- add file directory explorer
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  },
  {
    'nanozuki/tabby.nvim',
    event = 'VimEnter',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('tabby').setup {
        preset = 'tab_only',
        option = {
          nerdfont = true,
          lualine_theme = 'dracula',
          buf_name = {
            mode = 'tail', -- mode = "'unique'|'relative'|'tail'|'shorten'",
          },
        },
      }

      -- tabby keymaps:
      local bufferMap = vim.api.nvim_set_keymap
      local bufferOpts = { noremap = true, silent = true }
      -- Move to previous/next
      bufferMap('n', '<A-t>', '<Cmd>tabnew<CR>', bufferOpts)
      bufferMap('n', '<A-w>', '<Cmd>tabclose<CR>', bufferOpts)
      bufferMap('n', '<A-a>', '<Cmd>tabp<CR>', bufferOpts)
      bufferMap('n', '<A-d>', '<Cmd>tabn<CR>', bufferOpts)
      bufferMap('n', '<A-q>', '<Cmd>-tabmove<CR>', bufferOpts)
      bufferMap('n', '<A-e>', '<Cmd>+tabmove<CR>', bufferOpts)
      bufferMap('n', '<A-r>', ':Tabby rename_tab ', bufferOpts)
    end,
  },
  {
    'rmagatti/auto-session',
    cond = not vim.g.vscode,
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
        use_git_branch = true,
        post_restore_cmds = { change_nvim_tree_dir, 'NvimTreeOpen' },
        pre_save_cmds = { 'NvimTreeClose' },
      }
    end,
  },
  {
    'windwp/nvim-autopairs',
    cond = not vim.g.vscode,
    config = function()
      require('nvim-autopairs').setup {}
    end,
  }, -- open/close parens/brackets together
  {
    'andrewferrier/debugprint.nvim',
    cond = not vim.g.vscode,
    opts = {
      keymaps = {
        normal = {
          variable_below = '<leader>ll',
          variable_above = '<leader>lL',
          delete_debug_prints = '<leader>ld',
        },
      },
      commands = {
        toggle_comment_debug_prints = 'ToggleCommentDebugPrints',
        delete_debug_prints = 'DeleteDebugPrints',
      },
      filetypes = {
        ['javascript'] = jsDebugPrintFileType,
        ['javascriptreact'] = jsDebugPrintFileType,
        ['typescript'] = jsDebugPrintFileType,
        ['typescriptreact'] = jsDebugPrintFileType,
      },
      display_counter = false,
      print_tag = '<^>',
      display_snippet = false,
    },
    keys = {
      { '<leader>l', mode = 'n' },
      { '<leader>l', mode = 'x' },
    },
  },
  {
    'f-person/git-blame.nvim',
    cond = not vim.g.vscode,
    event = 'VeryLazy',
    opts = {
      enabled = true,
      message_template = '<author> ┆ <date>',
      -- date_format = '%m-%d-%Y',
      date_format = '%r',
      virtual_text_column = 80,
      message_when_not_committed = 'Not Yet Committed',
      display_virtual_text = 0,
    },
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    cond = not vim.g.vscode,
    -- See `:help lualine.txt`
    config = function()
      local git_blame = require 'gitblame'
      vim.g.gitblame_max_commit_summary_length = 12
      local grapple = 'grapple'

      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'dracula',
          component_separators = '',
          section_separators = '',
        },
        sections = {
          lualine_a = { 'branch' },
          lualine_b = {
            grapple,
            {
              'filename',
              file_status = true, -- displays file status (readonly status, modified status)
              path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
            },
          }, -- default also has: 'diff', 'diagnostics'
          lualine_c = {},
          lualine_x = {
            { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
            { 'filetype' }, -- default has more, simplifying
          },
        },
        inactive_sections = {
          lualine_c = { grapple, { 'filename', file_status = true, path = 0 } },
          lualine_x = { 'filetype' },
        },
        extensions = { 'nvim-tree' },
      }
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim', -- Add indentation guides even on blank lines
    cond = not vim.g.vscode,
    main = 'ibl',
    opts = {},
  },
  {
    'folke/noice.nvim',
    cond = not vim.g.vscode,
    event = 'VeryLazy',
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      -- 'rcarriga/nvim-notify',
    },
    config = function()
      require('noice').setup {
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            -- ["vim.lsp.util.stylize_markdown"] = true, -- disabled for eagle.nvim stylizing
            ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
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
          view = 'cmdline',
        },
      }
    end,
  },
  -- {
  --   'soulis-1256/eagle.nvim',
  --   event = 'VeryLazy',
  --   config = function()
  --     require('eagle').setup {
  --       show_headers = false,
  --       border = 'rounded',
  --     }
  --   end,
  -- },
  {
    'rmagatti/goto-preview',
    cond = not vim.g.vscode,
    dependencies = { 'rmagatti/logger.nvim' },
    event = 'VeryLazy',
    opts = {
      zindex = 50,
      width = 150,
      height = 45,
      opacity = 0,
      stack_floating_preview_windows = false,
      border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }, -- Border characters of the floating window
    },
    config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
  },
  {
    'Wansmer/treesj',
    cond = not vim.g.vscode,
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
    'HiPhish/rainbow-delimiters.nvim',
    cond = not vim.g.vscode,
  },
  {
    'cbochs/grapple.nvim',
    cond = not vim.g.vscode,
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', lazy = true },
    },
    opts = {
      scope = 'git_branch', -- git, git_branch
    },
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = 'Grapple',
    keys = {
      { '<A-m>', '<cmd>Grapple<cr>', desc = '[M]ark file for Grapple' },
      { '<A-n>', '<cmd>Grapple cycle_tags next<cr>', desc = 'Grapple cycle next tag' },
      { '<A-p>', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Grapple cycle previous tag' },
      { '<A-S-m>', '<cmd>Grapple reset<cr>', desc = 'Reset Grapple [M]arks' },
      { '<leader>sm', '<cmd>Telescope grapple tags<cr>', desc = '[S]earch for Grapple [M]arked tags' },
    },
  },
  -- {
  --   'pmizio/typescript-tools.nvim',
  --   dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  --   opts = {},
  -- },
  {
    'coder/claudecode.nvim',
    cond = not vim.g.vscode,
    dependencies = { 'folke/snacks.nvim' },
    opts = {
      terminal = {
        provider = 'snacks',
        snacks_win_opts = {
          position = 'left',
          width = 0.25,
          border = 'rounded',
          wo = {
            winfixwidth = true,
          },
          keys = {
            claude_hide = {
              '<C-,>',
              function(self)
                vim.g.claude_panel_open = false
                self:hide()
              end,
              mode = 't',
              desc = 'Hide',
            },
            claude_focus_prev = {
              '<C-l>',
              function()
                vim.cmd 'wincmd l'
              end,
              mode = 't',
              desc = 'Focus previous window',
            },
          },
        },
      },
    },
    config = function(_, opts)
      require('claudecode').setup(opts)

      local claude_augroup = vim.api.nvim_create_augroup('ClaudePanelTabPersist', { clear = true })

      vim.api.nvim_create_autocmd('TabLeave', {
        group = claude_augroup,
        callback = function()
          if not vim.g.claude_panel_open then
            return
          end
          local ok, term_mod = pcall(require, 'claudecode.terminal')
          if not ok then
            return
          end
          local bufnr = term_mod.get_active_terminal_bufnr and term_mod.get_active_terminal_bufnr()
          if not bufnr then
            return
          end
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_buf(win) == bufnr then
              vim.api.nvim_win_close(win, false)
              break
            end
          end
        end,
      })

      vim.api.nvim_create_autocmd('TabEnter', {
        group = claude_augroup,
        callback = function()
          if not vim.g.claude_panel_open then
            return
          end
          if vim.fn.exists ':ClaudeCodeFocus' ~= 2 then
            return
          end
          local ok, term_mod = pcall(require, 'claudecode.terminal')
          if not ok then
            return
          end
          local bufnr = term_mod.get_active_terminal_bufnr and term_mod.get_active_terminal_bufnr()
          if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
            vim.g.claude_panel_open = false
            return
          end
          local prev_win = vim.api.nvim_get_current_win()
          vim.cmd 'ClaudeCodeFocus'
          vim.schedule(function()
            vim.cmd 'wincmd ='
            if vim.api.nvim_win_is_valid(prev_win) then
              vim.api.nvim_set_current_win(prev_win)
            end
            vim.cmd 'stopinsert'
          end)
        end,
      })
    end,
    keys = {
      {
        '<leader>a',
        function()
          local term = require 'claudecode.terminal'
          if not vim.g.claude_launched then
            vim.g.claude_launched = true
            vim.g.claude_panel_open = true
            vim.cmd 'ClaudeCode --continue'
          else
            term.simple_toggle()
            local bufnr = term.get_active_terminal_bufnr and term.get_active_terminal_bufnr()
            local visible = false
            if bufnr then
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_get_buf(win) == bufnr then
                  visible = true
                  break
                end
              end
            end
            vim.g.claude_panel_open = visible
          end
          vim.schedule(function()
            vim.cmd 'wincmd ='
          end)
        end,
        desc = 'Claude Code',
        mode = { 'n', 'x' },
      },
    },
  },
  {
    'rachartier/tiny-code-action.nvim',
    cond = not vim.g.vscode,
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope.nvim' },
    },
    event = 'LspAttach',
    opts = {},
    config = function()
      vim.keymap.set('n', '<leader>ca', function()
        require('tiny-code-action').code_action()
      end, { noremap = true, silent = true })
    end,
  },
}
