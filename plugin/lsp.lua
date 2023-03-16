local lsp = require('lsp-zero')

lsp.preset('recommended')
lsp.setup()

lsp.configure('lua-language-server', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

vim.diagnostic.config({
    virtual_text = true
})
