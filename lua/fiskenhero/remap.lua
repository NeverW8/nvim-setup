vim.g.mapleader = ","
vim.keymap.set("n", "<leader>o", vim.cmd.Ex)
vim.keymap.set("n", "<leader>w", vim.cmd.w)
vim.keymap.set("n", " ", "/")

-- Nerdtree
vim.keymap.set("n", "<leader>n", vim.cmd.NvimTreeToggle)

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- hax
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Telescope FF
--local builtin = require "telescope.builtin"
--vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
--vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})

--asd
vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd "so"
end)

vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-a>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

vim.keymap.set("i", "<Tab>", "<Tab>")
vim.keymap.set("n", "<leader>1", function()
  vim.cmd "Copilot enable"
  vim.notify("Copilot enabled")
end)
vim.keymap.set("n", "<leader>2", function()
  vim.cmd "Copilot disable"
  vim.notify("Copilot Fired...")
end)

-- new tab with leader + t
vim.keymap.set("n", "<leader>t", vim.cmd.tabnew)

-- nvim lsp formatting
vim.keymap.set("n", "<leader>c", vim.lsp.buf.format)

-- copy to system clipboard
vim.keymap.set("v", "<leader>v", [["+y]])

-- run :Format in visual mode to format the selected text
vim.keymap.set("v", "<leader>b", ":Format<CR>")
vim.keymap.set("n", "<leader>b", ":FormatWrite<CR>")

-- Yamllint, imagine working with Kubernetes
--vim.api.nvim_buf_set_keymap(0, "n", "<leader>yl", ":!yamllint %<CR>", { noremap = true, silent = true })
