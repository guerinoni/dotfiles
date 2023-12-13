return {
  "williamboman/mason.nvim",
  
  event = "BufReadPre",

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
  end,
}
