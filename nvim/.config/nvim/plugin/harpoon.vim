nnoremap <leader>a :lua require("harpoon.mark").add_file()<CR>
nnoremap <C-e> :lua require("harpoon.ui").toggle_quick_menu()<CR>

nnoremap <C-a> :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <C-s> :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <C-d> :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <C-f> :lua require("harpoon.ui").nav_file(4)<CR>
nnoremap <leader>ju :lua require("harpoon.term").gotoTerminal(1)<CR>
nnoremap <leader>je :lua require("harpoon.term").gotoTerminal(2)<CR>
nnoremap <leader>ju :lua require("harpoon.term").sendCommand(1, 1)<CR>
nnoremap <leader>je :lua require("harpoon.term").sendCommand(1, 2)<CR>
