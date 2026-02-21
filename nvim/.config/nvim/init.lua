-- basic configuration
vim.cmd('set tgc cul nowrap nu sb sb scs spr sta vb cc=80 ts=10 sw=4 so=10 siso=10 path+=**')

-- downloading the plugins
local vim = vim; local Plug = vim.fn['plug#'] -- do gS in normal mode to unravel long tables
plugins = {'catppuccin/nvim', 'nvim-mini/mini.nvim', 'norcalli/nvim-colorizer.lua'}
vim.call('plug#begin'); for _, p in ipairs(plugins) do Plug(p) end; vim.call('plug#end')

-- setting up the plugins
minis = {'bracketed', 'files', 'splitjoin', 'move', 'jump', 'pairs', 'surround', 'operators', 'completion', 'icons', 'tabline', 'statusline', 'indentscope',}
for _, m in ipairs(minis) do require('mini.' .. m).setup() end
require('colorizer').setup{'*'}

-- plugin configuration
vim.g.mapleader = ' '; vim.keymap.set('n', '<leader>t', ':lua MiniFiles.open()\n')
vim.cmd('colorscheme catppuccin')
