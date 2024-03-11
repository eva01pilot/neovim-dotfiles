local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
  'tsserver',
  'rust_analyzer',
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()


local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
  suggest_lsp_servers = false,
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
  }
})

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  --client.resolved_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
  virtual_text = true
})
lsp.set_server_config({
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true
      }
    }
  }
})


local nvim_lsp = require "lspconfig"
nvim_lsp.tailwindcss.setup {
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          { "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" }
        },
      },
    },
  },
}
require "cmp".setup {
    sources = {
        {
            name = "nvim_lsp",
            entry_filter = function(entry)
                return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
            end
        },
    }
}



local result = vim.fn.systemlist("npm ls -g --depth=0")
local location = string.format("%s/node_modules/@vue/typescript-plugin", result[1])

-- if using mason, uncomment lines below
-- local is_mason = pcall(require, "mason")
-- location = is_mason and vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin"

if vim.fn.isdirectory(location) == 1 then
  -- Ensure @vue/typescript-plugin is installed
  -- before setting up tsserver
  require("lspconfig").tsserver.setup({
    -- on_attach = on_attach,
    -- capabilities = capabilities,
    root_dir = require("lspconfig.util").root_pattern("src/App.vue", "nuxt.config.ts", "nuxt.config.js"),
    filetypes = { "vue", "typescript", "javascript", "json" },
    init_options = {
      plugins = {
        {
          name = "@vue/typescript-plugin",
          location = location,
          languages = { "vue" },
        },
      },
    },
  })
else
  vim.api.nvim_err_writeln(
    "@vue/typescript-plugin is required, install globally via `npm install -g @vue/typescript-plugin`"
  )
end
