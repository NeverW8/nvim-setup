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
                    ["<leader>fc"] = "cheatsheet",
                }
            })
        end
    }
}

return local_plugins

