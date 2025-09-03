require "core"
vim.opt.relativenumber=true
local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

vim.api.nvim_create_user_command('Lopen', function()
  vim.diagnostic.setloclist({open = true})
end, {})

vim.keymap.set('n', '<leader>l', function()
  vim.diagnostic.setloclist({open = true})
end, {desc = "Open diagnostic location list"})


function CopyCurrentDiagnostic()
  local pos = vim.api.nvim_win_get_cursor(0)  -- {line, col}
  local line = pos[1] - 1  -- Lua index (0-based)
  local diagnostics = vim.diagnostic.get(0, {lnum = line})
  if #diagnostics == 0 then
    print("No diagnostic here!")
    return
  end
  local msg = diagnostics[1].message
  vim.fn.setreg('+', msg)  -- Copy to system clipboard (register '+')
  print("Copied diagnostic: " .. msg)
end
vim.keymap.set('n', '<leader>y', CopyCurrentDiagnostic, {desc = "Copy diagnostic message"})

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"
