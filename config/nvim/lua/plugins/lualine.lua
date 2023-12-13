return {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  dependencies = {
    'arkav/lualine-lsp-progress',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    options = {
      section_separators = ' ',
      component_separators = ' ',
      globalstatus = true,
      theme = 'auto',
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch' },
      lualine_c = {
        'filepath',
        {
          'filename',
          file_status = true,
          path = 1,
        },
      },
      lualine_x = {
        {
          require("lazy.status").updates,
          cond = require("lazy.status").has_updates,
          color = { fg = "#ff9e64" },
        },
      },
      lualine_y = {
        'filetype',
        'encoding',
        'fileformat',
        '(vim.bo.expandtab and "␠ " or "⇥ ") .. vim.bo.shiftwidth',
      },
      lualine_z = {
        'searchcount',
        'selectioncount',
        'location',
        'progress',
      },
    },
  },
}
