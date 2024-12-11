return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "gopls",
                "yamlls",
                "pyright",
                "bashls",
            },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,

                ["yamlls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.yamlls.setup({
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
                                format = {
                                    enable = true,
                                },
                                validate = true,
                                hover = true,
                                completion = true,
                                maxItemsComputed = 10000,
                                trace = {
                                    server = "verbose",
                                },
                            },
                        },
                    })
                end,

                ["pyright"] = function()
                    require("lspconfig").pyright.setup {
                        capabilities = capabilities,
                        settings = {
                            python = {
                                analysis = {
                                    autoImportCompletions = true,
                                    diagnosticMode = "workspace",
                                    useLibraryCodeForTypes = true,
                                },
                            },
                        },
                    }
                end,

                ["bashls"] = function()
                    require("lspconfig").bashls.setup({
                        capabilities = capabilities,
                    })
                end,
            }
        })

        vim.api.nvim_set_keymap("n", "<leader>fa", ":lua vim.lsp.buf.format({ async = true })<CR>",
            { noremap = true, silent = true })
        vim.api.nvim_set_keymap("v", "<leader>fs", ":lua vim.lsp.buf.format({ async = true })<CR>",
            { noremap = true, silent = true })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<TAB>'] = cmp.mapping.select_next_item(cmp_select),
                ["<C-Space>"] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
