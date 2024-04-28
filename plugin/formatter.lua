local util = require "formatter.util"

require("formatter").setup {
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    bash = {
      function()
        return {
          exe = "beautysh",
          args = { "-f", "-" },
          stdin = true,
        }
      end,
    },

    python = {
      function()
        return {
          exe = "black",
          args = { "-" },
          stdin = true,
        }
      end,
    },

    yaml = {
      function()
        return {
          exe = "prettier",
          args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
          stdin = true,
        }
      end,
    },

    lua = {
      require("formatter.filetypes.lua").stylua,

      function()
        if util.get_current_buffer_file_name() == "special.lua" then
          return nil
        end

        return {
          exe = "stylua",
          args = {
            "--search-parent-directories",
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
            "--",
            "-",
          },
          stdin = true,
        }
      end,
    },

    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace,
    },
  },
}
