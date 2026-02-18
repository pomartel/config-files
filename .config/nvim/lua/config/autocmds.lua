-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- only when nvim is opened with exactly one argument
    if vim.fn.argc() ~= 1 then
      return
    end
    local arg = vim.fn.argv(0)
    if vim.fn.isdirectory(arg) == 0 then
      return
    end
    -- switch cwd to that directory
    vim.cmd.cd(arg)
    -- open Snacks fuzzy finder (files picker)
    vim.schedule(function()
      require("snacks").picker.files()
    end)
  end,
})
