return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "williamboman/mason.nvim", opts = {} },
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",

        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",

        { "j-hui/fidget.nvim",       opts = {} },
    },

    config = function()
        -- Setup mason and tools
        require("mason").setup()
        require("mason-tool-installer").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "gopls",
                "yamlls",
                "pyright",
                "bashls",
                "stylua",
                "prettierd",
            }
        })

        -- Setup capabilities (nvim-cmp integration)
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        -- LSP setup
        require("mason-lspconfig").setup({
            automatic_installation = false,
            handlers = {
                -- Default handler for all servers
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                    })
                end,

                -- yamlls with K8s schemas
                ["yamlls"] = function()
                    require("lspconfig").yamlls.setup({
                        capabilities = capabilities,
                        settings = {
                            yaml = {
                                schemas = {
                                    kubernetes = "*.yaml",
                                    ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                                    ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                                    ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                                    ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                                    ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                                    ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                                    ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                                    ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                                    ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
                                    ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] =
                                    "*api*.{yml,yaml}",
                                    ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
                                    "*docker-compose*.{yml,yaml}",
                                    ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] =
                                    "*flow*.{yml,yaml}",
                                },
                                format = { enable = true },
                                validate = true,
                                hover = true,
                                completion = true,
                                maxItemsComputed = 10000,
                                trace = { server = "verbose" },
                            },
                        },
                    })
                end,
            },
        })

        -- Keybindings for LSP
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(event)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
                map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
                map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
                map("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
                map("<leader>cr", vim.lsp.buf.rename, "[R]e[n]ame")
                map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
                map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                vim.keymap.set("n", "<leader>fa", function()
                    vim.lsp.buf.format({ async = true })
                end, { buffer = event.buf, desc = "[F]ormat [A]ll" })

                vim.keymap.set("v", "<leader>fs", function()
                    vim.lsp.buf.format({ async = true })
                end, { buffer = event.buf, desc = "[F]ormat [S]election" })
            end
        })

        -- Diagnostic config
        vim.diagnostic.config({
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
            virtual_text = {
                prefix = "●",
                format = function(diagnostic)
                    local severity_map = {
                        [vim.diagnostic.severity.ERROR] = "Error: ",
                        [vim.diagnostic.severity.WARN] = "Warning: ",
                        [vim.diagnostic.severity.INFO] = "Info: ",
                        [vim.diagnostic.severity.HINT] = "Hint: ",
                    }
                    local prefix = severity_map[diagnostic.severity] or ""
                    return prefix .. diagnostic.message
                end,
            },
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
        })

        -- Completion setup
        local cmp = require("cmp")
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
            }, {
                { name = "buffer" },
            }),
        })
    end,
}
