require("lean").setup({
  infoview = {
    orientation = "vertical",
  },
})
vim.keymap.set("n", "<leader>\\", ":LeanAbbreviationsReverseLookup")
