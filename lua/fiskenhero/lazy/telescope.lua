return {
    "nvim-telescope/telescope.nvim",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        require('telescope').setup({})
        local builtin = require('telescope.builtin')

        local function find_files_from_git_root()
            local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
            if git_root and vim.fn.isdirectory(git_root) == 1 then
                builtin.find_files({ cwd = git_root })
            else
                builtin.find_files()
            end
        end

        vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[S]earch [F]iles" })
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
        vim.keymap.set("n", "<leader>/", function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)

        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)

        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)

        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>fp', find_files_from_git_root, { desc = "Find files from project root" })
    end
}
