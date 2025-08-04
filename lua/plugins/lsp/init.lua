return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "hrsh7th/cmp-nvim-lsp" },
        { "mfussenegger/nvim-dap" },
        {
            "mrcjkb/rustaceanvim",
            version = "^6", -- Recommended
            lazy = false, -- This plugin is already lazy
        },
        {
            "folke/neodev.nvim",
            config = true,
        },
        {
            "kosayoda/nvim-lightbulb",
            opts = {
                sign = { enabled = false },
                virtual_text = {
                    enabled = true,
                    text = "",
                },
                autocmd = { enabled = true },
            },
        },
        {
            "j-hui/fidget.nvim",
            tag = "legacy",
            opts = {
                text = {
                    spinner = "dots",
                    done = "",
                },
            },
        },
        {
            "felpafel/inlay-hint.nvim",
            event = "LspAttach",
            config = true,
        },
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("plugins.lsp.ui").setup()

        vim.diagnostic.config({ severity_sort = true })

        local function on_attach(client, bufnr)
            if vim.lsp.inlay_hint then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end
            require("plugins.lsp.keymaps").on_attach(bufnr)
            require("plugins.lsp.ui").on_attach(client, bufnr)
        end

        local servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                    },
                },
            },
            clangd = {
                filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
                capabilities = {
                    textDocument = {
                        semanticHighlightingCapabilities = {
                            semanticHighlighting = true,
                        },
                        completion = {
                            completionItem = {
                                snippetSupport = false,
                            },
                        },
                    },
                },
            },
            basedpyright = {},
            texlab = {},
            rnix = {},
            pbls = {},
        }

        vim.g.rustaceanvim = {
            -- Plugin configuration
            tools = {},
            -- LSP configuration
            server = {
                on_attach = on_attach,
                default_settings = {
                    -- rust-analyzer language server configuration
                    ["rust-analyzer"] = {
                        trace = {
                            extension = false,
                        },
                        -- diagnostics = {disabled = {"unresolved-macro-call"}},
                        cargo = {
                            -- target = "x86_64-unknown-linux-gnu",
                            targetDir = true,
                            -- features = { 'all' },
                            -- features = { 'host' },
                            allFeatures = true,
                        },

                        -- cargo = { features = 'all' },
                        checkOnSave = true,
                        check = {
                            workspace = true,
                            allFeatures = true,
                            allTargets = true,
                            command = "clippy",
                            extraArgs = {
                                "--",
                                "--no-deps",
                                "-Wclippy::correctness",
                                "-Wclippy::complexity",
                                "-Wclippy::perf",
                            },
                        },
                    },
                    procMacro = {
                        enable = true,
                    },
                },
                -- debugging stuff
                dap = {
                    adapter = {
                        type = "executable",
                        command = "lldb-vscode",
                        name = "rt_lldb",
                    },
                },
            },
        }

        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local lspconfig = require("lspconfig")
        for server, config in pairs(servers) do
            lspconfig[server].setup(vim.tbl_deep_extend("force", {
                on_attach = on_attach,
                capabilities = vim.deepcopy(capabilities),
            }, config))
        end
    end,
}
