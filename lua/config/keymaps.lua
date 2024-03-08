vim.g.mapleader = " "

-- Swap keys
vim.keymap.set("", "j", "h")
vim.keymap.set("", "k", "j")
vim.keymap.set("", "l", "k")
vim.keymap.set("", ";", "l")
vim.keymap.set("", "h", ";")

vim.keymap.set("i", "<C-h>", "<BS>")

vim.keymap.set("n", "<leader><leader>", "<C-^>", { desc = "previous file" })

vim.keymap.set({ "n", "x" }, "gd", '"_d', { desc = "delete without updating registers" })

vim.keymap.set(
    "n",
    "gs",
    ":%s/\\<<C-r><C-w>\\>//g<Left><Left>",
    { desc = "replace word under cursor" }
)
vim.keymap.set("x", "gs", 'y:%s/\\V<C-r>"//g<Left><Left>', { desc = "replace selection" })

-- Center after jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- Do not update jump list
vim.keymap.set("n", "{", "<Cmd>keepjumps normal! {<CR>")
vim.keymap.set("n", "}", "<Cmd>keepjumps normal! }<CR>")

-- Move to window
vim.keymap.set("n", "<C-w>j", "<C-w>h")
vim.keymap.set("n", "<C-w>k", "<C-w>j")
vim.keymap.set("n", "<C-w>l", "<C-w>k")
vim.keymap.set("n", "<C-w>;", "<C-w>l")

-- Move through tabs
vim.keymap.set("n", "<S-h>", "<Cmd>tabprevious<CR>")
vim.keymap.set("n", "<S-l>", "<Cmd>tabnext<CR>")

-- Resize window
vim.keymap.set("n", "<C-Up>", "<Cmd>resize +2<CR>")
vim.keymap.set("n", "<C-Down>", "<Cmd>resize -2<CR>")
vim.keymap.set("n", "<C-Left>", "<Cmd>vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", "<Cmd>vertical resize +2<CR>")

-- Move lines
vim.keymap.set("x", "<C-l>", ":move '<-2<CR>gv=gv")
vim.keymap.set("x", "<C-k>", ":move '>+1<CR>gv=gv")

-- Exit terminal mode
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>")

-- Spell
vim.keymap.set("n", "<leader>ce", ":setlocal spell spelllang=en_us<CR>")
vim.keymap.set("n", "<leader>cn", ":setlocal spell spelllang=<CR>")
vim.keymap.set("n", "<leader>cf", ":setlocal spell spelllang=fr<CR>")
