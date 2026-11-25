-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

vim.keymap.set('n', '<leader>t', '<Cmd>Neotree toggle reveal<CR>', { desc = '[T]oggle NeoTree', silent = true })

require('neo-tree').setup {
  filesystem = {
    follow_current_file = { enabled = true },
    window = {
      mappings = {
        ['<leader>t'] = 'close_window',
      },
    },
  },
}
