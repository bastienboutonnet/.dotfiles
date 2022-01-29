require("datafrittata.telescope")
require("datafrittata.lspsaga")
require("datafrittata.lspconfig")
require("datafrittata.gitsigns")
require("datafrittata.bufferline")
require("datafrittata.onedarkpro")
P = function(v)
  print(vim.inspect(v))
  return v
end

if pcall(require, 'plenary') then
  RELOAD = require('plenary.reload').reload_module

  R = function(name)
    RELOAD(name)
    return require(name)
  end
end
