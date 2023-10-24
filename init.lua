require('plugins') 

---
-- LSP setup
---
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {'tsserver', 'eslint', 'svelte', 'rust_analyzer'},
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      -- (Optional) configure lua language server
      local lua_opts = lsp_zero.nvim_lua_ls()
      local lspconfig = require('lspconfig')
      local on_attach = require("plugins.configs.lspconfig").on_attach
      local capabilities = require("plugins.configs.lspconfig").capabilities
      local util = require "lspconfig/util"
      lspconfig.lua_ls.setup(lua_opts)
      lspconfig.rust_analyzer.setup({
	  on_attach = on_attach,
	  capabilities = capabilities,
	  filetypes = {"rust"},
	  root_dir = util.root_pattern("Cargo.toml"),
	  settings = {
	    ['rust_analyzer'] = {
	      cargo = {
		allFeatures = true,
	      },
	    },
	  },
	})
    end,
  }
})

---
-- Autocompletion config
---
local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    -- `Enter` key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    -- Ctrl+Space to trigger completion menu
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),

    -- Scroll up and down in the completion documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  })
})
