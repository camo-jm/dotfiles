-- basic configuration
vim.cmd('set tgc cul nowrap nu sb sb scs spr sta vb list cc=80 ts=4 sw=4 so=10 siso=10 path+=**')

-- plugins
local vim = vim; local Plug = vim.fn['plug#']
Plugins = {'catppuccin/nvim', 'nvim-mini/mini.nvim', 'neovim/nvim-lspconfig'}
vim.call('plug#begin'); for _, p in ipairs(Plugins) do Plug(p) end; vim.call('plug#end')

-- mini.nvim plugins + language servers
Minis = {'files', 'move', 'pairs', 'surround', 'icons', 'statusline', 'tabline', 'bracketed'}
Ls = {'pyright', 'lua_ls', 'clangd', 'shellcheck'}

for _, m in ipairs(Minis) do require('mini.' .. m).setup() end
for _, l in ipairs(Ls) do vim.lsp.enable(l) end
vim.diagnostic.config({ virtual_text = true, signs = true, severity_sort = true })

vim.cmd('colorscheme catppuccin')
vim.g.mapleader = ' '; vim.keymap.set('n', '<leader>f', ':lua MiniFiles.open()<CR>')
