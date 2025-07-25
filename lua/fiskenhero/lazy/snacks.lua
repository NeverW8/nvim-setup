return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        -- enable syntax/errors inlay Hints
        inlay_hints = { enabled = true },
        bigfile = { enabled = true },
        dashboard = { enabled = true },
        explorer = { enabled = false },
        indent = { enabled = true },
        input = { enabled = true },
        notifier = {
            enabled = true,
            timeout = 3000,
        },
        picker = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        styles = {
            notification = {
                -- wo = { wrap = true } -- enable if you want wrapped notification lines
            },
        },
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Debugging helpers
                _G.dd = function(...)
                    require("snacks").debug.inspect(...)
                end
                _G.bt = function()
                    require("snacks").debug.backtrace()
                end
                vim.print = _G.dd

                local Snacks = require("snacks")

                -- Toggle keymaps
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                Snacks.toggle.option("wrap", { name = "Line Wrap" }):map("<leader>uw")
                Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
                Snacks.toggle.diagnostics({ name = "Diagnostics" }):map("<leader>ud")
                Snacks.toggle.line_number({ name = "Line Numbers" }):map("<leader>ul")
                Snacks.toggle.option("conceallevel", {
                    name = "Conceal",
                    off = 0,
                    on = (vim.o.conceallevel > 0 and vim.o.conceallevel or 2),
                }):map("<leader>uc")
                Snacks.toggle.treesitter({ name = "Treesitter" }):map("<leader>uT")
                Snacks.toggle.option("background", {
                    name = "Dark Background",
                    off = "light",
                    on = "dark",
                }):map("<leader>ub")
                Snacks.toggle.inlay_hints({ name = "Inlay Hints" }):map("<leader>uh")
                Snacks.toggle.indent({ name = "Indent Guides" }):map("<leader>ug")
                Snacks.toggle.dim({ name = "Dim Inactive" }):map("<leader>uD")
            end,
        })
    end,
}
