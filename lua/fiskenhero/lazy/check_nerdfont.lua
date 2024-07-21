local function check_nerd_font()
  local nerd_font_installed = vim.fn.has('multi_byte') == 1 and vim.fn.match(vim.fn.execute('echo "\\ue0a0"'), "^\\u") == -1
  return nerd_font_installed
end

vim.g.have_nerd_font = check_nerd_font()

return {
}

