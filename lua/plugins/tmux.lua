-- Tmux integration for opening horizontal/vertical panes
-- Keybindings:
--   <Leader>Th  - Open tmux pane horizontally (left/right)
--   <Leader>Tv  - Open tmux pane vertically (top/bottom)

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = function(_, opts)
      local maps = opts.mappings or {}
      local n = maps.n or {}

      n["<Leader>Th"] = {
        function() require("helpers.tmux-utils").open_horizontal() end,
        desc = "Open tmux horizontal pane",
      }

      n["<Leader>Tv"] = {
        function() require("helpers.tmux-utils").open_vertical() end,
        desc = "Open tmux vertical pane",
      }

      maps.n = n
      opts.mappings = maps

      return opts
    end,
  },
}
