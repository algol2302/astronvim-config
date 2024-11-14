return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    -- override the options table that is used
    opts = function(_, opts)
      -- opts parameter is the default options table
      -- the function is lazy loaded so cmp is able to be required
      -- modify the mapping part of the table
      opts.window.width = 40
      opts.filesystem.follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      }
      opts.filesystem.filtered_items = {
        visible = true,
        -- hide_dotfiles = false,
        -- hide_gitignored = false,
        -- hide_by_name = {
        --   ".DS_Store",
        --   "thumbs.db",
        --   "node_modules",
        --   "__pycache__",
        -- },
        -- hide_hidden = false,
      }
      opts.hijack_netrw_behavior = "open_current"
      opts.use_libuv_file_watcher = vim.fn.has "win32" ~= 1
      opts.bind_to_cwd = false -- true creates a 2-way binding between vim's cwd and neo-tree's root
    end,
  },
}
