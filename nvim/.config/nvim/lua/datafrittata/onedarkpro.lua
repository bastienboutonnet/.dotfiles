local onedarkpro = require("onedarkpro")
onedarkpro.setup({
  -- Theme can be overwritten with 'onedark' or 'onelight' as a string!
  colors = {
      onedark = {
    bg = "#282c34",
    },
  },
  styles = {
      functions = "italic,bold", -- Style that is applied to functions
      keywords = "italic",
  },
  options = {
      cursorline = true,
  },
})
onedarkpro.load()
