return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000, -- load before everything else
        opts = {
            style = "storm",
            on_highlights = function(hl, colors)
                hl.TabLine = { bg = colors.bg_statusline, fg = colors.fg_gutter }
                hl.TabLineSel = { bg = colors.bg_statusline, fg = colors.fg }
            end,
        },
        config = function(_, opts)
            local tokyonight = require("tokyonight")
            tokyonight.setup(opts)
            tokyonight.load()
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cond = not vim.g.started_by_firenvim,
        event = "VeryLazy",
        opts = {
            options = {
                theme = "tokyonight",
                section_separators = {
                    left = "",
                    right = "",
                },
                component_separators = {
                    left = "",
                    right = "",
                },
            },
        },
    },
    {
        "TimotheeDesveaux/luatab.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "TabEnter",
        config = true,
    },
    {
        "rcarriga/nvim-notify",
        lazy = true,
        keys = {
            {
                "<leader>n",
                function()
                    require("notify").dismiss()
                end,
                desc = "dismiss notifications",
            },
        },
        init = function()
            vim.notify = function(...)
                return require("notify")(...)
            end
        end,
    },
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            -- Set header
            dashboard.section.header.val = {
                " ███╗   ██╗███████╗ ██████╗ ██╗   ██╗   ██╗███╗   ███╗ ",
                " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██╗██║████╗ ████║ ",
                " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║╚═╝██║██╔████╔██║ ",
                " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██╗██║██║╚██╔╝██║ ",
                " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ╚═╝██║██║ ╚═╝ ██║ ",
                " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝     ╚═╝╚═╝     ╚═╝ ",
            }

            -- Set menu
            dashboard.section.buttons.val = {
                dashboard.button("e", "  > New file", "<Cmd>ene<CR>"),
                dashboard.button("f", "  > Find file", "<Cmd>Telescope find_files<CR>"),
                dashboard.button("r", "  > Find word", "<Cmd>Telescope live_grep<CR>"),
                dashboard.button("t", "פּ  > File explorer", "<Cmd>NvimTreeOpen<CR>"),
                dashboard.button("s", "  > Settings", "<Cmd>e $MYVIMRC | cd %:p:h<CR>"),
                dashboard.button("u", "  > Update plugins", "<Cmd>Lazy update<CR>"),
                dashboard.button("g", "  > Neogit", "<Cmd>Neogit<CR>"),
                dashboard.button("q", "  > Quit NVIM", "<Cmd>qa<CR>"),
            }

            local function footer()
                local config = require("lazy.core.config")
                local plugins = vim.tbl_values(config.plugins)
                return #plugins .. " plugins total"
            end
            dashboard.section.footer.val = footer()

            alpha.setup(dashboard.opts)
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        dependencies = {
            url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
        },
        event = { "BufReadPost", "BufNewFile" },
        main = "ibl",
        config = function()
            local highlight = {
                "RainbowRed",
                "RainbowYellow",
                "RainbowBlue",
                "RainbowOrange",
                "RainbowGreen",
                "RainbowViolet",
                "RainbowCyan",
            }
            local hooks = require("ibl.hooks")
            -- create the highlight groups in the highlight setup hook, so they are reset
            -- every time the colorscheme changes
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
                vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
                vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
                vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
                vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
                vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
                vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
            end)

            vim.g.rainbow_delimiters = { highlight = highlight }
            require("ibl").setup({ scope = { highlight = highlight } })

            hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
        end,
    },
    {
        "stevearc/dressing.nvim",
        lazy = true,
        opts = {
            input = {
                win_options = { winblend = 0 },
            },
        },
        init = function()
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },
    {
        "sphamba/smear-cursor.nvim",

        opts = {
            -- Smear cursor when switching buffers or windows.
            smear_between_buffers = true,

            -- Smear cursor when moving within line or to neighbor lines.
            -- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
            smear_between_neighbor_lines = true,

            -- Draw the smear in buffer space instead of screen space when scrolling
            scroll_buffer_space = true,

            -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
            -- Smears will blend better on all backgrounds.
            legacy_computing_symbols_support = false,

            -- Smear cursor in insert mode.
            -- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
            smear_insert_mode = true,

            time_interval = 10,

            stiffness = 0.75,

            trailing_stiffness = 0.1,
            trailing_exponent = 2,

            slowdown_exponent = 0.1,
            distance_stop_animating = 0.5,
        },
    },
}
