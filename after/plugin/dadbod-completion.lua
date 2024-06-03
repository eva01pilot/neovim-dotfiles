local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

-- configure manual  autocompletion
cmp.setup({
    mapping = cmp.mapping.preset.insert({
        -- tab completion
        ['<Tab>'] = cmp_action.tab_complete(),
        ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
    })
})

-- autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"sql", "mysql", "plsql"},
    callback = function()
        cmp.setup.buffer {
            sources = {
                { name = 'vim-dadbod-completion' }
            }
        }
    end,
})
