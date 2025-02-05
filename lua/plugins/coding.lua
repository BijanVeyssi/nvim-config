return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        keys = {
            { "<leader>s", desc = "start incremental selection" },
        },
        opts = {
            ensure_installed = { "lua", "vim", "vimdoc" },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<leader>s",
                    node_incremental = "<Space>",
                    scope_incremental = false,
                    node_decremental = "<BS>",
                },
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
    {
        "numToStr/Comment.nvim",
        keys = {
            { "gc", mode = { "n", "x" } },
            { "gb", mode = { "n", "x" } },
        },
        config = true,
    },
    {
        "mhartington/formatter.nvim",
        event = "BufWrite",
        keys = {
            {
                "<leader>ot",
                function()
                    vim.g.autoformat = not vim.g.autoformat
                    vim.notify(
                        "Auto format " .. (vim.g.autoformat and "enabled" or "disabled"),
                        vim.log.levels.INFO,
                        { title = "Formatter" }
                    )
                end,
                desc = "toggle",
            },
            {
                "<leader>ob",
                function()
                    local get_or_default = require("utils").get_or_default
                    vim.b.autoformat = not get_or_default(vim.b.autoformat, vim.g.autoformat)
                    vim.notify(
                        "Buffer Auto format " .. (vim.b.autoformat and "enabled" or "disabled"),
                        vim.log.levels.INFO,
                        { title = "Formatter" }
                    )
                end,
                desc = "buffer toggle",
            },
            { "<leader>of", "<Cmd>silent! Format<CR>", desc = "format" },
        },
        config = function()
            vim.g.autoformat = true

            local formatter = require("formatter")
            formatter.setup({
                filetype = {
                    lua = { require("formatter.filetypes.lua").stylua },
                    c = { require("formatter.filetypes.c").clangformat },
                    proto = { require("formatter.filetypes.proto").clangformat },
                    cpp = { require("formatter.filetypes.cpp").clangformat },
                    javascript = { require("formatter.filetypes.javascript").prettier },
                    typescript = { require("formatter.filetypes.typescript").prettier },
                    json = { require("formatter.filetypes.json").prettier },
                    yaml = { require("formatter.filetypes.yaml").prettier },
                    python = { require("formatter.filetypes.python").black },
                    rust = { require("formatter.filetypes.rust").rustfmt },
                    nix = { require("formatter.filetypes.nix").nixpkgs_fmt },
                    go = { require("formatter.filetypes.go").gofmt },
                },
            })

            vim.api.nvim_create_autocmd("BufWritePost", {
                group = vim.api.nvim_create_augroup("my_format_write", { clear = true }),
                pattern = "*",
                callback = function()
                    local get_or_default = require("utils").get_or_default
                    if get_or_default(vim.b.autoformat, vim.g.autoformat) then
                        vim.cmd("silent! FormatWrite")
                    end
                end,
            })
        end,
    },
    { -- Linting
        "mfussenegger/nvim-lint",
        event = { "BufWritePost", "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = {
                markdown = { "markdownlint" },
                sh = { "shellcheck" },
                -- proto = { "buf_lint" },
                fish = { "fish" },
                nix = { "nix" },
                -- rust = { "clippy" },
            }

            -- To allow other plugins to add linters to require('lint').linters_by_ft,
            -- instead set linters_by_ft like this:
            -- lint.linters_by_ft = lint.linters_by_ft or {}
            -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
            --
            -- However, note that this will enable a set of default linters,
            -- which will cause errors unless these tools are available:
            -- {
            --   clojure = { "clj-kondo" },
            --   dockerfile = { "hadolint" },
            --   inko = { "inko" },
            --   janet = { "janet" },
            --   json = { "jsonlint" },
            --   markdown = { "vale" },
            --   rst = { "vale" },
            --   ruby = { "ruby" },
            --   terraform = { "tflint" },
            --   text = { "vale" }
            -- }
            --
            -- You can disable the default linters by setting their filetypes to nil:
            -- lint.linters_by_ft['clojure'] = nil
            -- lint.linters_by_ft['dockerfile'] = nil
            -- lint.linters_by_ft['inko'] = nil
            -- lint.linters_by_ft['janet'] = nil
            -- lint.linters_by_ft['json'] = nil
            -- lint.linters_by_ft['markdown'] = nil
            -- lint.linters_by_ft['rst'] = nil
            -- lint.linters_by_ft['ruby'] = nil
            -- lint.linters_by_ft['terraform'] = nil
            -- lint.linters_by_ft['text'] = nil

            -- Create autocommand which carries out the actual linting
            -- on the specified events.
            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = lint_augroup,
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
}
