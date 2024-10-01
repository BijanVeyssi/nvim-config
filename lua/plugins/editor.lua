return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            local wk = require("which-key")
            wk.setup()
            local keymaps = {
                { "<leader>d", group = "debugger" },
                { "<leader>f", group = "file/find" },
                { "<leader>l", group = "lsp" },
                { "<leader>o", group = "format" },
                { "<leader>p", group = "pdf" },
                { "<leader>t", group = "tree" },
                { "gb", group = "blockwise comment" },
                { "gc", group = "linewise comment" },
                { "gb", desc = "blockwise comment", mode = "x" },
                { "gc", desc = "linewise comment", mode = "x" },
            }
            wk.add(keymaps)
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            { "nvim-tree/nvim-web-devicons" },
        },
        cmd = "Telescope",
        keys = function()
            local telescope = require("utils").telescope

            return {
                { "<leader>ff", telescope("find_files"), desc = "files" },
                { "<leader>fg", telescope("git_files"), desc = "git files" },
                { "<leader>fr", telescope("live_grep"), desc = "grep" },
                { "<leader>fb", telescope("buffers"), desc = "buffers" },
                { "<leader>fc", telescope("colorscheme"), desc = "colorscheme" },
                { "<leader>fh", telescope("oldfiles"), desc = "history" },
            }
        end,
        config = function()
            local telescope = require("telescope")
            telescope.setup()
            telescope.load_extension("fzf")
        end,
    },
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
        keys = {
            { "<leader>tt", "<Cmd>NvimTreeToggle<CR>", desc = "toggle" },
            { "<leader>tf", "<Cmd>NvimTreeFocus<CR>", desc = "focus" },
            { "<leader>tr", "<Cmd>NvimTreeRefresh<CR>", desc = "refresh" },
            { "<leader>to", "<Cmd>NvimTreeFindFile<CR>", desc = "find opened file" },
        },
        opts = {
            actions = {
                open_file = { quit_on_open = true },
            },
            git = { ignore = true },
            renderer = {
                highlight_git = true,
                icons = {
                    show = {
                        git = false,
                        folder = true,
                        file = true,
                        folder_arrow = true,
                    },
                },
            },
        },
    },
    {
        "echasnovski/mini.diff",
        version = false,
        dependencies = {},
        keys = {},
        config = function()
            require("mini.diff").setup()
        end,
    },
    {
        "f-person/git-blame.nvim",
        dependencies = {},
        keys = {
            { "<leader>bt", "<Cmd>GitBlameToggle<CR>", desc = "Blame toggle" },
            { "<leader>bo", "<Cmd>GitBlameOpenCommitURL<CR>", desc = "Open in browser" },
            { "<leader>bc", "<Cmd>GitBlameCopySHA<CR>", desc = "Copy SHA1" },
        },
        config = function()
            require("gitblame").setup({
                enabled = false,
                message_template = "  <author> • <date> • <summary>",
            })
        end,
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim", -- optional
            "ibhagwan/fzf-lua", -- optional
        },
        cmd = "Neogit",
        keys = {
            { "<leader>g", "<Cmd>Neogit<CR>", desc = "neogit" },
        },
        opts = {
            disable_builtin_notifications = true,
        },
    },
    {
        "andythigpen/nvim-coverage",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
        },
        cmd = "Coverage",
        keys = function() end,

        config = function()
            require("coverage").setup({
                commands = true, -- create commands
                highlights = {
                    -- customize highlight groups created by the plugin
                    covered = { fg = "#C3F88D" }, -- supports style, fg, bg, sp (see :h highlight-gui)
                    uncovered = { fg = "#F04148" },
                },
                signs = {
                    -- use your own highlight groups or text markers
                    covered = { hl = "CoverageCovered", text = "█" },
                    uncovered = { hl = "CoverageUncovered", text = "█" },
                },
                summary = {
                    -- customize the summary pop-up
                    min_coverage = 80.0, -- minimum coverage threshold (used for highlighting)
                },
                lang = {
                    -- customize language specific settings
                    rust = {
                        coverage_command = "grcov ${cwd} -s ${cwd} --binary-path ./target/debug/ -t coveralls --branch --ignore-not-existing --token NO_TOKEN",
                        project_files_only = true,
                    },
                },
            })
        end,
    },
}
