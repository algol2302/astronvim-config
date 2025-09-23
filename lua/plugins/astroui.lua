-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      -- change colorscheme
      colorscheme = "astrodark",
      -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
      highlights = {
        init = { -- this table overrides highlights in all themes
          -- Normal = { bg = "#000000" },
        },
        astrodark = { -- a table of overrides/changes when applying the astrotheme theme
          -- Normal = { bg = "#000000" },
        },
      },
      -- Icons can be configured throughout the interface
      icons = {
        -- configure the loading of the lsp in the status line
        LSPLoading1 = "⠋",
        LSPLoading2 = "⠙",
        LSPLoading3 = "⠹",
        LSPLoading4 = "⠸",
        LSPLoading5 = "⠼",
        LSPLoading6 = "⠴",
        LSPLoading7 = "⠦",
        LSPLoading8 = "⠧",
        LSPLoading9 = "⠇",
        LSPLoading10 = "⠏",
      },
    },
  },

  {
    "rmehri01/onenord.nvim",
    enable = true,
    config = function()
      local colors = require("onenord.colors").load()
      require("onenord").setup {
        theme = "light", -- "dark" or "light". Alternatively, remove the option and set vim.o.background instead
        borders = true, -- Split window borders
        fade_nc = false, -- Fade non-current windows, making them more distinguishable
        -- Style that is applied to various groups: see `highlight-args` for options
        styles = {
          comments = "italic",
          strings = "NONE",
          keywords = "NONE",
          functions = "italic",
          variables = "NONE",
          diagnostics = "underline",
        },
        disable = {
          background = false, -- Disable setting the background color
          float_background = false, -- Disable setting the background color for floating windows
          cursorline = false, -- Disable the cursorline
          eob_lines = true, -- Hide the end-of-buffer lines
        },
        -- Inverse highlight for different groups
        inverse = {
          match_paren = false,
        },
        custom_highlights = {
          ["@lsp.type.variable.go"] = { fg = "none" },
          ["@lsp.typemod.variable.readonly.go"] = { style = "italic" },
          ["@lsp.type.namespace.go"] = { fg = "#BA793E", style = "italic" },
        },
        -- Overwrite default colors
        custom_colors = {
          warn = "#e5af21",
          green = "#3e6f39",
          blue = "#244ab2",
          cyan = "#448d97",
          highlight = "#d3d3d3", -- "#EAEBED"
        },
      }
    end,
  },

  { "p00f/alabaster.nvim" },
}
