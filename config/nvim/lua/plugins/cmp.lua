return {
  'hrsh7th/nvim-cmp',

  event = "InsertEnter",

  dependencies = {
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
  },

  config = function()
    local cmp = require("cmp")
    local types = require('cmp.types')

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            local entry = cmp.get_selected_entry()
            if not entry then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              cmp.confirm()
            end
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true })
            else
              fallback()
            end
          end,
          s = cmp.mapping.confirm({ select = true }),
        }),
        ["<Down>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<Up>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-e>"] = cmp.mapping(cmp.mapping.abort(), { "i", "s" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "s" }),
        ["<PageUp>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "s" }),
        ["<PageDown>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "s" }),
      },
      preselect = types.cmp.PreselectMode.None,
      formatting = {
        format = function(_, vim_item)
          print(vim_item.word)
          vim_item.abbr = string.sub(vim_item.abbr, 1, 200)
          return vim_item
        end
      },
      sources = cmp.config.sources({
        { name = "nvim_lsp", group_index = 1 },
        { name = "path", group_index = 2 },
        { name = "nvim_lua", group_index = 2 },
        { name = "buffer", keyword_length = 5, group_index = 3 },
      }),
    })
  end,
}
