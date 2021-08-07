require('lspconfig').pylsp.setup{
   settings = {
       pylsp = {
           configurationSources = "flake8",
           plugins = {
                 flake8 = {
                     enabled = true,
                     maxLineLength = 120
                 },
                 pycodestyle = {
                  enabled = false
                }
            }
        }
    }
}

require'lspconfig'.pyright.setup{}
