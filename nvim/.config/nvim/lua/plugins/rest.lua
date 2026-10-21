return {
  "rest-nvim/rest.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "http")
    end,
  },
  ft = "http",
  keys = {
    { "<leader>Rr", "<cmd>Rest run<cr>", desc = "Run request" },
    { "<leader>Rl", "<cmd>Rest last<cr>", desc = "Run last request" },
  },
}
