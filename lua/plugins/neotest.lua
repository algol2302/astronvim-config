return {
  -- Neotest setup
  {
    "neotest",
    {
      "fredrikaverpil/neotest-golang", -- Installation
      version = "*",
      dependencies = {
        "leoluz/nvim-dap-go",
      },
    },
    opts = function(_, opts)
      local neotest_golang_opts = { -- Specify configuration
        runner = "docker-compose exec app go",
        go_test_args = {
          "-v",
          "-race",
          "-count=1",
          "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
        },
      }
      opts.opts.adapters = opts.adapters or {}
      opts.adapters["neotest-golang"](neotest_golang_opts)
    end,
  },
}
