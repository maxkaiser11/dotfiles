return {
  "ellisonleao/gruvbox.nvim",
  opts = {
    contrast = "soft",
    italic = { strings = false },
    overrides = {
      ["@variable.parameter"] = { fg = "#d3869b", italic = true }, -- purple italic params
      ["@lsp.type.parameter"] = { fg = "#d3869b", italic = true },
      ["@lsp.type.interface"] = { link = "@type" },               -- interfaces yellow like types
    },
  },
}
