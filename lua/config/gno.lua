vim.cmd("autocmd BufRead,BufNewFile *.gno set filetype=gno")
vim.treesitter.language.register("go", "gno")

-- Format Gno File
local function gno_fmt()
  local file = vim.fn.expand("%")
  vim.fn.system("gofumpt -e -w " .. file)
  vim.cmd("edit!")
  vim.cmd("set syntax=go")
  print("Formated " .. file)
end

-- UserCmd for use gno_fmt
vim.api.nvim_create_user_command("GnoFmt", gno_fmt, {})

-- Autocmds for Gno file
local gno_augroup = vim.api.nvim_create_augroup("gno_autocmd", { clear = true })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.gno",
  command = "set syntax=go",
  group = gno_augroup,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.gno",
  callback = function()
    gno_fmt()
    print("BufWritePost called for " .. vim.fn.expand("%"))
  end,
  group = gno_augroup,
})
