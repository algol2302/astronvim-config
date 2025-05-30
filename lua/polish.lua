-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Set up custom filetypes
vim.filetype.add {
  extension = {
    foo = "fooscript",
  },
  filename = {
    ["Foofile"] = "fooscript",
  },
  pattern = {
    ["~/%.config/foo/.*"] = "fooscript",
  },
}

vim.api.nvim_create_user_command(
  "AstroRootInfo",
  function() require("astrocore.rooter").info() end,
  { desc = "Display rooter information" }
)
vim.api.nvim_create_user_command(
  "AstroRoot",
  function() require("astrocore.rooter").root() end,
  { desc = "Run root detection" }
)

-- neo-tree on start up
-- vim.api.nvim_create_augroup("neotree_autoopen", { clear = true })
-- vim.api.nvim_create_autocmd("BufRead", { -- Changed from BufReadPre
--   desc = "Open neo-tree on enter",
--   group = "neotree_autoopen",
--   once = true,
--   callback = function()
--     if not vim.g.neotree_opened then
--       vim.cmd "Neotree show"
--       vim.g.neotree_opened = true
--     end
--   end,
-- })
