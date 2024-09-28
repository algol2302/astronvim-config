-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = {
        source = "always", -- Or "if_many"
        prefix = "⚠", -- Could be '■', '▎', 'x'
      },
      underline = true,
      severity_sort = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = false, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = true, -- sets vim.opt.spell
        spelllang = { "en", "ru" },
        signcolumn = "auto", -- sets vim.opt.signcolumn to auto
        wrap = false, -- sets vim.opt.wrap
        termguicolors = true,
        showtabline = 4,
        tabstop = 4,
        softtabstop = 4,
        shiftwidth = 4,
        colorcolumn = "120",
        clipboard = "unnamedplus",
        list = true,
        listchars = "eol:↲,tab:▏ ,trail:·,space:·,extends:<,precedes:>,conceal:┊,nbsp:␣",
        langmap = "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯЖ;ABCDEFGHIJKLMNOPQRSTUVWXYZ:,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz",
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
        autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
        cmp_enabled = true, -- enable completion at start
        autopairs_enabled = true, -- enable autopairs at start
        diagnostics_mode = 3, -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
        icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
        ui_notifications_enabled = true, -- disable notifications when toggling UI elements
        -- tabby_keybinding_accept = "<Tab>",
      },
      o = {
        background = "light",
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs with `H` and `L`
        L = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        H = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<Leader>b"] = { desc = "Buffers" },
        -- quick save
        -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
        ["<Leader>c"] = {
          function()
            local bufs = vim.fn.getbufinfo { buflisted = true }
            require("astrocore.buffer").close(0)
            if require("astrocore").is_available "alpha-nvim" and not bufs[2] then require("alpha").start(true) end
          end,
          desc = "Close buffer",
        },
        -- ["<leader>gm"] = { "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle current line blame" },
        ["<leader>xT"] = { "<cmd>TodoTrouble<cr>", desc = "TODOs (Trouble)" },
        ["<leader>td"] = {
          function() require("astrocore").toggle_term_cmd "lazydocker" end,
          desc = "ToggleTerm lazydocker",
        },
        ["<leader>tg"] = {
          function() require("astrocore").toggle_term_cmd "gitui" end,
          desc = "ToggleTerm gitui",
        },
        ["<leader>tk"] = {
          function() require("astrocore").toggle_term_cmd "k9s" end,
          desc = "ToggleTerm k9s",
        },
        ["<leader>tf"] = { "<cmd>ToggleTerm direction=float<cr><cmd>setlocal nospell<cr>", desc = "ToggleTerm float" },
        ["<leader>th"] = {
          "<cmd>ToggleTerm size=10 direction=horizontal<cr><cmd>setlocal nospell<cr>",
          desc = "ToggleTerm horizontal split",
        },
        ["<leader>tH"] = {
          "<cmd>2ToggleTerm size=10 direction=horizontal<cr><cmd>setlocal nospell<cr>",
          desc = "Second ToggleTerm horizontal split",
        },
        ["<leader>tv"] = {
          "<cmd>ToggleTerm size=80 direction=vertical<cr><cmd>setlocal nospell<cr>",
          desc = "ToggleTerm vertical split",
        },
        ["<leader>tV"] = {
          "<cmd>2ToggleTerm size=80 direction=vertical<cr><cmd>setlocal nospell<cr>",
          desc = "Second ToggleTerm vertical split",
        },
        ["<leader>lw"] = {
          function() vim.cmd "silent! wa" end,
          desc = "Save all renamed buffers",
        },
        ["<leader>gm"] = { "<cmd>BlameToggle virtual<cr>", desc = "Toggle blame right" },
        ["<leader>gB"] = { "<cmd>BlameToggle<cr>", desc = "Toggle blame window" },

        ["<leader>bf"] = {
          "<cmd>Neotree filesystem reveal left reveal_force_cwd<cr>",
          desc = "Toggle current file dir",
        },
        ["<leader>fp"] = { "<cmd>Telescope projects<cr>", desc = "Find a project" },
        ["<leader>f;"] = { "<cmd>vimgrep /t.Run(/g %<cr><cr>", desc = "Show all go subtests in quickfix list" },
        ["<leader>gh"] = { "<cmd>Telescope git_file_history<cr>", desc = "Show current file commits" },
      },
      t = {
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
      },
    },
  },
}
