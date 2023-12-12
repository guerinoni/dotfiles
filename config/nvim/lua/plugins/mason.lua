return {
  "williamboman/mason.nvim",
  
  build = ":MasonInstallAll",
  event = "VeryLazy",

  config = function()
    require("mason").setup({
      ui = {
          icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗"
          }
      }     
  })
  vim.api.nvim_create_user_command("MasonInstallAll", function()
    vim.cmd('MasonUpdate')
    local ensure_installed = {
      "lua-language-server",
      "shellcheck",
      "gopls",
    }
    vim.cmd('MasonInstall ' .. table.concat(ensure_installed, ' '))
  end, { desc = "install all lsp tools" })
  end,
}
