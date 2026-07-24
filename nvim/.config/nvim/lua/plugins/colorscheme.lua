return {
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.nord_contrast = false
      vim.g.nord_borders = false
      vim.g.nord_disable_background = false
      vim.g.nord_cursorline_transparent = false
      vim.g.nord_italic = true
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "nord",
        callback = function()
          vim.api.nvim_set_hl(0, "Normal", { bg = "#0F0F11" })
          vim.api.nvim_set_hl(0, "NormalNC", { bg = "#0F0F11" })
          vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#0F0F11" })
        end,
      })
      vim.cmd.colorscheme("nord")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nord",
    },
  },
}
