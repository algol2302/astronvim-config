-- Tmux integration for running Go tests
-- Keybindings:
--   <Leader>Th  - Open tmux pane horizontally (left/right)
--   <Leader>Tv  - Open tmux pane vertically (top/bottom)
--   <Leader>Tr  - Run current Go test in docker-compose (Go only)

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = function(_, opts)
      local maps = opts.mappings or {}
      local n = maps.n or {}

      -- Pane management
      n["<Leader>Th"] = {
        function() require("helpers.tmux-utils").open_horizontal() end,
        desc = "Open tmux horizontal pane",
      }

      n["<Leader>Tv"] = {
        function() require("helpers.tmux-utils").open_vertical() end,
        desc = "Open tmux vertical pane",
      }

      -- Run current Go test
      n["<Leader>Tr"] = {
        function() require("helpers.tmux-utils").run_go_test() end,
        desc = "Run current Go test in docker-compose",
      }

      maps.n = n
      opts.mappings = maps

      return opts
    end,
  },
}
