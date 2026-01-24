-- Tmux integration for running Go tests
-- Keybindings:
--   <Leader>Th  - Open tmux pane horizontally (left/right)
--   <Leader>Tv  - Open tmux pane vertically (top/bottom)
--   <Leader>Tr  - Run current Go test in docker-compose (Go only)
--   <Leader>Tf  - Run all tests in current file
--   <Leader>Tp  - Run all tests in current package
--   <Leader>Ta  - Run all tests in the project

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

      -- Run all tests in current file
      n["<Leader>Tf"] = {
        function() require("helpers.tmux-utils").run_go_file_tests() end,
        desc = "Run all tests in current file",
      }

      -- Run all tests in current package
      n["<Leader>Tp"] = {
        function() require("helpers.tmux-utils").run_go_package_tests() end,
        desc = "Run all tests in current package",
      }

      -- Run all tests in the project
      n["<Leader>Ta"] = {
        function() require("helpers.tmux-utils").run_go_project_tests() end,
        desc = "Run all tests in project",
      }

      maps.n = n
      opts.mappings = maps

      return opts
    end,
  },
}
