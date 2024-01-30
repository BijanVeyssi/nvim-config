return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "hrsh7th/cmp-nvim-lsp" },
        { "mfussenegger/nvim-dap" },
        { "simrat39/rust-tools.nvim" },
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
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("plugins.lsp.ui").setup()

        vim.diagnostic.config({ severity_sort = true })

        local function on_attach(client, bufnr)
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
            pyright = {},
            texlab = {},
            rnix = {},
        }

        local rt = require("rust-tools")
        rt.setup({
            server = {
                on_attach = function(client, bufnr)
                    require("plugins.lsp.keymaps").on_attach(bufnr)
                    require("plugins.lsp.ui").on_attach(client, bufnr)
                    -- Hover actions
                    vim.keymap.set(
                        "n",
                        "<C-space>",
                        rt.hover_actions.hover_actions,
                        { buffer = bufnr }
                    )
                    -- Code action groups
                    vim.keymap.set(
                        "n",
                        "<Leader>a",
                        rt.code_action_group.code_action_group,
                        { buffer = bufnr }
                    )
                end,
                settings = {
                    ["rust-analyzer"] = {
                        cargo = { features = "all" },
                        check = { allTargets = true },
                    },
                    procMacro = {
                        enable = true,
                    },
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
        })

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
