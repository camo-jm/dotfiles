-- basic configuration
vim.cmd('set tgc cul nowrap nu sb sb scs spr sta vb list cc=80 ts=4 sw=4 so=10 siso=10 path+=**')

-- plugins
vim.pack.add({
	'https://github.com/catppuccin/nvim',
	'https://github.com/nvim-mini/mini.nvim',
	'https://github.com/neovim/nvim-lspconfig'
})

-- mini.nvim plugins + language servers
Minis = {'files', 'move', 'pairs', 'surround', 'icons', 'statusline', 'tabline', 'bracketed'}
Ls = {'pyright', 'lua_ls', 'clangd'} -- 'shellcheck'

for _, m in ipairs(Minis) do require('mini.' .. m).setup() end
for _, l in ipairs(Ls) do vim.lsp.enable(l) end
vim.diagnostic.config({ virtual_text = true, signs = true, severity_sort = true })

vim.lsp.config("lua_ls", {
	settings = { Lua = { workspace = { library = { "${3rd}/love2d/library",
}, }, }, }

})

-- more
vim.cmd('colorscheme catppuccin')
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>f', ':lua MiniFiles.open()<CR>')
