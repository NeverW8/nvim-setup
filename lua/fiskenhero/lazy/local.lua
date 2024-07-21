local local_plugins = {
    {
        "sudormrfbin/cheatsheet.nvim",
        config = function()
            require("cheatsheet").setup({
                bundled_cheatsheets = {
                    enabled = { "default" },
                },
                bundled_plugin_cheatsheets = true,
                include_only_installed_plugins = true,
                telescope_mappings = {
                    ["<leader>fc"] = "Cheatsheet",
                }
            })
        end
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup({
                signs = true,
                keywords = {
                    FIX = { icon = " ", color = "error" },
                    TODO = { icon = " ", color = "info" },
                    HACK = { icon = " ", color = "warning" },
                    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
                },
            })
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "+" },
                    change = { text = "~" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                },
                current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
            })
        end
    }
}

return local_plugins


