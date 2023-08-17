-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map
    -- mappings seen under group name "Buffer"
    ["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>bc"] = { "<cmd>BufferLinePickClose<cr>", desc = "Pick to close" },
    ["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
    ["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },
    -- quick save
    -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
    -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command

    ["<leader>c"] = {
      function()
        local bufs = vim.fn.getbufinfo { buflisted = true }
        require("astronvim.utils.buffer").close()
        if require("astronvim.utils").is_available "alpha-nvim" and not bufs[2] then require("alpha").start(true) end
      end,
      desc = "Close buffer",
    },
    -- ["<leader>gm"] = { "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle current line blame" },
    ["<leader>xT"] = { "<cmd>TodoTrouble<cr>", desc = "TODOs (Trouble)" },
    ["<leader>td"] = {
      function() require("astronvim.utils").toggle_term_cmd "lazydocker" end,
      desc = "ToggleTerm lazydocker",
    },
    ["<leader>lw"] = {
      function() vim.cmd "silent! wa" end,
      desc = "Save all renamed buffers",
    },
    ["<leader>gm"] = { "<cmd>ToggleBlame virtual<cr>", desc = "Toggle blame" },
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
    -- ["<leader>lr"] = false,
  },
}
